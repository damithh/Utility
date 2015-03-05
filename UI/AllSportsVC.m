//
//  AllSportsViewController.m
//  Awispa
//
//  Created by Damith Hettige on 11/19/14.
//  Copyright (c) 2014 Damith Hettige. All rights reserved.
//

#import "AllSportsVC.h"
#import "AllSportsTVC.h"
#import "TournementVC.h"
#import "ASSports.h"

#import "LevelOneVC.h"

@interface AllSportsVC ()<ASSportsDelegate>

@end

@implementation AllSportsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self refreshData];
    //All Sports
//    [self setIsDrawerButtonAlingToRight:YES];
//    [self setStrTitle:@"All Sports"];
    
    
    //Follow games title
//    [self setStrTitle:@"English Premier League"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSDictionary *userInfo = @{DHBNBPLblPrimary : @"Choose Your Sport", DHBNBPLblSecondry:@"" , DHBNBPBackButtonHidden : [NSNumber numberWithBool:YES], DHBNBPLblSportName :@"", DHBNBPLogo:@""};
    [[NSNotificationCenter defaultCenter] postNotificationName:DHBottomNaviagtionBarPropertiesChangeNotification object:nil userInfo:userInfo];
}

- (void)refreshData {
    [self showActivityIndicator:NO];
    ASSports * sports = [ASSports sharedASSports];
    [sports getSportsList:[NSString stringWithFormat:@"%@/%@",API_URL,API_ALL_SPORTS]];
    [sports setDelegate: self]; 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * simpleTableIdentifier = @"ShareCell";
    AllSportsTVC * cell =  [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[AllSportsTVC alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    [cell setTag:indexPath.row];
    NSDictionary * dDic = [self.dataArray objectAtIndex:indexPath.row];
    
    [cell setSportTitle:[dDic valueForKey:@"display_name"]];
    [cell setSportImageName:[dDic valueForKey:@"icon"]];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    TournementVC * tVC = [[TournementVC alloc]init];
//    NSDictionary * dDic = [self.dataArray objectAtIndex:indexPath.row];
//    [tVC setDicProperties:dDic];
//    [self.navigationController pushViewController:tVC animated:YES];
    
    LevelOneVC * lVC = [[LevelOneVC alloc]init];
    NSDictionary * dDic = [self.dataArray objectAtIndex:indexPath.row];
    [lVC setDicProperties:dDic];
    [lVC setUserInfoDictionary:dDic];
    [self.navigationController pushViewController:lVC animated:YES];

}

#pragma mark - ASSportsDelegate
- (void)sportsList:(NSDictionary *)dic withError:(NSError *)error {
    [super sportsList:dic withError:error withKeyPath:@"data.sports"];
}

@end
