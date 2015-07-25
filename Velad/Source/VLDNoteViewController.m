//
//  VLDNoteViewController.m
//  Velad
//
//  Created by Renzo Crisóstomo on 14/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "VLDNoteViewController.h"
#import "VLDNote.h"
#import <XLForm/XLForm.h>
#import "VLDErrorPresenter.h"
#import <Realm/Realm.h>

@interface VLDNoteViewController () <VLDErrorPresenterDataSource>

@property (nonatomic) VLDNote *note;
@property (nonatomic) VLDErrorPresenter *errorPresenter;

- (void)setupFormDescriptor;
- (void)setupNavigationItem;
- (void)bind:(VLDNote *)note;
- (void)onTapSaveButton:(id)sender;
- (void)onTapCancelButton:(id)sender;

@end

static NSString * const kRowDescriptorText = @"VLDRowDescriptorText";
static NSString * const kRowDescriptorState = @"VLDRowDescriptorState";

@implementation VLDNoteViewController

#pragma mark - Life cycle

- (instancetype)initWithNote:(VLDNote *)note {
    self = [super init];
    if (self) {
        _note = note;
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
    
    rowDescriptor = [XLFormRowDescriptor formRowDescriptorWithTag:kRowDescriptorText
                                                          rowType:XLFormRowDescriptorTypeTextView
                                                            title:@"Nota"];
    [rowDescriptor.cellConfigAtConfigure setObject:@(NSTextAlignmentRight) forKey:@"textView.textAlignment"];
    rowDescriptor.value = self.note ? self.note.text : @"";
    rowDescriptor.required = YES;
    [sectionDescriptor addFormRow:rowDescriptor];
    
    rowDescriptor = [XLFormRowDescriptor formRowDescriptorWithTag:kRowDescriptorState
                                                          rowType:XLFormRowDescriptorTypeSelectorPush
                                                            title:@"Tipo"];
    rowDescriptor.selectorOptions = [VLDNote stateSymbols];
    rowDescriptor.selectorTitle = @"Tipo";
    rowDescriptor.value = self.note ? [VLDNote symbolForState:self.note.state] : [VLDNote stateSymbols][0];
    rowDescriptor.required = YES;
    [sectionDescriptor addFormRow:rowDescriptor];
    
    self.form = formDescriptor;
}

- (void)setupNavigationItem {
    self.navigationItem.title = @"Nota";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                                           target:self
                                                                                           action:@selector(onTapSaveButton:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                          target:self
                                                                                          action:@selector(onTapCancelButton:)];
}

#pragma mark - Private methods

- (VLDErrorPresenter *)errorPresenter {
    if (_errorPresenter == nil) {
        _errorPresenter = [[VLDErrorPresenter alloc] initWithDataSource:self];
    }
    return _errorPresenter;
}

- (void)bind:(VLDNote *)note {
    NSString *text = self.form.formValues[kRowDescriptorText];
    note.text = [text stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    note.state = [VLDNote stateForSymbol:self.form.formValues[kRowDescriptorState]];
}

- (void)onTapSaveButton:(id)sender {
    NSError *error = [[self formValidationErrors] firstObject];
    if (error) {
        [self.errorPresenter presentError:error];
        return;
    }
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    
    if (self.note) {
        [self bind:self.note];
    }
    else {
        VLDNote *note = [[VLDNote alloc] init];
        note.date = [NSDate date];
        [self bind:note];
        [realm addObject:note];
    }
    
    [realm commitWriteTransaction];
    if ([self.delegate respondsToSelector:@selector(noteViewControllerDidChangeProperties:)]) {
        [self.delegate noteViewControllerDidChangeProperties:self];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onTapCancelButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(noteViewControllerDidCancelEditing:)]) {
        [self.delegate noteViewControllerDidCancelEditing:self];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - VLDErrorPresenterDataSource

- (UIViewController *)viewControllerForErrorPresenter:(VLDErrorPresenter *)presenter {
    return self;
}

@end
