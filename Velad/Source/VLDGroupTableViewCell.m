//
//  VLDGroupTableViewCell.m
//  Velad
//
//  Created by Renzo Crisóstomo on 01/08/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "VLDGroupTableViewCell.h"
#import "VLDGroup.h"

@implementation VLDGroupTableViewCell

#pragma mark - Life cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)prepareForReuse {
    self.model = nil;
    self.textLabel.text = @"";
    self.detailTextLabel.text = @"";
    self.accessoryType = UITableViewCellAccessoryNone;
}

#pragma mark - Public methods

- (void)setModel:(VLDGroup *)model {
    _model = model;
    self.textLabel.text = model.name;
    self.detailTextLabel.text = [NSString stringWithFormat:@"%lu %@", (unsigned long)model.basicPoints.count, model
                                 .basicPoints.count == 1? @"punto básico" : @"puntos básicos"];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

@end
