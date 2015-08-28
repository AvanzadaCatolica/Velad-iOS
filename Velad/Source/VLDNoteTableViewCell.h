//
//  VLDNoteTableViewCell.h
//  Velad
//
//  Created by Renzo Crisóstomo on 14/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VLDNote;

@interface VLDNoteTableViewCell : UITableViewCell

@property (nonatomic) VLDNote *model;
@property (nonatomic, weak, readonly) UILabel *dateLabel;

@end
