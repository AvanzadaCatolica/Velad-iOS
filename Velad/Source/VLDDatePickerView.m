//
//  VLDDatePickerView.m
//  Velad
//
//  Created by Renzo Crisóstomo on 13/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "VLDDatePickerView.h"

@implementation VLDDatePickerView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSDateComponents *components = [[NSCalendar currentCalendar]
                                        components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                                        fromDate:[NSDate date]];
        _selectedDate = [[NSCalendar currentCalendar] dateFromComponents:components];
        self.backgroundColor = [UIColor redColor];
    }
    
    return self;
}

@end
