//
//  VLDConfigurationViewController.m
//  Velad
//
//  Created by Renzo Crisóstomo on 13/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "VLDConfigurationViewController.h"
#import "VLDProfileViewController.h"
#import <MessageUI/MessageUI.h>
#import "VLDErrorPresenter.h"
#import "VLDSecurityViewController.h"
#import <VTAcknowledgementsViewController/VTAcknowledgementsViewController.h>
#import "NSCalendar+VLDAdditions.h"
#import "VLDRestoreDataPresenter.h"
#include <Realm/Realm.h>
#import "VLDMigrationController.h"
#import "UIColor+VLDAdditions.h"

@interface VLDConfigurationViewController () <VLDErrorPresenterDataSource, MFMailComposeViewControllerDelegate, VLDRestoreDataPresenterDataSource, VLDRestoreDataPresenterDelegate>

@property (nonatomic) VLDErrorPresenter *errorPresenter;
@property (nonatomic) VLDRestoreDataPresenter *restoreDataPresenter;

- (void)setupFormDescriptor;
- (void)onTapProfileButton:(id)button;
- (void)onTapSecurityButton:(id)button;
- (void)onTapOpinionButton:(id)button;
- (void)onTapLicensesButton:(id)button;
- (void)setupNavigationItem;

@end

static NSString * const kRowDescriptorProfile = @"VLDRowDescriptorProfile";
static NSString * const kRowDescriptorSecurity = @"VLDRowDescriptorSecurity";
static NSString * const kRowDescriptorCalendarPreference = @"VLDRowDescriptorCalendarPreference";
static NSString * const kRowDescriptorRestoreData = @"VLDRowDescriptorRestoreData";
static NSString * const kRowDescriptorOpinion = @"VLDRowDescriptorOpinion";
static NSString * const kRowDescriptorLicenses = @"VLDRowDescriptorLicenses";
static NSString * const kRowDescriptorVersion = @"VLDRowDescriptorVersion";

NSString *const VLDCalendarShouldStartOnMondayConfigurationDidChangeNotification = @"VLDCalendarShouldStartOnMondayConfigurationDidChangeNotification";

@implementation VLDConfigurationViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupFormDescriptor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationItem];
}

#pragma mark - Setup methods

- (void)setupFormDescriptor {
    XLFormDescriptor *formDescriptor;
    XLFormSectionDescriptor *sectionDescriptor;
    XLFormRowDescriptor *rowDescriptor;
    
    formDescriptor = [XLFormDescriptor formDescriptor];
    
    sectionDescriptor = [XLFormSectionDescriptor formSection];
    [formDescriptor addFormSection:sectionDescriptor];
    
    rowDescriptor = [XLFormRowDescriptor formRowDescriptorWithTag:kRowDescriptorProfile
                                                          rowType:XLFormRowDescriptorTypeButton
                                                            title:@"Perfil"];
    rowDescriptor.action.formSelector = @selector(onTapProfileButton:);
    [rowDescriptor.cellConfig setObject:@(NSTextAlignmentLeft) forKey:@"textLabel.textAlignment"];
    [rowDescriptor.cellConfig setObject:@(UITableViewCellAccessoryDisclosureIndicator) forKey:@"accessoryType"];
    [sectionDescriptor addFormRow:rowDescriptor];
    
    rowDescriptor = [XLFormRowDescriptor formRowDescriptorWithTag:kRowDescriptorSecurity
                                                          rowType:XLFormRowDescriptorTypeButton
                                                            title:@"Seguridad"];
    rowDescriptor.action.formSelector = @selector(onTapSecurityButton:);
    [rowDescriptor.cellConfig setObject:@(NSTextAlignmentLeft) forKey:@"textLabel.textAlignment"];
    [rowDescriptor.cellConfig setObject:@(UITableViewCellAccessoryDisclosureIndicator) forKey:@"accessoryType"];
    [sectionDescriptor addFormRow:rowDescriptor];
    
    sectionDescriptor = [XLFormSectionDescriptor formSection];
    [formDescriptor addFormSection:sectionDescriptor];
    rowDescriptor = [XLFormRowDescriptor formRowDescriptorWithTag:kRowDescriptorCalendarPreference
                                                          rowType:XLFormRowDescriptorTypeBooleanSwitch
                                                            title:@"Empezar el lunes"];
    rowDescriptor.value = @([[NSUserDefaults standardUserDefaults] boolForKey:VLDCalendarShouldStartOnMondayKey]);
    [sectionDescriptor addFormRow:rowDescriptor];
    sectionDescriptor.footerTitle = @"Al estar seleccionado, todos los intervalos semanales empezarán el día lunes.\n\nCaso contrario, se usará la configuración de región del dispositivo.";
    
    sectionDescriptor = [XLFormSectionDescriptor formSection];
    [formDescriptor addFormSection:sectionDescriptor];
    
    rowDescriptor = [XLFormRowDescriptor formRowDescriptorWithTag:kRowDescriptorRestoreData
                                                          rowType:XLFormRowDescriptorTypeButton
                                                            title:@"Restaurar información"];
    rowDescriptor.action.formSelector = @selector(onTapRestoreData:);
    [rowDescriptor.cellConfig setObject:[UIColor vld_mainColor] forKey:@"textLabel.textColor"];
    [sectionDescriptor addFormRow:rowDescriptor];
    
    sectionDescriptor = [XLFormSectionDescriptor formSection];
    [formDescriptor addFormSection:sectionDescriptor];
    
    rowDescriptor = [XLFormRowDescriptor formRowDescriptorWithTag:kRowDescriptorOpinion
                                                          rowType:XLFormRowDescriptorTypeButton
                                                            title:@"Danos tu opinión"];
    rowDescriptor.action.formSelector = @selector(onTapOpinionButton:);
    [rowDescriptor.cellConfig setObject:@(NSTextAlignmentLeft) forKey:@"textLabel.textAlignment"];
    [rowDescriptor.cellConfig setObject:@(UITableViewCellAccessoryDisclosureIndicator) forKey:@"accessoryType"];
    [sectionDescriptor addFormRow:rowDescriptor];
    
    sectionDescriptor = [XLFormSectionDescriptor formSection];
    [formDescriptor addFormSection:sectionDescriptor];
    
    rowDescriptor = [XLFormRowDescriptor formRowDescriptorWithTag:kRowDescriptorLicenses
                                                          rowType:XLFormRowDescriptorTypeButton
                                                            title:@"Licencias"];
    rowDescriptor.action.formSelector = @selector(onTapLicensesButton:);
    [rowDescriptor.cellConfig setObject:@(NSTextAlignmentLeft) forKey:@"textLabel.textAlignment"];
    [rowDescriptor.cellConfig setObject:@(UITableViewCellAccessoryDisclosureIndicator) forKey:@"accessoryType"];
    [sectionDescriptor addFormRow:rowDescriptor];
    
    rowDescriptor = [XLFormRowDescriptor formRowDescriptorWithTag:kRowDescriptorVersion
                                                          rowType:XLFormRowDescriptorTypeInfo];
    rowDescriptor.title = @"Versión";
    rowDescriptor.value = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [sectionDescriptor addFormRow:rowDescriptor];
    
    self.form = formDescriptor;
}

