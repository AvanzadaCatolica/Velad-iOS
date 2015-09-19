//
//  VLDReportsResultView.m
//  Velad
//
//  Created by Renzo Crisóstomo on 20/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "VLDReportsResultView.h"
#import <Masonry/Masonry.h>
#include <math.h>

@interface VLDReportsResultView ()

@property (nonatomic) id<VLDReportsResultViewDataSource> dataSource;
@property (nonatomic, readonly) UILabel *explanationLable;
@property (nonatomic, readonly) UILabel *resultsLabel;
@property (nonatomic, readonly) UILabel *emojiLabel;
@property (nonatomic) VLDReportsResultViewMode mode;

- (void)setupSubviews;
- (NSString *)emojiForScore:(NSUInteger)score
                    maximum:(NSUInteger)maximum;

@end

@implementation VLDReportsResultView

#pragma mark - Public methods

- (instancetype)initWithDataSource:(id<VLDReportsResultViewDataSource>)dataSource
                              mode:(VLDReportsResultViewMode)mode {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _dataSource = dataSource;
        _mode = mode;
        [self setupView];
        [self setupSubviews];
    }
    return self;
}

- (void)reloadResultViewWithMode:(VLDReportsResultViewMode)mode
                    isUntilToday:(BOOL)isUntilToday {
    self.mode = mode;
    NSUInteger maximumPossibleScore = [self.dataSource maximumPossibleScoreForReportsResultView:self];
    NSUInteger score = [self.dataSource scoreForReportsResultView:self];
    self.explanationLable.text = [NSString stringWithFormat:@"Tu puntaje %@%@:", isUntilToday? @"hasta hoy " : @"", self.mode == VLDReportsResultViewModeWeekly? @"esta semana" : @"este mes"];
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%lu / %lu", (unsigned long)score, (unsigned long)maximumPossibleScore]];
    NSUInteger numberOfDigits = [@(score) stringValue].length;
    [mutableAttributedString addAttribute:NSFontAttributeName
                                    value:[UIFont systemFontOfSize:60.0]
                                    range:NSMakeRange(0, numberOfDigits)];
    [mutableAttributedString addAttribute:NSFontAttributeName
                                    value:[UIFont systemFontOfSize:15.0]
                                    range:NSMakeRange(numberOfDigits, mutableAttributedString.length - numberOfDigits)];
    self.resultsLabel.attributedText = [mutableAttributedString copy];
    self.emojiLabel.text = [self emojiForScore:score maximum:maximumPossibleScore];
}

- (NSString *)content {
    return [NSString stringWithFormat:@"%@ %@", self.resultsLabel.text, self.emojiLabel.text];
}

#pragma mark - Setup methods

- (void)setupView {
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (void)setupSubviews {
    UILabel *explanationLable = [[UILabel alloc] initWithFrame:CGRectZero];
    explanationLable.numberOfLines = 3;
    if ([[UIScreen mainScreen] scale] == 3.0f) {
        explanationLable.font = [UIFont systemFontOfSize:18];
    } else {
        explanationLable.font = [UIFont systemFontOfSize:15];
    }
    [self addSubview:explanationLable];
    [explanationLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(explanationLable.superview).with.offset(20);
        make.width.equalTo(explanationLable.superview).with.multipliedBy(1.0f/3.0f);
        make.bottom.equalTo(explanationLable.superview);
        make.top.equalTo(explanationLable.superview);
    }];
    _explanationLable = explanationLable;
    UILabel *resultsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    resultsLabel.textAlignment = NSTextAlignmentCenter;
    resultsLabel.font = [UIFont systemFontOfSize:25];
    [self addSubview:resultsLabel];
    [resultsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(explanationLable.mas_trailing);
        make.width.equalTo(explanationLable.superview).with.multipliedBy(1.0f/3.0f);
        make.bottom.equalTo(explanationLable.superview);
        make.top.equalTo(explanationLable.superview);
    }];
    _resultsLabel = resultsLabel;
    UILabel *emojiLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    emojiLabel.textAlignment = NSTextAlignmentCenter;
    emojiLabel.font = [UIFont systemFontOfSize:65];
    [self addSubview:emojiLabel];
    [emojiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(resultsLabel.mas_trailing);
        make.trailing.equalTo(explanationLable.superview).with.offset(-20);
        make.bottom.equalTo(explanationLable.superview);
        make.top.equalTo(explanationLable.superview);
    }];
    _emojiLabel = emojiLabel;
}

#pragma mark - Private methods

- (NSString *)emojiForScore:(NSUInteger)score
                    maximum:(NSUInteger)maximum {
    CGFloat result = (CGFloat)score / (CGFloat)maximum;
    if (result < 0.25) {
        return @"\U0001F61E";
    } else if (result < 0.5) {
        return @"\U0001F614";
    } else if (result < 0.75) {
        return @"\U0001F60A";
    } else if (result < 0.95) {
        return @"\U0001F603";
    } else {
        return @"\U0001F604";
    }
    
}

@end
