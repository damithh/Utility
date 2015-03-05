//
//  UIColor+Awispa.m
//  Awispa
//
//  Created by Damith Hettige on 11/21/14.
//  Copyright (c) 2014 Damith Hettige. All rights reserved.
//

#import "UIColor+Awispa.h"

@implementation UIColor (Awispa)

+ (UIColor *)themeLightColor{ 
    return [UIColor colorWithRed:71/255.0 green:0/255.0 blue:57/255.0 alpha:1];
}

+ (UIColor *)themeDarkColor{
    return [UIColor colorWithRed:142/255.0 green:27/255.0 blue:97/255.0 alpha:1];
}

+ (UIColor *)color_241 {
    return [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
}

+ (UIColor *)color_36_27_71 {
    return [UIColor colorWithRed:36/255.0 green:27/255.0 blue:71/255.0 alpha:1];
}

+ (UIColor *)colorWithR:(float)r G:(float)g B:(float)b{
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
}

@end
