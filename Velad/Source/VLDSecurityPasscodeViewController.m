//
//  VLDSecurityPasscodeViewController.m
//  Velad
//
//  Created by Renzo Crisóstomo on 16/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "VLDSecurityPasscodeViewController.h"
#import <Masonry/Masonry.h>
#import <SSKeychain/SSKeychain.h>

@interface VLDSecurityPasscodeViewController () <UITextFieldDelegate>

@property (nonatomic, weak) UILabel *instructionsLabel;
@property (nonatomic, weak) UILabel *passcodeLabel;
@property (nonatomic, weak) UITextField *textField;
@property (nonatomic) NSString *lastRecord;

- (void)setupNavigationItem;
- (void)setupLayout;
- (void)setupView;
- (void)textFieldDidChangeEditing:(id)sender;
- (void)nextStep;
- (void)onTapCancelButton:(id)sender;

@end

static CGFloat const kVerticalSpacing = 44;
static NSUInteger const kPasscodeLength = 4;
NSString * const VLDKeychainService = @"VLDKeychainService";
NSString * const VLDKeychainAccount = @"VLDKeychainAccount";

@implementation VLDSecurityPasscodeViewController

- (instancetype)initWithMode:(VLDSecurityPasscodeViewControllerMode)mode {
    self = [super init];
    if (self) {
        _mode = mode;
    }
    
    return self;
}

- (void)loadView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UILabel *instructionsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [view addSubview:instructionsLabel];
    self.instructionsLabel = instructionsLabel;
    UILabel *passcodeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [view addSubview:passcodeLabel];
    self.passcodeLabel = passcodeLabel;
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectZero];
    [view addSubview:textField];
    self.textField = textField;
    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.textField becomeFirstResponder];
    [self setupNavigationItem];
    [self setupLayout];
    [self setupView];
}

- (UIRectEdge)edgesForExtendedLayout {
    return [super edgesForExtendedLayout] ^ UIRectEdgeTop;
}

#pragma mark - Setup methods

- (void)setupNavigationItem {
    self.navigationItem.title = @"Seguridad";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                             target:self
                                             action:@selector(onTapCancelButton:)];
}

- (void)setupLayout {
    [self.instructionsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topLayoutGuide).with.offset(kVerticalSpacing);
        make.width.equalTo(self.instructionsLabel.superview);
        make.centerX.equalTo(self.instructionsLabel.superview);
    }];
    [self.passcodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.instructionsLabel.mas_bottom).with.offset(kVerticalSpacing / 4);
        make.width.equalTo(self.passcodeLabel.superview);
        make.centerX.equalTo(self.passcodeLabel.superview);
    }];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.textField.superview);
        make.centerX.equalTo(self.textField.superview);
    }];
}

- (void)setupView {
    self.textField.keyboardType = UIKeyboardTypeNumberPad;
    [self.textField addTarget:self
                       action:@selector(textFieldDidChangeEditing:)
             forControlEvents:UIControlEventEditingChanged];
    self.textField.delegate = self;
    self.instructionsLabel.text = @"Ingrese su contraseña";
    self.instructionsLabel.font = [UIFont systemFontOfSize:16];
    self.instructionsLabel.textAlignment = NSTextAlignmentCenter;
    self.passcodeLabel.text = @"- - - -";
    self.passcodeLabel.font = [UIFont systemFontOfSize:48];
    self.passcodeLabel.textAlignment = NSTextAlignmentCenter;
}

#pragma mark - Private methods

- (void)textFieldDidChangeEditing:(id)sender {
    NSUInteger length = self.textField.text.length;
    NSMutableArray *components = [NSMutableArray array];
    for (NSUInteger i = 0; i < length; i++) {
        [components addObject:@"●"];
    }
    for (NSUInteger i = length; i < kPasscodeLength; i++) {
        [components addObject:@"-"];
    }
    self.passcodeLabel.text = [components componentsJoinedByString:@" "];
    if (length == kPasscodeLength) {
        [self nextStep];
    }
}

- (void)nextStep {
    if (self.mode == VLDSecurityPasscodeViewControllerModeCleanRecord || self.mode == VLDSecurityPasscodeViewControllerModeReRecord) {
        if (!self.lastRecord) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.33 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.lastRecord = self.textField.text;
                self.textField.text = @"";
                [self textFieldDidChangeEditing:self.textField];
                self.instructionsLabel.text = @"Ingrese su contraseña nuevamente";
            });
        } else {
            if ([self.textField.text isEqualToString:self.lastRecord]) {
                [SSKeychain setPassword:self.lastRecord
                             forService:VLDKeychainService
                                account:VLDKeychainAccount];
                if ([self.delegate respondsToSelector:@selector(securityPasscodeViewControllerDidFinish:)]) {
                    [self.delegate securityPasscodeViewControllerDidFinish:self];
                }
                [self.textField resignFirstResponder];
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.33 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.lastRecord = nil;
                    self.textField.text = @"";
                    [self textFieldDidChangeEditing:self.textField];
                    self.instructionsLabel.text = @"Inténtelo nuevamente";
                });
            }
        }
    } else if (self.mode == VLDSecurityPasscodeViewControllerModeRequest) {
        NSString *password = [SSKeychain passwordForService:VLDKeychainService
                                                    account:VLDKeychainAccount];
        if ([self.textField.text isEqualToString:password]) {
            if ([self.delegate respondsToSelector:@selector(securityPasscodeViewControllerDidFinish:)]) {
                [self.delegate securityPasscodeViewControllerDidFinish:self];
            }
            [self.textField resignFirstResponder];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.33 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.textField.text = @"";
                [self textFieldDidChangeEditing:self.textField];
                self.instructionsLabel.text = @"Inténtelo nuevamente";
            });
        }
    }
}

- (void)onTapCancelButton:(id)sender {
    [self.textField resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (range.location > (kPasscodeLength - 1)) {
        return NO;
    }
    return YES;
}

@end