- (void)setupNavigationItem {
    self.navigationItem.title = @"Configuración";
}

#pragma mark - Private methods

- (VLDErrorPresenter *)errorPresenter {
    if (_errorPresenter == nil) {
        _errorPresenter = [[VLDErrorPresenter alloc] initWithDataSource:self];
    }
    return _errorPresenter;
}

- (VLDRestoreDataPresenter *)restoreDataPresenter {
    if (_restoreDataPresenter == nil) {
        _restoreDataPresenter = [[VLDRestoreDataPresenter alloc] initWithDataSource:self];
        _restoreDataPresenter.delegate = self;
    }
    return _restoreDataPresenter;
}

- (void)onTapProfileButton:(id)button {
    VLDProfileViewController *viewController = [[VLDProfileViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)onTapSecurityButton:(id)button {
    VLDSecurityViewController *viewController = [[VLDSecurityViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)onTapRestoreData:(id)button {
    [self.restoreDataPresenter present];
}

- (void)onTapOpinionButton:(id)button {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] init];
        [composeViewController.navigationBar setTintColor:[UIColor whiteColor]];
        composeViewController.mailComposeDelegate = self;
        [composeViewController setSubject:@"Sugerencias"];
        [composeViewController setToRecipients:@[@"mlopez@avanzadacatolica.org"]];
        [self presentViewController:composeViewController
                           animated:YES
                         completion:^{
                             [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
                         }];
    } else {
        [self.errorPresenter presentError:[NSError errorWithDomain:NSStringFromClass(self.class)
                                                              code:INT_MAX
                                                          userInfo:@{@"NSLocalizedDescription" : @"No se ha encontrado una cuenta de correo configurada"}]];
    }
}

- (void)onTapLicensesButton:(id)button {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Pods-Velad-acknowledgements" ofType:@"plist"];
    VTAcknowledgementsViewController *viewController = [[VTAcknowledgementsViewController alloc] initWithAcknowledgementsPlistPath:path];
    viewController.headerText = @"Velad está hecho con software open source.";
    viewController.navigationItem.title = @"Licencias";
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - VLDErrorPresenterDataSource

- (UIViewController *)viewControllerForErrorPresenter:(VLDErrorPresenter *)presenter {
    return self;
}

#pragma mark - XLFormDescriptorDelegate

-(void)formRowDescriptorValueHasChanged:(XLFormRowDescriptor *)formRow oldValue:(id)oldValue newValue:(id)newValue {
    [super formRowDescriptorValueHasChanged:formRow oldValue:oldValue newValue:newValue];
    if ([formRow.tag isEqualToString:kRowDescriptorCalendarPreference]) {
        BOOL calendarShouldStartOnMonday = [newValue boolValue];
        [[NSUserDefaults standardUserDefaults] setBool:calendarShouldStartOnMonday forKey:VLDCalendarShouldStartOnMondayKey];
        [[NSNotificationCenter defaultCenter] postNotificationName:VLDCalendarShouldStartOnMondayConfigurationDidChangeNotification object:nil];
    }
}

#pragma mark - VLDRestoreDataPresenterDataSource

- (UIViewController *)viewControllerForRestoreDataPresenter:(VLDRestoreDataPresenter *)presenter {
    return self;
}

#pragma mark - VLDRestoreDataPresenterDelegate

- (void)restoreDataPresenterDidAccept:(VLDRestoreDataPresenter *)presenter {
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
    
    VLDMigrationController *migrationController = [[VLDMigrationController alloc] init];
    [migrationController deleteAllData];
    [migrationController seedDatabase];
}

- (void)restoreDataPresenterDidCancel:(VLDRestoreDataPresenter *)presenter {
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
}

@end
