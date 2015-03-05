//
//  UIFont+Awispa.m
//  Awispa
//
//  Created by Damith Hettige on 11/21/14.
//  Copyright (c) 2014 Damith Hettige. All rights reserved.
//

#import "UIFont+Awispa.h"

@implementation UIFont (Awispa)
//  to change font size according to device the device
//  can do with AutoLayout + Size class
+ (UIFont *)defualFontWithSize:(float)size{
//    relative height
    float iPhone_6_height = 667.0f;
    float height = [UIScreen mainScreen].bounds.size.height;
    float ratio = height/iPhone_6_height; 
    int newSize = ceilf(size*ratio);
//    to fine tune font size
    if (ratio*10<8) {
        newSize  = newSize + 2;
    } else if (ratio*10<9){
        newSize ++;
    }
    return [UIFont fontWithName:@"Helvetica-Light" size:newSize];
}

@end
