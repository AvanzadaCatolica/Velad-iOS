//
//  VLDBasicPointViewController.m
//  Velad
//
//  Created by Renzo Crisóstomo on 14/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "VLDBasicPointViewController.h"
#import "VLDBasicPoint.h"
#import "NSString+VLDAdditions.h"
#import <Realm/Realm.h>
#import "VLDErrorPresenter.h"
#import "VLDBasicPointAlertViewController.h"
#import "VLDAlert.h"
#import "VLDWeekdayArrayValueTrasformer.h"
#import "VLDWeekdayArrayValidator.h"

@interface VLDBasicPointViewController () <VLDErrorPresenterDataSource>

@property (nonatomic, readonly) VLDBasicPoint *basicPoint;
@property (nonatomic) VLDErrorPresenter *errorPresenter;

- (void)setupFormDescriptor;
- (void)setupBasicPoint:(VLDBasicPoint *)basicPoint;
- (void)setupNavigationItem;
- (void)onTapSaveButton:(id)sender;
- (void)onTapCancelButton:(id)sender;
- (XLFormRowDescriptor *)alertsRowDescriptor;
- (void)bind:(VLDBasicPoint *)basicPoint;

@end

static NSString * const kRowDescriptorName = @"VLDRowDescriptorName";
static NSString * const kRowDescriptorDescription = @"VLDRowDescriptorDescription";
static NSString * const kRowDescriptorFrequency = @"VLDRowDescriptorFrequency";
static NSString * const kRowDescriptorEnabled = @"VLDRowDescriptorEnabled";
static NSString * const kRowDescriptorAlert = @"VLDRowDescriptorAlert";

@implementation VLDBasicPointViewController

#pragma mark - Life cycle

- (instancetype)initWithBasicPoint:(VLDBasicPoint *)basicPoint {
    self = [super init];
    if (self) {
        _basicPoint = basicPoint;
        [self setupFormDescriptor];
        [self setupBasicPoint:basicPoint];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationItem];
}

#pragma mark - Private methods

- (VLDErrorPresenter *)errorPresenter {
    if (_errorPresenter == nil) {
        _errorPresenter = [[VLDErrorPresenter alloc] initWithDataSource:self];
    }
    return _errorPresenter;
}

- (void)setupFormDescriptor {
    XLFormDescriptor *formDescriptor;
    XLFormSectionDescriptor *sectionDescriptor;
    XLFormRowDescriptor *rowDescriptor;
    
    formDescriptor = [XLFormDescriptor formDescriptor];
    
    sectionDescriptor = [XLFormSectionDescriptor formSection];
    [formDescriptor addFormSection:sectionDescriptor];
    
    rowDescriptor = [XLFormRowDescriptor formRowDescriptorWithTag:kRowDescriptorName
                                                          rowType:XLFormRowDescriptorTypeText
                                                            title:@"Nombre"];
    rowDescriptor.required = YES;
    [rowDescriptor.cellConfigAtConfigure setObject:@(NSTextAlignmentRight)
                                            forKey:@"textField.textAlignment"];
    [sectionDescriptor addFormRow:rowDescriptor];
    
    rowDescriptor = [XLFormRowDescriptor formRowDescriptorWithTag:kRowDescriptorDescription
                                                          rowType:XLFormRowDescriptorTypeText
                                                            title:@"Descripción"];
    [rowDescriptor.cellConfigAtConfigure setObject:@(NSTextAlignmentRight)
                                            forKey:@"textField.textAlignment"];
    [sectionDescriptor addFormRow:rowDescriptor];
    
    rowDescriptor = [XLFormRowDescriptor formRowDescriptorWithTag:kRowDescriptorFrequency
                                                          rowType:XLFormRowDescriptorTypeMultipleSelector
                                                            title:@"Frecuencia"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"es"];
    rowDescriptor.selectorOptions = [dateFormatter weekdaySymbols];
    rowDescriptor.valueTransformer = [VLDWeekdayArrayValueTrasformer class];
    rowDescriptor.selectorTitle = @"Días";
    rowDescriptor.value = self.basicPoint ? [self.basicPoint weekDaySymbols] : @[];
    [rowDescriptor addValidator:[[VLDWeekdayArrayValidator alloc] init]];
    [sectionDescriptor addFormRow:rowDescriptor];
    
    rowDescriptor = [XLFormRowDescriptor formRowDescriptorWithTag:kRowDescriptorEnabled
                                                          rowType:XLFormRowDescriptorTypeBooleanSwitch
                                                            title:@"Habilitado"];
    [sectionDescriptor addFormRow:rowDescriptor];
    
    self.form = formDescriptor;
}

