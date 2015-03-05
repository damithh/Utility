//
//  AllSportsCellView.m
//  Awispa
//
//  Created by Damith Hettige on 12/5/14.
//  Copyright (c) 2014 Damith Hettige. All rights reserved.
//

#import "AllSportsCellView.h"

@implementation AllSportsCellView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [[UIColor themeLightLineColor]  CGColor]);
    CGContextSetLineWidth(context, 1.0); 
    CGContextMoveToPoint(context, 70*UI_RATIO, 0);
    CGContextAddLineToPoint(context, 70*UI_RATIO, self.frame.size.height-1);
    CGContextDrawPath(context, kCGPathStroke);
}

- (void)intializeSubViews {
    [super intializeSubViews];
    self.sportImage = [[UIImageView alloc]init];
    self.sportLabel = [[UILabel alloc]init];
    [_sportImage setContentMode:UIViewContentModeCenter];
    [self addSubview:_sportImage];
    [self addSubview:_sportLabel];
    
    [_sportImage setClipsToBounds:YES];
    [_sportImage setContentMode:UIViewContentModeScaleAspectFit];
    
    [_sportLabel setFont:[UIFont defualFontWithSize:20]];
    [_sportLabel setTextColor:[UIColor whiteColor]];
}

- (void)addAutolayoutForViews {
    [super addAutolayoutForViews];
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    UIView *rightArrow = self.sportListArrow;
    
    NSDictionary *viwes = NSDictionaryOfVariableBindings(_sportImage,_sportLabel,rightArrow);
    NSDictionary *metrics = @{ @"sportLogoWidth":@(30*UI_RATIO), @"hSpaceForLogo":@(20*UI_RATIO), @"hSpaceForLabel":@(35*UI_RATIO)};
    [_sportLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_sportImage setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_sportImage(sportLogoWidth)]"options:0 metrics:metrics views:viwes]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_sportLabel]-0-|"options:0 metrics:metrics views:viwes]];
    [_sportImage addConstraint:[NSLayoutConstraint constraintWithItem:_sportImage attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_sportImage attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_sportImage attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-hSpaceForLogo-[_sportImage]-hSpaceForLabel-[_sportLabel]-0-[rightArrow]-0-|"options:0 metrics:metrics views:viwes]];
}

@end
