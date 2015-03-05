//
//  AllSportsCellView.h
//  Awispa
//
//  Created by Damith Hettige on 12/5/14.
//  Copyright (c) 2014 Damith Hettige. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableCellView.h"
#import <AFNetworking/UIKit+AFNetworking.h>

@interface AllSportsCellView : BaseTableCellView

@property(nonatomic,strong) UIImageView *sportImage;
//@property(nonatomic,strong) UIImageView *sportListArrow;
@property(nonatomic,strong) UILabel *sportLabel;
@end
