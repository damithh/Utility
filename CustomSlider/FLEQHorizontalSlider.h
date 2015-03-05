//
//  FLEQHorizontalSlider.h
//  publish
//
//  Created by Damith Hettige on 3/5/15.
//  Copyright (c) 2015 D D C Hettige. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FLEQHorizontalSliderDelegate;
@interface FLEQHorizontalSlider : UIView
@property(weak, nonatomic)NSString *strTitle;
@property(weak, nonatomic)NSString *strRight;
@property(weak, nonatomic)NSString *strLeft;
@property(assign, nonatomic)NSInteger noOFSteps;
@property(assign, nonatomic)BOOL isBalance;
@property(weak, nonatomic)id<FLEQHorizontalSliderDelegate> delegate;

+(FLEQHorizontalSlider *)fLEQHorizontalSliderWithDefault:(float)value max:(float)maxValue min:(float)minValue;
- (void)setHSliderValue:(float)value;
- (float)getHsliderValue;
- (void)setDefaultValue:(float)value;

@end

@protocol FLEQHorizontalSliderDelegate <NSObject>

- (void)slider:(FLEQHorizontalSlider *)slider sliderChange:(float)value;
- (void)touchUpSlider:(FLEQHorizontalSlider *)slider;


@end