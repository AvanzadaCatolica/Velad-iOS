//
//  VLDEmptyView.m
//  Velad
//
//  Created by Renzo Crisóstomo on 20/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "VLDEmptyView.h"
#import <Masonry/Masonry.h>

@interface VLDEmptyView ()

- (void)setupView;
- (void)setupSubviews;

@end

@implementation VLDEmptyView

- (instancetype)init {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self setupView];
        [self setupSubviews];
    }
    
    return self;
}

#pragma mark - Setup methods

- (void)setupView {
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (void)setupSubviews {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(label.superview).with.insets(UIEdgeInsetsMake(20, 20, 20, 20));
    }];
    NSString *emoji = @"\U0001F4C2";
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n\nNo hay información registrada", emoji]];
    [mutableAttributedString addAttribute:NSFontAttributeName
                                    value:[UIFont systemFontOfSize:60.0]
                                    range:NSMakeRange(0, emoji.length)];
    [mutableAttributedString addAttribute:NSFontAttributeName
                                    value:[UIFont systemFontOfSize:15.0]
                                    range:NSMakeRange(emoji.length, mutableAttributedString.length - emoji.length)];
    label.attributedText = [mutableAttributedString copy];
}

@end
