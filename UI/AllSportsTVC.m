//
//  AllSportsTVC.m
//  Awispa
//
//  Created by Damith Hettige on 12/5/14.
//  Copyright (c) 2014 Damith Hettige. All rights reserved.
//

#import "AllSportsTVC.h"
#import "AllSportsCellView.h"

@interface AllSportsTVC ()

@property(nonatomic,strong) AllSportsCellView *sportView;

@end

@implementation AllSportsTVC

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setTag:(NSInteger)tag{
    [super setTag:tag];
    [_sportView setTag:tag];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        self.sportView = [[AllSportsCellView alloc]init];
        [self.contentView addSubview:_sportView];
        [_sportView setTranslatesAutoresizingMaskIntoConstraints:NO];
        NSDictionary *views = NSDictionaryOfVariableBindings(_sportView);
        NSDictionary *metrics = @{@"hGap":@(0),@"topPadding":@(15)};
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-hGap-[_sportView]-hGap-|"options:0 metrics:metrics views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_sportView]-0-|"options:0 metrics:metrics views:views]];
        
    }

        return self;
}

- (void)setSportImageName:(NSString *)sportImageName{
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:sportImageName]];
//    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
//    [_sportView.sportImage setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
//        [_sportView.sportImage setImage:image];
//    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
//        
//    }];
    [_sportView.sportImage setImageWithURL:[NSURL URLWithString:sportImageName]];
}

- (void)setSportTitle:(NSString *)sportTitle{
    [_sportView.sportLabel setText:sportTitle];
}


@end
