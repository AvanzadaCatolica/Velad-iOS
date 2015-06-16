//
//  VLDBasicPointAlertViewController.m
//  Velad
//
//  Created by Renzo Crisóstomo on 14/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "VLDBasicPointAlertViewController.h"
#import "VLDBasicPoint.h"
#import "VLDErrorPresenter.h"
#import "VLDNotificationScheduler.h"
#import "VLDAlert.h"
#import "UIColor+VLDAdditions.h"
#import "VLDDeleteAlertPresenter.h"

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
            return [NSString stringWithFormat:@"%ld días", (long)array.count];
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

@interface VLDBasicPointAlertViewController () <VLDErrorPresenterDataSource, VLDDeleteAlertPresenterDataSource, VLDDeleteAlertPresenterDelegate>

@property (nonatomic) VLDBasicPoint *basicPoint;
@property (nonatomic) VLDErrorPresenter *errorPresenter;
@property (nonatomic) VLDNotificationScheduler *notificationScheduler;
@property (nonatomic) VLDDeleteAlertPresenter *deleteAlertPresenter;

- (void)setupFormDescriptor;
- (void)setupNavigationItem;
- (void)onTapSaveButton:(id)sender;
- (void)onTapCancelButton:(id)sender;
- (void)requestPermission;

@end

static NSString * const kRowDescriptorTime = @"VLDRowDescriptorTime";
static NSString * const kRowDescriptorInterval = @"VLDRowDescriptorInterval";
static NSString * const kRowDescriptorDelete = @"VLDRowDescriptorDelete";

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
    [self requestPermission];
}

#pragma mark - Setup methods

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
    
    if (self.basicPoint.alert) {
        sectionDescriptor = [XLFormSectionDescriptor formSection];
        [formDescriptor addFormSection:sectionDescriptor];
        
        rowDescriptor = [XLFormRowDescriptor formRowDescriptorWithTag:kRowDescriptorDelete
                                                              rowType:XLFormRowDescriptorTypeButton
                                                                title:@"Eliminar alertas"];
        rowDescriptor.action.formSelector = @selector(onTapDeleteButton:);
        [rowDescriptor.cellConfig setObject:[UIColor vld_mainColor] forKey:@"textLabel.textColor"];
        [sectionDescriptor addFormRow:rowDescriptor];
    }
    
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

#pragma mark - Private methods

- (void)requestPermission {
    UIApplication *application = [UIApplication sharedApplication];
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound) categories:nil];
        [application registerUserNotificationSettings:settings];
    }
}

- (VLDErrorPresenter *)errorPresenter {
    if (_errorPresenter == nil) {
        _errorPresenter = [[VLDErrorPresenter alloc] initWithDataSource:self];
    }
    return _errorPresenter;
}

- (VLDNotificationScheduler *)notificationScheduler {
    if (_notificationScheduler == nil) {
        _notificationScheduler = [[VLDNotificationScheduler alloc] init];
    }
    return _notificationScheduler;
}

- (VLDDeleteAlertPresenter *)deleteAlertPresenter {
    if (_deleteAlertPresenter == nil) {
        _deleteAlertPresenter = [[VLDDeleteAlertPresenter alloc] initWithDataSource:self];
        _deleteAlertPresenter.delegate = self;
    }
    return _deleteAlertPresenter;
}

- (void)onTapSaveButton:(id)sender {
    NSError *error = [[self formValidationErrors] firstObject];
    if (error) {
        [self.errorPresenter presentError:error];
        return;
    }
    UIApplication *application = [UIApplication sharedApplication];
    if ([application respondsToSelector:@selector(currentUserNotificationSettings)]) {
        UIUserNotificationSettings *grantedSettings = [application currentUserNotificationSettings];
        if (grantedSettings.types == UIUserNotificationTypeNone) {
            [self.errorPresenter presentError:[NSError errorWithDomain:NSStringFromClass(self.class)
                                                                  code:INT_MAX
                                                              userInfo:@{@"NSLocalizedDescription" : @"Las notificaciones están deshabilitadas"}]];
        }
    }
    [self.notificationScheduler scheduleNotificationForBasicPoint:self.basicPoint
                                                             time:self.form.formValues[kRowDescriptorTime]
                                                             days:self.form.formValues[kRowDescriptorInterval]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onTapCancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onTapDeleteButton:(id)sender {
    [self.deleteAlertPresenter present];
}

#pragma mark - VLDErrorPresenterDataSource

- (UIViewController *)viewControllerForErrorPresenter:(VLDErrorPresenter *)presenter {
    return self;
}

#pragma mark - VLDDeleteAlertPresenterDataSource

- (UIViewController *)viewControllerForDeleteAlarmPresenter:(VLDDeleteAlertPresenter *)presenter {
    return self;
}

#pragma mark - VLDDeleteAlertPresenterDelegate

- (void)deleteAlarmPresenterDidSelectDelete:(VLDDeleteAlertPresenter *)presenter {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    
    [realm deleteObject:self.basicPoint.alert];
    
    [realm commitWriteTransaction];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)deleteAlarmPresenterDidCancelDelete:(VLDDeleteAlertPresenter *)presenter {
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
}

@end
