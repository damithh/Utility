//
//  FLEQHorizontalSlider.m
//  publish
//
//  Created by Damith Hettige on 3/5/15.
//  Copyright (c) 2015 D D C Hettige. All rights reserved.
//

#import "FLEQHorizontalSlider.h"
#import "UILabel+FLFontResizer.h" 

@interface FLEQHorizontalSlider()

@property (weak, nonatomic) IBOutlet UIView *middleViewForSlider;
@property(nonatomic, strong)IBOutlet UISlider *slider;
@property(nonatomic, strong)IBOutlet UILabel *lblTitle;
@property(nonatomic, strong)IBOutlet UILabel *lblRight;
@property(nonatomic, strong)IBOutlet UILabel *lblLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *NSLCTitleWidth;
@end

@implementation FLEQHorizontalSlider

//@synthesize _strTitle = strTitle, _strRight = strRight, _strLeft = strLeft;

+(FLEQHorizontalSlider *)fLEQHorizontalSliderWithDefault:(float)value max:(float)maxValue min:(float)minValue
{
    FLEQHorizontalSlider *eqSlider = (FLEQHorizontalSlider *)[[NSBundle mainBundle]loadNibNamed:@"FLEQHorizontalSlider" owner:nil options:nil][0];
    eqSlider.slider.maximumValue = maxValue;
    eqSlider.slider.minimumValue = minValue;
    [eqSlider.slider setValue:value animated:YES];
    return eqSlider;
}

- (void)getYValueForSlider{
    
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    if (_isBalance) {
        UIColor *tColor = [[FLCommonUtils rnThemeManager] colorForKey:@"theme_color"];
        CGRect sliderRect = _slider.frame;
        float sliderCenterX = sliderRect.origin.x + sliderRect.size.width/2;

        CGContextRef c = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColor(c, CGColorGetComponents([[tColor colorWithAlphaComponent:1]  CGColor]));
        CGContextBeginPath(c);
        CGContextSetLineWidth(c, 1.0); 
        float height,width,space;
        height = rect.size.height;
        width = sliderRect.size.width;
        space = 8.0;
        int howmany = width/(space*2);
        float y = height/2;
        
        for (int i = -howmany; i<= howmany; i++) {
            CGContextMoveToPoint(c, sliderCenterX + space * (-i), y);
            CGContextAddLineToPoint(c, sliderCenterX + space * (-i), height/2 +5* i*height/width*_slider.value);
        }
        CGContextStrokePath(c);
    }
}

- (void)awakeFromNib{
    [_lblLeft resetFontForDevice];
    [_lblRight resetFontForDevice];
    [_lblTitle resetFontForDevice];
}

-(void)updateConstraints{
    [_NSLCTitleWidth setConstant:CGRectGetWidth(self.bounds)*0.3];
    [super updateConstraints];
}


- (void)sliderTochUp:(id)sender{ 
    if ([_delegate respondsToSelector:@selector(touchUpSlider:)]) {
        [_delegate touchUpSlider:self];
    }
}


- (void)sliderChange:(id)sender{ 
}

- (void)setStrTitle:(NSString *)strTitle{
    _lblTitle.text = strTitle;
}

- (void)setStrLeft:(NSString *)strLeft{
    _lblLeft.text = strLeft;
}

- (void)setStrRight:(NSString *)strRight{
    _lblRight.text = strRight;
}


- (void)setIsBalance:(BOOL)isBalance{
    _isBalance = isBalance;
    if (isBalance) {
        UIImage *sliderImage = [FLCommonUtils sliderTrackBackgroundImage:[UIColor themeColor]] ;
        [_slider setMinimumTrackImage:sliderImage forState:UIControlStateNormal];
        [_slider setMaximumTrackImage:sliderImage forState:UIControlStateNormal];
        [_middleViewForSlider setHidden:NO];
    }
}

 

@end
