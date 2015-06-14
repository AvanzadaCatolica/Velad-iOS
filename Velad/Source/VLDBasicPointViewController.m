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

@interface VLDBasicPointViewController () <VLDErrorPresenterDataSource>

@property (nonatomic, readonly) VLDBasicPoint *basicPoint;
@property (nonatomic) VLDErrorPresenter *errorPresenter;

- (void)setupFormDescriptor;
- (void)setupBasicPoint:(VLDBasicPoint *)basicPoint;
- (void)setupNavigationItem;
- (void)onTapDoneButton:(id)sender;
- (void)onTapCancelButton:(id)sender;

@end

static NSString * const kRowDescriptorName = @"VLDRowDescriptorName";
static NSString * const kRowDescriptorDescription = @"VLDRowDescriptorDescription";
static NSString * const kRowDescriptorAlert = @"VLDRowDescriptorAlert";

@implementation VLDBasicPointViewController

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    if (self.basicPoint) {
        rowDescriptor = [XLFormRowDescriptor formRowDescriptorWithTag:kRowDescriptorAlert
                                                              rowType:XLFormRowDescriptorTypeButton
                                                                title:@"Alertas"];
        rowDescriptor.action.formSelector = @selector(onTapAlertButton:);
        [rowDescriptor.cellConfig setObject:@(NSTextAlignmentLeft) forKey:@"textLabel.textAlignment"];
        [rowDescriptor.cellConfig setObject:@(UITableViewCellAccessoryDisclosureIndicator) forKey:@"accessoryType"];
        [sectionDescriptor addFormRow:rowDescriptor];
    }
    
    self.form = formDescriptor;
}

- (void)setupBasicPoint:(VLDBasicPoint *)basicPoint {
    XLFormRowDescriptor *nameFormRowDescriptor = [self.form formRowWithTag:kRowDescriptorName];
    nameFormRowDescriptor.value = basicPoint.name;
    if (![basicPoint.descriptionText vld_isEmpty]) {
        XLFormRowDescriptor *descriptionFormRowDescriptor = [self.form formRowWithTag:kRowDescriptorDescription];
        descriptionFormRowDescriptor.value = basicPoint.descriptionText;
    }
}

- (void)setupNavigationItem {
    self.navigationItem.title = @"Punto Básico";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                           target:self
                                                                                           action:@selector(onTapDoneButton:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                          target:self
                                                                                          action:@selector(onTapCancelButton:)];
}

- (void)bind:(VLDBasicPoint *)basicPoint {
    basicPoint.name = self.form.formValues[kRowDescriptorName];
    if (self.form.formValues[@"VLDRowDescriptorDescription"] != [NSNull null]) {
        basicPoint.descriptionText = self.form.formValues[kRowDescriptorDescription];
    } else {
        basicPoint.descriptionText = @"";
    }
}

- (void)onTapDoneButton:(id)sender {
    NSError *error = [[self formValidationErrors] firstObject];
    if (error) {
        [self.errorPresenter presentError:error];
        return;
    }
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    
    if (self.basicPoint) {
        [self bind:self.basicPoint];
    }
    else {
        VLDBasicPoint *basicPoint = [[VLDBasicPoint alloc] init];
        basicPoint.UUID = [[NSUUID UUID] UUIDString];
        basicPoint.enabled = YES;
        basicPoint.order = [VLDBasicPoint allObjects].count;
        [self bind:basicPoint];
        [realm addObject:basicPoint];
    }
    
    [realm commitWriteTransaction];
    
    if ([self.delegate respondsToSelector:@selector(basicPointViewController:didFinishEditingBasicPoint:)]) {
        [self.delegate basicPointViewController:self didFinishEditingBasicPoint:self.basicPoint];
    }
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (void)onTapCancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
    if ([self.delegate respondsToSelector:@selector(basicPointViewControllerDidCancelEditing:)]) {
        [self.delegate basicPointViewControllerDidCancelEditing:self];
    }
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

@end
