//
//  VLDDailyRecordTableViewCell.h
//  Velad
//
//  Created by Renzo Crisóstomo on 13/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VLDBasicPoint;
@class VLDRecord;
@protocol VLDDailyRecordTableViewCellDelegate;

@interface VLDDailyRecord : NSObject

@property (nonatomic) VLDBasicPoint *basicPoint;
@property (nonatomic) VLDRecord *record;

@end

@interface VLDDailyRecordTableViewCell : UITableViewCell

@property (nonatomic) VLDDailyRecord *model;
@property (nonatomic, weak) id<VLDDailyRecordTableViewCellDelegate> delegate;

@end

@protocol VLDDailyRecordTableViewCellDelegate <NSObject>

- (void)dailyRecordTableViewCellDidPressInfoButton:(VLDDailyRecordTableViewCell *)cell;

@end