- (void)setupBasicPoint:(VLDBasicPoint *)basicPoint {
    XLFormRowDescriptor *nameFormRowDescriptor = [self.form formRowWithTag:kRowDescriptorName];
    nameFormRowDescriptor.value = basicPoint.name;
    if (![basicPoint.descriptionText vld_isEmpty]) {
        XLFormRowDescriptor *descriptionFormRowDescriptor = [self.form formRowWithTag:kRowDescriptorDescription];
        descriptionFormRowDescriptor.value = basicPoint.descriptionText;
    }
    XLFormRowDescriptor *enabledFormRowDescriptor = [self.form formRowWithTag:kRowDescriptorEnabled];
    enabledFormRowDescriptor.value = basicPoint ? @(basicPoint.enabled) : @(YES);
}

- (void)setupNavigationItem {
    self.navigationItem.title = @"Punto";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                                           target:self
                                                                                           action:@selector(onTapSaveButton:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                          target:self
                                                                                          action:@selector(onTapCancelButton:)];
}

- (XLFormRowDescriptor *)alertsRowDescriptor {
    XLFormRowDescriptor *rowDescriptor = [XLFormRowDescriptor formRowDescriptorWithTag:kRowDescriptorAlert
                                                          rowType:XLFormRowDescriptorTypeButton
                                                            title:@"Alertas"];
    rowDescriptor.action.formSelector = @selector(onTapAlertButton:);
    [rowDescriptor.cellConfig setObject:@(NSTextAlignmentLeft) forKey:@"textLabel.textAlignment"];
    [rowDescriptor.cellConfig setObject:@(UITableViewCellAccessoryDisclosureIndicator) forKey:@"accessoryType"];
    return rowDescriptor;
}

- (void)bind:(VLDBasicPoint *)basicPoint {
    basicPoint.name = self.form.formValues[kRowDescriptorName];
    
    if (self.form.formValues[@"VLDRowDescriptorDescription"] != [NSNull null]) {
        basicPoint.descriptionText = self.form.formValues[kRowDescriptorDescription];
    } else {
        basicPoint.descriptionText = @"";
    }
    
    [basicPoint.weekDays removeAllObjects];
    NSArray *days = self.form.formValues[kRowDescriptorFrequency];
    for (NSString *day in days) {
        VLDWeekDay *weekDay = [[VLDWeekDay alloc] init];
        weekDay.name = day;
        [basicPoint.weekDays addObject:weekDay];
    }
    
    basicPoint.enabled = [self.form.formValues[kRowDescriptorEnabled] boolValue];
}

- (void)onTapSaveButton:(id)sender {
    NSError *error = [[self formValidationErrors] firstObject];
    if (error) {
        [self.errorPresenter presentError:error];
        return;
    }
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    
    VLDBasicPoint *basicPoint;
    
    if (self.basicPoint) {
        [self bind:self.basicPoint];
        basicPoint = self.basicPoint;
    }
    else {
        basicPoint = [[VLDBasicPoint alloc] init];
        basicPoint.UUID = [[NSUUID UUID] UUIDString];
        [self bind:basicPoint];
        [realm addObject:basicPoint];
    }
    if (!basicPoint.isEnabled && basicPoint.alert) {
        [basicPoint.alert deleteAlertOnRealm:realm];
        [realm deleteObject:basicPoint.alert];
    }
    
    [realm commitWriteTransaction];
    
    if ([self.delegate respondsToSelector:@selector(basicPointViewController:didFinishEditingBasicPoint:)]) {
        [self.delegate basicPointViewController:self didFinishEditingBasicPoint:basicPoint];
    }
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (void)onTapCancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (void)onTapAlertButton:(id)sender {
    VLDBasicPointAlertViewController *viewController = [[VLDBasicPointAlertViewController alloc] initWithBasicPoint:self.basicPoint];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - VLDErrorPresenterDataSource

- (UIViewController *)viewControllerForErrorPresenter:(VLDErrorPresenter *)presenter {
    return self;
}

#pragma mark - XLFormDescriptorDelegate

- (void)formRowDescriptorValueHasChanged:(XLFormRowDescriptor *)formRow oldValue:(id)oldValue newValue:(id)newValue {
    [super formRowDescriptorValueHasChanged:formRow oldValue:oldValue newValue:newValue];
    if ([formRow.tag isEqualToString:kRowDescriptorEnabled]) {
        BOOL enabled = [newValue boolValue];
        if (enabled) {
            [self.form addFormRow:[self alertsRowDescriptor] afterRowTag:kRowDescriptorEnabled];
        } else {
            [self.form removeFormRowWithTag:kRowDescriptorAlert];
        }
    }
}

@end
