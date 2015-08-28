//
//  VLDNoteFilterViewController.m
//  Velad
//
//  Created by Renzo Crisóstomo on 28/08/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "VLDNoteFilterViewController.h"
#import <Masonry/Masonry.h>
#import "VLDNote.h"

@interface VLDNoteFilterViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic) NSArray *dataSource;
@property (nonatomic) VLDNoteFilterType selectedNoteFilterType;

- (void)setupNavigationItem;
- (void)setupLayout;
- (void)setupTableView;
- (void)setupDataSource;

@end

@implementation VLDNoteFilterViewController

#pragma mark - Life cycle

- (instancetype)initWithNoteFilerType:(VLDNoteFilterType)noteFilterType {
    self = [super init];
    if (self) {
        _selectedNoteFilterType = noteFilterType;
    }
    
    return self;
}

- (void)loadView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [view addSubview:tableView];
    self.tableView = tableView;
    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationItem];
    [self setupTableView];
    [self setupLayout];
    [self setupDataSource];
}

#pragma mark - Setup methods

- (void)setupNavigationItem {
    self.navigationItem.title = @"Filtros";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onTapDoneButton:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onTapCancelButton:)];
}

- (void)setupTableView {
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)setupLayout {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.tableView.superview);
    }];
}

- (void)setupDataSource {
    self.dataSource = @[@"Mostar todas", @"Regulares", @"Confesables", @"Confesadas", @"Guiamiento"];
}

#pragma mark - Private methods

- (void)onTapDoneButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(noteFilterViewControlerDidFinishFilterSelection:)]) {
        [self.delegate noteFilterViewControlerDidFinishFilterSelection:self];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onTapCancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    tableViewCell.textLabel.text = self.dataSource[indexPath.row];
    if (self.selectedNoteFilterType == indexPath.row) {
        tableViewCell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        tableViewCell.accessoryType = UITableViewCellAccessoryNone;
    }
    return tableViewCell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedNoteFilterType == indexPath.row) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    NSIndexPath *previousSelectionIndexPath = [NSIndexPath indexPathForRow:self.selectedNoteFilterType inSection:0];
    self.selectedNoteFilterType = indexPath.row;
    [tableView reloadRowsAtIndexPaths:@[indexPath, previousSelectionIndexPath]
                     withRowAnimation:UITableViewRowAnimationFade];
    
}

@end
