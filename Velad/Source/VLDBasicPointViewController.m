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
#import "VLDFormErrorPresenter.h"

@interface VLDBasicPointViewController () <VLDFormErrorPresenterDataSource>

@property (nonatomic, readonly) VLDBasicPoint *basicPoint;
@property (nonatomic) VLDFormErrorPresenter *formErrorPresenter;

- (void)setupFormDescriptor;
- (void)setupBasicPoint:(VLDBasicPoint *)basicPoint;
- (void)setupNavigationItem;
- (void)onTapDoneButton:(id)sender;
- (void)onTapCancelButton:(id)sender;

@end

static NSString * const kRowDescriptorName = @"VLDRowDescriptorName";
static NSString * const kRowDescriptorDescription = @"VLDRowDescriptorDescription";

@implementation VLDBasicPointViewController

- (instancetype)initWithBasicPoint:(VLDBasicPoint *)basicPoint {
    self = [super init];
    if (self) {
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

- (VLDFormErrorPresenter *)formErrorPresenter {
    if (_formErrorPresenter == nil) {
        _formErrorPresenter = [[VLDFormErrorPresenter alloc] initWithDataSource:self];
    }
    return _formErrorPresenter;
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
    
    self.form = formDescriptor;
}

- (void)setupBasicPoint:(VLDBasicPoint *)basicPoint {
    _basicPoint = basicPoint;
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

- (void)onTapDoneButton:(id)sender {
    NSError *error = [[self formValidationErrors] firstObject];
    if (error) {
        [self.formErrorPresenter presentError:error];
        return;
    }
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    self.basicPoint.name = self.form.formValues[kRowDescriptorName];
    if (self.form.formValues[@"VLDRowDescriptorDescription"] != [NSNull null]) {
        self.basicPoint.descriptionText = self.form.formValues[kRowDescriptorDescription];
    } else {
        self.basicPoint.descriptionText = @"";
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
}

#pragma mark - VLDFormErrorPresenterDataSource

- (UIViewController *)viewControllerForFormErrorPresenter:(VLDFormErrorPresenter *)presenter {
    return self;
}

@end
