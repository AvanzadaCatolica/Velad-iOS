//
//  VLDWeekdayArrayValidator.m
//  Velad
//
//  Created by Renzo Crisóstomo on 26/07/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "VLDWeekdayArrayValidator.h"

@implementation VLDWeekdayArrayValidator

- (XLFormValidationStatus *)isValid:(XLFormRowDescriptor *)row {
    if ([row.value count] >= 1) {
        return [XLFormValidationStatus formValidationStatusWithMsg:@"" status:YES rowDescriptor:row];
    }
    return [XLFormValidationStatus formValidationStatusWithMsg:@"Seleccione días de la semana" status:NO rowDescriptor:row];
}

@end
