//
//  VLDWeekViewController.m
//  Velad
//
//  Created by Renzo Crisóstomo on 13/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "VLDWeekViewController.h"
#import <Realm/Realm.h>
#import "VLDDateIntervalPickerView.h"
#import "VLDBasicPoint.h"
#import <Masonry/Masonry.h>
#import "VLDWeekTableViewCell.h"
#import "VLDWeekViewModel.h"
#import "VLDRecord.h"
#import "UIView+VLDAdditions.h"
#import <MessageUI/MessageUI.h>
#import "VLDErrorPresenter.h"
#import "VLDProfile.h"

@interface VLDWeekViewController () <UITableViewDataSource, UITableViewDelegate, VLDDateIntervalPickerViewDelegate, MFMailComposeViewControllerDelegate, VLDErrorPresenterDataSource>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic) NSArray *viewModels;
@property (nonatomic, weak) VLDDateIntervalPickerView *dateIntervalPickerView;
@property (nonatomic) VLDErrorPresenter *errorPresenter;

- (void)setupNavigationItem;
- (void)setupDataSource;
- (void)setupLayout;
- (void)setupTableView;
- (void)setupDateIntervalPickerView;
- (void)onTapMailButton:(id)sender;

@end

@implementation VLDWeekViewController

#pragma mark - Life cycle

- (void)loadView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [view addSubview:tableView];
    self.tableView = tableView;
    VLDDateIntervalPickerView *dateIntervalPickerView = [[VLDDateIntervalPickerView alloc] initWithType:VLDDateIntervalPickerViewTypeWeekly];
    [view addSubview:dateIntervalPickerView];
    self.dateIntervalPickerView = dateIntervalPickerView;
    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationItem];
    [self setupLayout];
    [self setupTableView];
    [self setupDateIntervalPickerView];
}

- (void)viewWillAppear:(BOOL)animated {
    [self setupDataSource];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                  withRowAnimation:UITableViewRowAnimationFade];
}

- (UIRectEdge)edgesForExtendedLayout {
    return [super edgesForExtendedLayout] ^ UIRectEdgeBottom;
}

#pragma mark - Setup methods

- (void)setupNavigationItem {
    self.navigationItem.title = @"Semana";
    UIImage *mailImage = [[UIImage imageNamed:@"Mail"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:mailImage
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(onTapMailButton:)];
}

- (void)setupDataSource {
    NSMutableArray *viewModels = [NSMutableArray array];
    RLMResults *basicPoints = [VLDBasicPoint basicPoints];
    for (VLDBasicPoint *basicPoint in basicPoints) {
        RLMResults *countResults = [VLDRecord recordsForBasicPoint:basicPoint
                                                  betweenStartDate:self.dateIntervalPickerView.selectedStartDate
                                                           endDate:self.dateIntervalPickerView.selectedEndDate];
        VLDWeekViewModel *viewModel = [[VLDWeekViewModel alloc] initWithBasicPoint:basicPoint
                                                                         weekCount:countResults.count];
        [viewModels addObject:viewModel];
    }
    self.viewModels = [viewModels copy];
}

- (void)setupLayout {
    [self.dateIntervalPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.dateIntervalPickerView.superview);
        make.trailing.equalTo(self.dateIntervalPickerView.superview);
        make.bottom.equalTo(self.dateIntervalPickerView.superview);
        make.height.equalTo(self.dateIntervalPickerView.superview).with.multipliedBy(0.2);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.tableView.superview);
        make.trailing.equalTo(self.tableView.superview);
        make.top.equalTo(self.tableView.superview);
        make.bottom.equalTo(self.dateIntervalPickerView.mas_top);
    }];
}

- (void)setupTableView {
    [self.tableView registerClass:[VLDWeekTableViewCell class]
           forCellReuseIdentifier:NSStringFromClass([VLDWeekTableViewCell class])];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)setupDateIntervalPickerView {
    self.dateIntervalPickerView.delegate = self;
}

#pragma mark - Private methods

- (VLDErrorPresenter *)errorPresenter {
    if (_errorPresenter == nil) {
        _errorPresenter = [[VLDErrorPresenter alloc] initWithDataSource:self];
    }
    return _errorPresenter;
}

- (void)onTapMailButton:(id)sender {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] init];
        [composeViewController.navigationBar setTintColor:[UIColor whiteColor]];
        composeViewController.mailComposeDelegate = self;
        
        VLDProfile *profile = [[VLDProfile allObjects] firstObject];
        NSString *messageBody = [NSString stringWithFormat:@"Nombre: %@\nCírculo: %@\nGrupo: %@", profile.name, profile.circle, profile.group];
        
        [composeViewController setSubject:@"Reporte semanal"];
        [composeViewController setMessageBody:messageBody isHTML:NO];
        [composeViewController addAttachmentData:UIImagePNGRepresentation([self.view vld_snapshotImage])
                                        mimeType:@"image/png"
                                        fileName:@"Reporte.png"];
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

#pragma mark - UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Puntos Básicos";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VLDWeekTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([VLDWeekTableViewCell class])];
    cell.viewModel = self.viewModels[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:tableView.indexPathForSelectedRow animated:YES];
}

#pragma mark - VLDDateIntervalPickerViewDelegate

- (void)dateIntervalPickerView:(VLDDateIntervalPickerView *)dateIntervalPickerView didChangeSelectionWithDirection:(VLDArrowButtonDirection)direction {
    [self setupDataSource];
    if (direction != VLDArrowButtonDirectionNone) {
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                      withRowAnimation:direction == VLDArrowButtonDirectionLeft ? UITableViewRowAnimationRight : UITableViewRowAnimationLeft];
    } else {
        [self.tableView reloadData];
    }
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - VLDErrorPresenterDataSource

- (UIViewController *)viewControllerForErrorPresenter:(VLDErrorPresenter *)presenter {
    return self;
}

@end
