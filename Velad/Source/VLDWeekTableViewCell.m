//
//  VLDWeekTableViewCell.m
//  Velad
//
//  Created by Renzo Crisóstomo on 14/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "VLDWeekTableViewCell.h"
#import "VLDWeekViewModel.h"

@implementation VLDWeekTableViewCell

#pragma mark - Life cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)prepareForReuse {
    self.viewModel = nil;
    self.textLabel.text = @"";
    self.detailTextLabel.text = @"";
}

#pragma mark - Public methods

- (void)setViewModel:(VLDWeekViewModel *)viewModel {
    _viewModel = viewModel;
    self.textLabel.text = viewModel.basicPoint.name;
    self.detailTextLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)viewModel.weekCount, (long)viewModel.basicPoint.weekDays.count];
}

@end
