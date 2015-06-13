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

@implementation VLDDailyRecordTableViewCell

- (void)prepareForReuse {
    self.textLabel.text = @"";
    self.accessoryType = UITableViewCellAccessoryNone;
    self.accessoryView = nil;
}

- (void)setModel:(VLDDailyRecord *)model {
    _model = model;
    self.textLabel.text = model.basicPoint.name;
    if (model.record) {
        if ([model.record.notes vld_isEmpty]) {
            self.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
            self.accessoryView = infoButton;
        }
    }
}

@end
