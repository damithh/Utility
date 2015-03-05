//
//  AWCreateAccountViewController.h
//  Awispa
//
//  Created by Damith Hettige on 11/19/14.
//  Copyright (c) 2014 Damith Hettige. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"

typedef enum AWCreateAccountViewMode : NSInteger AWCreateAccountViewMode;

enum AWCreateAccountViewMode:NSInteger{
    AWCreateAccountViewModeNormal,
    AWCreateAccountViewModeUpdate,
    AWCreateAccountViewModeSocial
};

@interface AWCreateAccountVC : BaseVC <UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property(nonatomic,strong) IBOutlet UITableView *tableView;
@property(nonatomic,strong) NSMutableDictionary *dicForForm;
@property(nonatomic,assign) AWCreateAccountViewMode createAccountMode;

@end
