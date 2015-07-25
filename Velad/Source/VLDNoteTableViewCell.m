//
//  VLDNoteTableViewCell.m
//  Velad
//
//  Created by Renzo Crisóstomo on 14/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "VLDNoteTableViewCell.h"
#import "VLDNote.h"
#import <Masonry/Masonry.h>
#import "UITableViewCell+VLDAdditions.h"

@interface VLDNoteTableViewCell ()

@property (nonatomic, weak) UILabel *noteLabel;
@property (nonatomic, weak) UILabel *stateLabel;
@property (nonatomic, weak) UILabel *dateLabel;

@end

static NSInteger const kSubviewSeparationSpace = 10;

@implementation VLDNoteTableViewCell

#pragma mark - Life cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubviews];
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
    self.noteLabel.text = model.text;
    self.stateLabel.text = [VLDNote symbolForState:model.state];
    self.dateLabel.text = [VLDNote formattedDateForNote:model];
}

#pragma mark - Private methods

- (void)setupSubviews {
    UILabel *noteLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:noteLabel];
    self.noteLabel = noteLabel;
    [self.noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.noteLabel.superview).with.offset(self.separatorDisplacement);
        make.width.equalTo(self.noteLabel.superview).with.multipliedBy(0.7);
        make.top.equalTo(self.noteLabel.superview).with.offset(kSubviewSeparationSpace);
    }];
    UILabel *stateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    stateLabel.textAlignment = NSTextAlignmentRight;
    stateLabel.font = [UIFont systemFontOfSize:14];
    stateLabel.textColor = [UIColor darkGrayColor];
    [self.contentView addSubview:stateLabel];
    self.stateLabel = stateLabel;
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.noteLabel.mas_trailing).with.offset(kSubviewSeparationSpace);
        make.trailing.equalTo(self.stateLabel.superview).with.offset(-kSubviewSeparationSpace);
        make.top.equalTo(self.stateLabel.superview).with.offset(kSubviewSeparationSpace);
        make.bottom.equalTo(self.stateLabel.superview).with.offset(-kSubviewSeparationSpace);
    }];
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    dateLabel.font = [UIFont systemFontOfSize:14];
    dateLabel.textColor = [UIColor darkGrayColor];
    [self.contentView addSubview:dateLabel];
    self.dateLabel = dateLabel;
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.dateLabel.superview).with.offset(self.separatorDisplacement);
        make.trailing.equalTo(self.stateLabel.mas_leading).with.offset(-kSubviewSeparationSpace);
        make.top.equalTo(self.noteLabel.mas_bottom).with.offset(kSubviewSeparationSpace);
        make.bottom.equalTo(self.dateLabel.superview).with.offset(-kSubviewSeparationSpace);
    }];
}

@end
