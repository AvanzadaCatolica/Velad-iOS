//
//  VLDConfigurationViewController.m
//  Velad
//
//  Created by Renzo Crisóstomo on 13/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "VLDConfigurationViewController.h"
#import "VLDProfileViewController.h"

@interface VLDConfigurationViewController ()

- (void)setupFormDescriptor;
- (void)onTapProfileButton:(id)button;
- (void)onTapSecurityButton:(id)button;
- (void)onTapOpinionButton:(id)button;
- (void)setupNavigationItem;

@end

static NSString * const kRowDescriptorProfile = @"VLDRowDescriptorProfile";
static NSString * const kRowDescriptorSecurity = @"VLDRowDescriptorSecurity";
static NSString * const kRowDescriptorOpinion = @"VLDRowDescriptorOpinion";

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
    rowDescriptor.action.formSelector = @selector(onTapProfileButton:);
    [rowDescriptor.cellConfig setObject:@(NSTextAlignmentLeft) forKey:@"textLabel.textAlignment"];
    [rowDescriptor.cellConfig setObject:@(UITableViewCellAccessoryDisclosureIndicator) forKey:@"accessoryType"];
    [sectionDescriptor addFormRow:rowDescriptor];
    
    rowDescriptor = [XLFormRowDescriptor formRowDescriptorWithTag:kRowDescriptorOpinion
                                                          rowType:XLFormRowDescriptorTypeButton
                                                            title:@"Danos tu opinión"];
    rowDescriptor.action.formSelector = @selector(onTapProfileButton:);
    [rowDescriptor.cellConfig setObject:@(NSTextAlignmentLeft) forKey:@"textLabel.textAlignment"];
    [rowDescriptor.cellConfig setObject:@(UITableViewCellAccessoryDisclosureIndicator) forKey:@"accessoryType"];
    [sectionDescriptor addFormRow:rowDescriptor];
    
    self.form = formDescriptor;
}

- (void)setupNavigationItem {
    self.navigationItem.title = @"Configuración";
}

#pragma mark - Private methods

- (void)onTapProfileButton:(id)button {
    VLDProfileViewController *viewController = [[VLDProfileViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)onTapSecurityButton:(id)button {
    
}

- (void)onTapOpinionButton:(id)button {
    
}

@end
