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
#import "VLDGroup.h"
#import "VLDSectionsViewModel.h"

@interface VLDWeekViewController () <UITableViewDataSource, UITableViewDelegate, VLDDateIntervalPickerViewDelegate, MFMailComposeViewControllerDelegate, VLDErrorPresenterDataSource>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic) VLDSectionsViewModel *viewModel;
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
    [self.tableView reloadData];
}

- (UIRectEdge)edgesForExtendedLayout {
    return [super edgesForExtendedLayout] ^ UIRectEdgeBottom;
}

#pragma mark - Setup methods

- (void)setupNavigationItem {
    self.navigationItem.title = @"Semana";
    UIImage *mailImage = [[UIImage imageNamed:@"Mail"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:mailImage
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(onTapMailButton:)];
}

- (void)setupDataSource {
    NSMutableArray *sectionTitles = [NSMutableArray array];
    NSMutableArray *sections = [NSMutableArray array];
    
    RLMResults *groups = [VLDGroup sortedGroups];
    for (VLDGroup *group in groups) {
        for (VLDBasicPoint *basicPoint in group.basicPoints) {
            if (basicPoint.isEnabled) {
                RLMResults *countResults = [VLDRecord recordsForBasicPoint:basicPoint
                                                          betweenStartDate:self.dateIntervalPickerView.selectedStartDate
                                                                   endDate:self.dateIntervalPickerView.selectedEndDate];
                VLDWeekViewModel *viewModel = [[VLDWeekViewModel alloc] initWithBasicPoint:basicPoint
                                                                                 weekCount:countResults.count];
                NSUInteger sectionIndex = [sectionTitles indexOfObject:group.name];
                if (sectionIndex != NSNotFound) {
                    [sections[sectionIndex] addObject:viewModel];
                } else {
                    [sectionTitles addObject:group.name];
                    NSMutableArray *section = [NSMutableArray array];
                    [section addObject:viewModel];
                    [sections addObject:section];
                }
            }
        }
    }
    
    VLDSectionsViewModel *viewModel = [[VLDSectionsViewModel alloc] initWithSectionTitles:[sectionTitles copy]
                                                                                 sections:[sections copy]];
    self.viewModel = viewModel;
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
        
        NSString *messageBody = @"";
        
        VLDProfile *profile = [[VLDProfile allObjects] firstObject];
        if (profile) {
            messageBody = [NSString stringWithFormat:@"Nombre: %@\nCírculo: %@\nGrupo: %@\n\n", profile.name, profile.circle, profile.group];
        }
        
        messageBody = [messageBody stringByAppendingString:[NSString stringWithFormat:@"Semana %@\n\n", self.dateIntervalPickerView.title]];
        
        for (NSArray *section in self.viewModel.sections) {
            for (VLDWeekViewModel *viewModel in section) {
                messageBody = [messageBody stringByAppendingString:[NSString stringWithFormat:@"%@: %ld/%ld\n", viewModel.basicPoint.name, (long)viewModel.weekCount, (long)viewModel.basicPoint.weekDays.count]];
            }
        }
        
        [composeViewController setSubject:@"Reporte semanal"];
        [composeViewController setMessageBody:messageBody isHTML:NO];
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
    return self.viewModel.sectionTitles[section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *viewModelSection = self.viewModel.sections[section];
    return viewModelSection.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.sections.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VLDWeekTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([VLDWeekTableViewCell class])];
    cell.viewModel = self.viewModel.sections[indexPath.section][indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:tableView.indexPathForSelectedRow animated:YES];
}

#pragma mark - VLDDateIntervalPickerViewDelegate

- (void)dateIntervalPickerView:(VLDDateIntervalPickerView *)dateIntervalPickerView didChangeSelectionWithDirection:(VLDArrowButtonDirection)direction {
    [self setupDataSource];
    [self.tableView reloadData];
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
