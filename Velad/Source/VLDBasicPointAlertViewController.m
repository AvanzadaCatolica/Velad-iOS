//
//  VLDBasicPointAlertViewController.m
//  Velad
//
//  Created by Renzo Crisóstomo on 14/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "VLDBasicPointAlertViewController.h"
#import "VLDBasicPoint.h"
#import "VLDFormErrorPresenter.h"
#import "VLDNotificationScheduler.h"
#import "VLDAlert.h"

@interface VLDWeekdayArrayValueTrasformer : NSValueTransformer
@end

@implementation VLDWeekdayArrayValueTrasformer

+ (Class)transformedValueClass {
    return [NSString class];
}

+ (BOOL)allowsReverseTransformation {
    return NO;
}

- (id)transformedValue:(id)value {
    if (!value) {
        return nil;
    }
    if ([value isKindOfClass:[NSArray class]]) {
        NSArray *array = (NSArray *)value;
        if (array.count == 1) {
            return [[array firstObject] capitalizedString];
        } else {
            return [NSString stringWithFormat:@"%d días", array.count];
        }
    }
    if ([value isKindOfClass:[NSString class]]) {
        return [value capitalizedString];
    }
    return nil;
}

@end

@interface VLDWeekdayArrayValidator : NSObject <XLFormValidatorProtocol>

@end

@implementation VLDWeekdayArrayValidator

- (XLFormValidationStatus *)isValid:(XLFormRowDescriptor *)row {
    if ([row.value count] >= 1) {
        return [XLFormValidationStatus formValidationStatusWithMsg:@"" status:YES rowDescriptor:row];
    }
    return [XLFormValidationStatus formValidationStatusWithMsg:@"Seleccione días de la semana" status:NO rowDescriptor:row];
}

@end

@interface VLDBasicPointAlertViewController () <VLDFormErrorPresenterDataSource>

@property (nonatomic) VLDBasicPoint *basicPoint;
@property (nonatomic) VLDFormErrorPresenter *formErrorPresenter;
@property (nonatomic) VLDNotificationScheduler *notificationScheduler;

- (void)setupFormDescriptor;
- (void)setupNavigationItem;
- (void)onTapSaveButton:(id)sender;
- (void)onTapCancelButton:(id)sender;

@end

static NSString * const kRowDescriptorTime = @"VLDRowDescriptorTime";
static NSString * const kRowDescriptorInterval = @"VLDRowDescriptorInterval";

@implementation VLDBasicPointAlertViewController

#pragma mark - Life cycle

- (instancetype)initWithBasicPoint:(VLDBasicPoint *)basicPoint {
    self = [super init];
    if (self) {
        _basicPoint = basicPoint;
        [self setupFormDescriptor];
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

- (VLDFormErrorPresenter *)formErrorPresenter {
    if (_formErrorPresenter == nil) {
        _formErrorPresenter = [[VLDFormErrorPresenter alloc] initWithDataSource:self];
    }
    return _formErrorPresenter;
}

- (VLDNotificationScheduler *)notificationScheduler {
    if (_notificationScheduler == nil) {
        _notificationScheduler = [[VLDNotificationScheduler alloc] init];
    }
    return _notificationScheduler;
}

- (void)setupFormDescriptor {
    XLFormDescriptor *formDescriptor;
    XLFormSectionDescriptor *sectionDescriptor;
    XLFormRowDescriptor *rowDescriptor;
    
    formDescriptor = [XLFormDescriptor formDescriptor];
    
    sectionDescriptor = [XLFormSectionDescriptor formSection];
    [formDescriptor addFormSection:sectionDescriptor];
    
    rowDescriptor = [XLFormRowDescriptor formRowDescriptorWithTag:kRowDescriptorTime
                                                          rowType:XLFormRowDescriptorTypeTimeInline
                                                            title:@"Hora"];
    rowDescriptor.value = self.basicPoint.alert ? self.basicPoint.alert.time : [NSDate date];
    [sectionDescriptor addFormRow:rowDescriptor];
    
    rowDescriptor = [XLFormRowDescriptor formRowDescriptorWithTag:kRowDescriptorInterval
                                                          rowType:XLFormRowDescriptorTypeMultipleSelector
                                                            title:@"Días"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"es"];
    rowDescriptor.selectorOptions = [dateFormatter weekdaySymbols];
    rowDescriptor.valueTransformer = [VLDWeekdayArrayValueTrasformer class];
    rowDescriptor.selectorTitle = @"Días";
    rowDescriptor.value = self.basicPoint.alert ? [self.basicPoint.alert weekDaySymbols] : @[];
    [rowDescriptor addValidator:[[VLDWeekdayArrayValidator alloc] init]];
    [sectionDescriptor addFormRow:rowDescriptor];
    
    self.form = formDescriptor;
}

- (void)setupNavigationItem {
    self.navigationItem.title = @"Alertas";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                                           target:self
                                                                                           action:@selector(onTapSaveButton:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                          target:self
                                                                                          action:@selector(onTapCancelButton:)];
}

- (void)onTapSaveButton:(id)sender {
    NSError *error = [[self formValidationErrors] firstObject];
    if (error) {
        [self.formErrorPresenter presentError:error];
        return;
    }
    [self.notificationScheduler scheduleNotificationForBasicPoint:self.basicPoint
                                                             time:self.form.formValues[kRowDescriptorTime]
                                                             days:self.form.formValues[kRowDescriptorInterval]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onTapCancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - VLDFormErrorPresenterDataSource

- (UIViewController *)viewControllerForFormErrorPresenter:(VLDFormErrorPresenter *)presenter {
    return self;
}

@end
