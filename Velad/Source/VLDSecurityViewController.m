//
//  VLDSecurityViewController.m
//  Velad
//
//  Created by Renzo Crisóstomo on 16/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "VLDSecurityViewController.h"
#import "VLDSecurity.h"
#import "UIColor+VLDAdditions.h"
#import "VLDSetActiveSecurityPresenter.h"
#import "VLDSecurityPasscodeViewController.h"
#import <SSKeychain/SSKeychain.h>

@interface VLDSecurityViewController () <VLDSetActiveSecurityPresenterDataSource, VLDSetActiveSecurityPresenterDelegate, VLDSecurityPasscodeViewControllerDelegate, XLFormDescriptorDelegate>

@property (nonatomic) VLDSecurity *security;
@property (nonatomic) VLDSetActiveSecurityPresenter *setActiveSecurityPresenter;

- (void)setupSecurity;
- (void)setupFormDescriptor;
- (void)setupNavigationItem;
- (void)onTapChangePasscodeButton:(id)sender;
- (void)onTapSetActiveButton:(id)sender;
- (void)toggleSecurity;

@end

static NSString * const kRowDescriptorChangePasscode = @"VLDRowDescriptorChangePasscode";
static NSString * const kRowDescriptorRequestPasscode = @"VLDRowDescriptorRequestPasscode";
static NSString * const kRowDescriptorSetActive = @"VLDRowDescriptorSetActive";

@implementation VLDSecurityViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupSecurity];
        [self setupFormDescriptor];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationItem];
}

#pragma mark - Setup methods

- (void)setupSecurity {
    _security = [[VLDSecurity allObjects] firstObject];
}

- (void)setupFormDescriptor {
    XLFormDescriptor *formDescriptor;
    XLFormSectionDescriptor *sectionDescriptor;
    XLFormRowDescriptor *rowDescriptor;
    
    formDescriptor = [XLFormDescriptor formDescriptor];
    
    if (self.security.isEnabled) {
        
        sectionDescriptor = [XLFormSectionDescriptor formSection];
        [formDescriptor addFormSection:sectionDescriptor];
        
        rowDescriptor = [XLFormRowDescriptor formRowDescriptorWithTag:kRowDescriptorChangePasscode
                                                              rowType:XLFormRowDescriptorTypeButton
                                                                title:@"Cambiar contraseña"];
        rowDescriptor.action.formSelector = @selector(onTapChangePasscodeButton:);
        [rowDescriptor.cellConfig setObject:@(NSTextAlignmentLeft) forKey:@"textLabel.textAlignment"];
        [rowDescriptor.cellConfig setObject:@(UITableViewCellAccessoryDisclosureIndicator) forKey:@"accessoryType"];
        [sectionDescriptor addFormRow:rowDescriptor];
        
        rowDescriptor = [XLFormRowDescriptor formRowDescriptorWithTag:kRowDescriptorRequestPasscode
                                                              rowType:XLFormRowDescriptorTypeSelectorPush
                                                                title:@"Solicitar contraseña"];
        rowDescriptor.selectorOptions = [VLDSecurity stateSymbols];
        rowDescriptor.required = YES;
        rowDescriptor.selectorTitle = @"Solicitar contraseña";
        rowDescriptor.value = self.security.isEnabled ? [VLDSecurity symbolForState:self.security.state] : @"";
        [sectionDescriptor addFormRow:rowDescriptor];
        
        sectionDescriptor.footerTitle = @"Al iniciar: Se le solicitará la contraseña al abrir la aplicación por primera vez, solo se volverá a solicitar si la aplicación es terminada de la multitarea.\n\nAl abrir: Se le solicitará la contraseña cada vez que abra la aplicación. Puede ser un poco molesto pero es el modo más seguro.";

    }
    
    sectionDescriptor = [XLFormSectionDescriptor formSection];
    [formDescriptor addFormSection:sectionDescriptor];
    
    rowDescriptor = [XLFormRowDescriptor formRowDescriptorWithTag:kRowDescriptorSetActive
                                                          rowType:XLFormRowDescriptorTypeButton
                                                            title:self.security.isEnabled ? @"Desactivar seguridad" : @"Activar seguridad"];
    rowDescriptor.action.formSelector = @selector(onTapSetActiveButton:);
    [rowDescriptor.cellConfig setObject:[UIColor vld_mainColor] forKey:@"textLabel.textColor"];
    [sectionDescriptor addFormRow:rowDescriptor];
    
    formDescriptor.delegate = self;
    
    self.form = formDescriptor;
}

- (void)setupNavigationItem {
    self.navigationItem.title = @"Seguridad";
}

#pragma mark - Private methods

- (VLDSetActiveSecurityPresenter *)setActiveSecurityPresenter {
    if (_setActiveSecurityPresenter == nil) {
        _setActiveSecurityPresenter = [[VLDSetActiveSecurityPresenter alloc] initWithDataSource:self];
        _setActiveSecurityPresenter.delegate = self;
    }
    return _setActiveSecurityPresenter;
}

- (void)onTapChangePasscodeButton:(id)sender {
    VLDSecurityPasscodeViewController *viewController = [[VLDSecurityPasscodeViewController alloc] initWithMode:VLDSecurityPasscodeViewControllerModeReRecord];
    viewController.delegate = self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)onTapSetActiveButton:(id)sender {
    [self.setActiveSecurityPresenter present];
}

- (void)toggleSecurity {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    
    self.security.enabled = !self.security.enabled;
    self.security.state = VLDSecurityStateOnColdStart;
    
    [realm commitWriteTransaction];
}

#pragma mark - VLDSetActiveSecurityPresenterDataSource

- (UIViewController *)viewControllerForSetActiveSecurityPresenter:(VLDSetActiveSecurityPresenter *)presenter {
    return self;
}

#pragma mark - VLDSetActiveSecurityPresenterDelegate

- (void)setActiveSecurityPresenterDidAccept:(VLDSetActiveSecurityPresenter *)presenter {
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
    VLDSecurityPasscodeViewController *viewController;
    if (self.security.isEnabled) {
        viewController = [[VLDSecurityPasscodeViewController alloc] initWithMode:VLDSecurityPasscodeViewControllerModeRequest];
    } else {
        viewController = [[VLDSecurityPasscodeViewController alloc] initWithMode:VLDSecurityPasscodeViewControllerModeCleanRecord];
    }
    viewController.delegate = self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)setActiveSecurityPresenterDidCancel:(VLDSetActiveSecurityPresenter *)presenter {
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
}

#pragma mark - VLDSecurityPasscodeViewControllerDelegate

- (void)securityPasscodeViewControllerDidFinish:(VLDSecurityPasscodeViewController *)viewController {
    if (viewController.mode == VLDSecurityPasscodeViewControllerModeCleanRecord) {
        [self toggleSecurity];
    } else if (viewController.mode == VLDSecurityPasscodeViewControllerModeRequest) {
        [SSKeychain deletePasswordForService:VLDKeychainService
                                     account:VLDKeychainAccount];
        [self toggleSecurity];
    }
    [self setupFormDescriptor];
    [self.tableView reloadData];
}

#pragma mark - XLFormDescriptorDelegate

- (void)formRowDescriptorValueHasChanged:(XLFormRowDescriptor *)formRow
                                oldValue:(id)oldValue
                                newValue:(id)newValue {
    if ([formRow.tag isEqualToString:kRowDescriptorRequestPasscode]) {
        NSString *symbol = newValue;
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        
        self.security.state = [VLDSecurity stateForSymbol:symbol];
        
        [realm commitWriteTransaction];
    }
}

@end
