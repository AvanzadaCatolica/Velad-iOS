//
//  VLDDailyRecordTableViewCell.m
//  Velad
//
//  Created by Renzo Crisóstomo on 13/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "VLDDailyRecordTableViewCell.h"
#import "VLDBasicPoint.h"
#import "VLDRecord.h"
#import "NSString+VLDAdditions.h"

@implementation VLDDailyRecord

@end

@interface VLDDailyRecordTableViewCell ()

- (void)onTapInfoButton:(id)sender;

@end

@implementation VLDDailyRecordTableViewCell

#pragma mark - Life cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    
    return self;
}

- (void)prepareForReuse {
    self.model = nil;
    self.delegate = nil;
    self.textLabel.text = @"";
    self.detailTextLabel.text = @"";
    self.accessoryType = UITableViewCellAccessoryNone;
    self.accessoryView = nil;
}

#pragma mark - Public methods

- (void)setModel:(VLDDailyRecord *)model {
    _model = model;
    self.textLabel.text = model.basicPoint.name;
    self.detailTextLabel.text = model.basicPoint.descriptionText;
    if (model.record) {
        if ([model.record.notes vld_isEmpty]) {
            self.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
            [infoButton addTarget:self action:@selector(onTapInfoButton:) forControlEvents:UIControlEventTouchUpInside];
            self.accessoryView = infoButton;
        }
    }
}

#pragma mark - Private Methods

- (void)onTapInfoButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(dailyRecordTableViewCellDidPressInfoButton:)]) {
        [self.delegate dailyRecordTableViewCellDidPressInfoButton:self];
    }
}

@end
