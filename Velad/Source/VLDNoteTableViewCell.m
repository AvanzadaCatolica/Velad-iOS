//
//  VLDNoteTableViewCell.m
//  Velad
//
//  Created by Renzo Crisóstomo on 14/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "VLDNoteTableViewCell.h"
#import "VLDNote.h"

@implementation VLDNoteTableViewCell

#pragma mark - Life cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)prepareForReuse {
    self.model = nil;
    self.textLabel.text = @"";
    self.detailTextLabel.text = @"";
}

#pragma mark - Public methods

- (void)setModel:(VLDNote *)model {
    _model = model;
    self.textLabel.text = model.text;
    self.detailTextLabel.text = [VLDNote symbolForState:model.state];
}

@end
