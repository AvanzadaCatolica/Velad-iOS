//
//  VLDBasicPointCellTableViewCell.m
//  Velad
//
//  Created by Renzo Crisóstomo on 13/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "VLDBasicPointCellTableViewCell.h"
#import "VLDBasicPoint.h"
#import "NSString+VLDAdditions.h"

@implementation VLDBasicPointCellTableViewCell

#pragma mark - Life cycle

- (void)prepareForReuse {
    self.model = nil;
    self.textLabel.text = @"";
    self.accessoryType = UITableViewCellAccessoryNone;
}

#pragma mark - Public methods

- (void)setModel:(VLDBasicPoint *)model {
    _model = model;
    self.textLabel.text = model.name;
    if (![model.description vld_isEmpty]) {
        self.detailTextLabel.text = model.description;
    }
    self.accessoryType = model.enabled ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
}

@end
