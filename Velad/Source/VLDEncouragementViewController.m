//
//  VLDEncouragementViewController.m
//  Velad
//
//  Created by Renzo Crisóstomo on 07/02/16.
//  Copyright © 2016 MAC. All rights reserved.
//

#import "VLDEncouragementViewController.h"
#import "VLDEncouragement.h"
#import "UIColor+VLDAdditions.h"

@interface VLDEncouragementViewController ()

@property (nonatomic) VLDEncouragement *encouragement;

- (void)setupEncouragement;
- (void)setupFormDescriptor;
- (void)setupNavigationItem;
- (void)bind:(VLDEncouragement *)encouragement;
- (void)onTapSaveButton:(id)sender;
- (void)onTapCancelButton:(id)sender;

@end

static NSString * const kRowDescriptorSetActive = @"VLDRowDescriptorSetActive";
static NSString * const kRowDescriptorPercentage = @"VLDRowDescriptorPercentage";

@implementation VLDEncouragementViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupEncouragement];
        [self setupFormDescriptor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationItem];
}

#pragma mark - Setup methods

- (void)setupEncouragement {
    _encouragement = [[VLDEncouragement allObjects] firstObject];
}

- (void)setupFormDescriptor {
    XLFormDescriptor *formDescriptor;
    XLFormSectionDescriptor *sectionDescriptor;
    XLFormRowDescriptor *rowDescriptor;
    
    formDescriptor = [XLFormDescriptor formDescriptor];
    
    sectionDescriptor = [XLFormSectionDescriptor formSection];
    [formDescriptor addFormSection:sectionDescriptor];
    
    if (self.encouragement.isEnabled) {
        rowDescriptor = [XLFormRowDescriptor formRowDescriptorWithTag:kRowDescriptorPercentage
                                                              rowType:XLFormRowDescriptorTypeSelectorPickerView
                                                                title:@"Porcentaje"];
        rowDescriptor.selectorOptions = @[[XLFormOptionsObject formOptionsObjectWithValue:@(10) displayText:@"10%"],
                                          [XLFormOptionsObject formOptionsObjectWithValue:@(20) displayText:@"20%"],
                                          [XLFormOptionsObject formOptionsObjectWithValue:@(30) displayText:@"30%"],
                                          [XLFormOptionsObject formOptionsObjectWithValue:@(40) displayText:@"40%"],
                                          [XLFormOptionsObject formOptionsObjectWithValue:@(50) displayText:@"50%"],
                                          [XLFormOptionsObject formOptionsObjectWithValue:@(60) displayText:@"60%"],
                                          [XLFormOptionsObject formOptionsObjectWithValue:@(70) displayText:@"70%"],
                                          [XLFormOptionsObject formOptionsObjectWithValue:@(80) displayText:@"80%"],
                                          [XLFormOptionsObject formOptionsObjectWithValue:@(90) displayText:@"90%"],
                                          [XLFormOptionsObject formOptionsObjectWithValue:@(100) displayText:@"100%"],];
        rowDescriptor.value = [XLFormOptionsObject formOptionsObjectWithValue:@(self.encouragement.percentage)
                                                                  displayText:[@(self.encouragement.percentage).stringValue stringByAppendingString:@"%"]];
        [sectionDescriptor addFormRow:rowDescriptor];
    }
    
    rowDescriptor = [XLFormRowDescriptor formRowDescriptorWithTag:kRowDescriptorSetActive
                                                          rowType:XLFormRowDescriptorTypeButton
                                                            title:self.encouragement.isEnabled ? @"Desactivar" : @"Activar"];
    rowDescriptor.action.formSelector = @selector(onTapSetActiveButton:);
    [rowDescriptor.cellConfig setObject:[UIColor vld_mainColor] forKey:@"textLabel.textColor"];
    [sectionDescriptor addFormRow:rowDescriptor];
    
    formDescriptor.delegate = self;
    self.form = formDescriptor;
}

- (void)setupNavigationItem {
    self.navigationItem.title = @"Ánimo";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                                           target:self
                                                                                           action:@selector(onTapSaveButton:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                          target:self
                                                                                          action:@selector(onTapCancelButton:)];
}

#pragma mark - Private methods

- (void)bind:(VLDEncouragement *)encouragement {
    XLFormOptionsObject *percentageValue = [self.form.formValues[kRowDescriptorPercentage] formValue];
    if (percentageValue && (NSNull *)percentageValue != [NSNull null]) {
        self.encouragement.percentage = [percentageValue.valueData integerValue];
    }
}

- (void)onTapSetActiveButton:(id)sender {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    self.encouragement.enabled = !self.encouragement.enabled;
    [realm commitWriteTransaction];
    
    
    [self setupFormDescriptor];
    [self.tableView reloadData];
}

- (void)onTapSaveButton:(id)sender {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [self bind:self.encouragement];
    [realm commitWriteTransaction];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onTapCancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
