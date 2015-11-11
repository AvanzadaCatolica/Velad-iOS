//
//  VLDGroupViewController.m
//  Velad
//
//  Created by Renzo Crisóstomo on 01/08/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "VLDGroupViewController.h"
#import "VLDErrorPresenter.h"
#import "VLDGroup.h"
#import <Realm/Realm.h>

@interface VLDGroupViewController () <VLDErrorPresenterDataSource>

@property (nonatomic, readonly) VLDGroup *group;
@property (nonatomic) VLDErrorPresenter *errorPresenter;

- (void)setupFormDescriptor;
- (void)setupGroup:(VLDGroup *)group;
- (void)setupNavigationItem;
- (void)onTapSaveButton:(id)sender;
- (void)onTapCancelButton:(id)sender;
- (void)bind:(VLDGroup *)group;

@end

static NSString * const kRowDescriptorName = @"VLDRowDescriptorName";

@implementation VLDGroupViewController

#pragma mark - Life cycle

- (instancetype)initWithGroup:(VLDGroup *)group {
    self = [super init];
    if (self) {
        _group = group;
        [self setupFormDescriptor];
        [self setupGroup:group];
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
    
    self.form = formDescriptor;
}

- (void)setupGroup:(VLDGroup *)group {
    XLFormRowDescriptor *nameFormRowDescriptor = [self.form formRowWithTag:kRowDescriptorName];
    nameFormRowDescriptor.value = group.name;
}

- (void)setupNavigationItem {
    self.navigationItem.title = @"Grupo";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                                           target:self
                                                                                           action:@selector(onTapSaveButton:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                          target:self
                                                                                          action:@selector(onTapCancelButton:)];
}

- (void)bind:(VLDGroup *)group {
    group.name = self.form.formValues[kRowDescriptorName];
}

- (void)onTapSaveButton:(id)sender {
    NSError *error = [[self formValidationErrors] firstObject];
    if (error) {
        [self.errorPresenter presentError:error];
        return;
    }
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    
    if (self.group) {
        [self bind:self.group];
    }
    else {
        VLDGroup *group = [[VLDGroup alloc] init];
        group.order = [VLDGroup allObjects].count;
        [self bind:group];
        [realm addObject:group];
    }
    
    [realm commitWriteTransaction];
    
    if ([self.delegate respondsToSelector:@selector(groupViewController:didFinishEditingGroup:)]) {
        [self.delegate groupViewController:self didFinishEditingGroup:self.group];
    }
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (void)onTapCancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

#pragma mark - VLDErrorPresenterDataSource

- (UIViewController *)viewControllerForErrorPresenter:(VLDErrorPresenter *)presenter {
    return self;
}

@end
