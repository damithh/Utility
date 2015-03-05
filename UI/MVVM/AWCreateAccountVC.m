//
//  AWCreateAccountViewController.m
//  Awispa
//
//  Created by Damith Hettige on 11/19/14.
//  Copyright (c) 2014 Damith Hettige. All rights reserved.
//

#import "AWCreateAccountVC.h"
#import "AWCreateAccountTVC.h"
#import "AWCreateAccountVM.h"
#import "PlistHelper.h"
#import "ASAccount.h"
#import "SocialLoginHelper.h" 

@interface AWCreateAccountVC ()<UITextFieldDelegate,ASAccountDelegate>

@property (strong, nonatomic) IBOutlet UIButton * pickerViewDone;
@property (strong, nonatomic) IBOutlet UIView * pickerView;
@property (strong, nonatomic) IBOutlet UILabel * testLabel;
@property (strong, nonatomic) IBOutlet UIPickerView * birthYearPicker;
@property (strong, nonatomic) IBOutlet UIButton * tickButton;
@property (strong, nonatomic) IBOutlet UILabel * passwordMsgLabel;
@property (nonatomic,strong) IBOutlet UIButton * btnJoin;
@property (nonatomic,strong) IBOutlet UIButton * btnCancel;
@property (nonatomic,retain) NSArray * signupPlistData;
@property (nonatomic,retain) NSMutableArray * arrCountry;
@property (nonatomic, assign) long  selectedTextfieldsTag;
@property (nonatomic, assign) int tableOrigin;
@property (nonatomic,assign) CGRect tableViewRect;
@property (nonatomic,strong) NSMutableDictionary * dicIndexPath;
@property (nonatomic,strong) IBOutlet UIButton * btnTick;

- (IBAction)tickClicked:(id)sender;
@end

@implementation AWCreateAccountVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadPlistData];
    [self settingUIButtons];
    [_tableView setSeparatorStyle:NO];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [self initStartYear];
    [self initCountries];
    [self setVerticalConstraints];
    [_birthYearPicker setBackgroundColor:[UIColor clearColor]];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboareWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
    [_tableView setShowsVerticalScrollIndicator:NO];
    
    [self.btnTick setSelected:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)initializePicerView {
    if (!_pickerView) {
        self.pickerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
        self.birthYearPicker = [[UIPickerView alloc]init];
        [_pickerView addSubview:_birthYearPicker];
        _birthYearPicker.translatesAutoresizingMaskIntoConstraints = NO;
        _pickerView.translatesAutoresizingMaskIntoConstraints = NO;
        [_birthYearPicker setDelegate:self];
        [_birthYearPicker setDataSource:self];
        self.pickerViewDone = [[UIButton alloc]init];
        [self.pickerView addSubview:_pickerViewDone];
        [_pickerViewDone setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_pickerViewDone setBackgroundColor:[UIColor clearColor]];
        [_pickerViewDone addTarget:self action:@selector(hidePicker) forControlEvents:UIControlEventTouchUpInside];
        [_pickerViewDone setTitle:@"Done" forState:UIControlStateNormal];
        [_pickerViewDone setTitleColor:[UIColor themeDarkColor] forState:UIControlStateNormal];
        [_pickerViewDone.titleLabel setFont:[UIFont defualFontWithSize:16]];
        _pickerViewDone.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _pickerViewDone.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
        NSDictionary *views = NSDictionaryOfVariableBindings(_birthYearPicker,_pickerViewDone);
        NSDictionary *metrics = @{};
        [_pickerView setBackgroundColor:[UIColor clearColor]];
        [_birthYearPicker setBackgroundColor:[UIColor clearColor]];
        [_pickerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_pickerViewDone(40)]-0-[_birthYearPicker]-0-|"options:0 metrics:metrics views:views]];
        [_pickerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_birthYearPicker]-0-|"options:0 metrics:metrics views:views]];
        [_pickerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_pickerViewDone]-0-|"options:0 metrics:metrics views:views]];
    }
}

#pragma mark Keyboard Show Hide and View Layout
- (void)keyboareWillShow:(NSNotification *)notification {
    NSDictionary *info  = notification.userInfo;
    NSValue      *value = info[UIKeyboardFrameEndUserInfoKey];
    CGRect rawFrame      = [value CGRectValue];
    if (_tableOrigin == 0) {
        CGRect keyboardFrame = [self.view convertRect:rawFrame fromView:nil];
        _tableOrigin = _tableView.frame.origin.y;
        int height =SCREEN_HEIGHT - _tableOrigin - _tableView.frame.size.height;
        _tableOrigin = -keyboardFrame.size.height +height;
        if ((keyboardFrame.size.height +_tableView.frame.size.height) > SCREEN_HEIGHT) {
            _tableViewRect = _tableView.frame;
            int newTViewHeiht = SCREEN_HEIGHT-keyboardFrame.size.height;
            CGRect tRect = _tableView.frame;
            tRect.origin.y = tRect.origin.y + tRect.size.height - newTViewHeiht;
            tRect.size.height = newTViewHeiht;
            _tableView.frame = tRect;
        }
    }
    [self setNavigationOrigin:_tableOrigin];
}

- (void)keyboardDidHide:(NSNotification *)notification {
    if (_tableViewRect.size.height >0) {
        _tableView.frame = _tableViewRect;
    }
    [self setNavigationOrigin:0];
}

- (void)setNavigationOrigin:(int)value {
    CGRect rect = self.navigationController.view.frame;
    rect.origin.y = value;
    [UIView animateWithDuration:0.1 animations:^{
        self.navigationController.view.frame = rect;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)setTableViewFrame:(CGRect )rect{
    
}

- (NSArray *)getConstraintsForView:(UIView *)view{
    NSArray *constraints = self.view.constraints;
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"firstItem = %@ OR secondItem = %@", view, view];
    return  [constraints filteredArrayUsingPredicate:predicate2];
}


- (void)setVerticalConstraints{
    NSArray *views = [self.view subviews];
    UITextView *tView;
    for (UIView *view in views) {
        NSArray *constraints = [self getConstraintsForView:view];
        NSPredicate *predicateTop = [NSPredicate predicateWithFormat:@"firstAttribute = %d OR secondAttribute = %d", NSLayoutAttributeTop, NSLayoutAttributeTop];
        NSArray *topArray = [constraints filteredArrayUsingPredicate:predicateTop];
        for (NSLayoutConstraint *con  in topArray) { 
            con.constant = con.constant * [UIScreen mainScreen].bounds.size.height/667;
        }
        if ([view isKindOfClass:[UITextView class]]) {
            tView = (UITextView *)view;
            [tView setBackgroundColor:[UIColor redColor]];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.signupPlistData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * simpleTableIdentifier = @"AccountFormCell";
    AWCreateAccountTVC * cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (cell == nil) {
        cell = [[AWCreateAccountTVC alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    NSDictionary * dictionary = [self.signupPlistData objectAtIndex:indexPath.row];
    [cell setPlaceHolderText:[dictionary objectForKey:@"placeHolder"]];
    [cell setLeftImage:[dictionary objectForKey:@"leftImage"]];
    int tag = [[dictionary objectForKey:@"tag"] intValue ];
    cell.tag = tag;
    if (!_dicIndexPath) {
        self.dicIndexPath = [[NSMutableDictionary alloc]initWithCapacity:[_signupPlistData count]];
    }
    [_dicIndexPath setValue:[NSNumber numberWithLong:indexPath.row] forKey:[NSString stringWithFormat:@"%d",tag]];;
    if (_dicForForm) {
        [cell setTitleText:[_dicForForm valueForKey:[NSString stringWithFormat:@"%d",tag]]];
    }
    [cell.tfTitle setDelegate:self];
    
    if (tag >= 5) {
        [self initializePicerView];
        [cell setNonEditableLeftImage:[dictionary objectForKey:@"leftImage"]];
        cell.tfTitle.inputView = _pickerView;
    }
    if (tag == 3) {
        cell.lblDescripton.text = @"Minimum 4 Characters";
    }
    
    return cell;
}

#pragma mark- UITableView Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dictionary = [self.signupPlistData objectAtIndex:indexPath.row];
    int tag = [[dictionary objectForKey:@"tag"] intValue ];
    if (tag == 3) {
        return 75*UI_RATIO;
    }
    return 55*UI_RATIO;
}

#pragma mark- UITextField Delegate Methods

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField {
    self.selectedTextfieldsTag = textField.tag;
    textField.keyboardAppearance = UIKeyboardAppearanceDark;
    [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
     textField.returnKeyType = UIReturnKeyNext;
    switch (textField.tag) {
        case 2:
            [textField setKeyboardType:UIKeyboardTypeEmailAddress];
        break;
        
        case 3: //Passwrod
            [textField setSecureTextEntry:YES];
        break;
        
        case 4: //Confirm Passwrod
            [textField setSecureTextEntry:YES];
             textField.returnKeyType = UIReturnKeyJoin;
            break;
    
        case 5: //Year of Birth
        case 6: //Country
            [_birthYearPicker reloadAllComponents];
            break;
            
        default:
            break;
    }
   
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (!_dicForForm) {
        self.dicForForm = [[NSMutableDictionary alloc]initWithCapacity:[_signupPlistData count]];
    }
    [_dicForForm setValue:textField.text forKey:[NSString stringWithFormat:@"%ld",(long)textField.tag]];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    NSString *strText = textField.text;
    //Creates the single instance of the viewmodel
    AWCreateAccountVM * awcvm = [AWCreateAccountVM sharedInstance];
    if (textField.returnKeyType== UIReturnKeyJoin) {
        
        [textField resignFirstResponder];
        [self join:nil];
    }
    long nextTextFieldTag =[[_dicIndexPath valueForKey:[NSString stringWithFormat:@"%ld",(long)textField.tag]]integerValue]  + 1;
    if (nextTextFieldTag <= [_signupPlistData count]) {
        AWCreateAccountTVC * cell = (AWCreateAccountTVC *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:nextTextFieldTag inSection:0]];
        AWCreateAccountTVC * passwordCell = (AWCreateAccountTVC *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        NSString *errorString;
        BOOL isValid;
        switch (textField.tag) {
            case 0:
                isValid = [awcvm isValidFirstName:strText error:&errorString];
                if (!isValid) {
                    [self showValidationAlerts:errorString];
                }
                break;
                
            case 1:
                isValid = [awcvm isValidSurname:strText error:&errorString];
                if (!isValid) {
                   [self showValidationAlerts:errorString];
                }
                break;
                
            case 2:
                isValid = [awcvm isValidEmailAddress:strText error:&errorString];
                if (!isValid) {
                    [self showValidationAlerts:errorString];
                }
                break;
                
            case 3:
                isValid = [awcvm isValidPassword:strText error:&errorString];
                if (!isValid) {
                    [self showValidationAlerts:errorString];
                }
                break;
                
            case 4:
                isValid = [awcvm isValidPasswordConfirm:passwordCell.tfTitle.text withConfirmPassword:strText error:&errorString];
                if (!isValid) {
                    [self showValidationAlerts:errorString];
                }
                break;
                
            default:
                break;
        }
        if (isValid) {
            [cell.tfTitle setEnabled:YES];
            [cell.tfTitle becomeFirstResponder];
        }
        return isValid;
    }
    return NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        
    }
}

#pragma mark- Custom Methods

- (void) loadPlistData {
    PlistHelper * pl = [PlistHelper sharedInstance];
    NSMutableArray *filterdDataM = [NSMutableArray arrayWithArray:[[NSArray alloc]initWithArray: [pl readArrayfromPlist:@"SignUpViewProperties"]]];
    NSPredicate *bPredicate = [NSPredicate predicateWithFormat:@"SELF.viewMode==%d",_createAccountMode];
    NSArray *filterdData = [filterdDataM filteredArrayUsingPredicate:bPredicate]; 
    self.signupPlistData = filterdData;
}

- (void) showValidationAlerts:(NSString *)alertMessage {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"SportScore!" message:alertMessage delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                          [alert show];
}

long startYear;
- (void) initStartYear {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSString * curryearString = [formatter stringFromDate:[NSDate date]];
    startYear = [curryearString intValue] - 13;
}

- (void) initCountries {
    if (!_arrCountry) {
        _arrCountry = [[NSMutableArray alloc]init];
        NSArray *countryArray = [NSLocale ISOCountryCodes];
        for (NSString *countryCode in countryArray) {
            NSString *country = [[NSLocale systemLocale] displayNameForKey:NSLocaleCountryCode value:countryCode];
            [_arrCountry addObject:country];
        }
        NSArray *sortedCountries = [_arrCountry sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        [_arrCountry removeAllObjects];
        [_arrCountry addObjectsFromArray:sortedCountries];
    }
}

- (void) settingUIButtons {
    _btnJoin.layer.cornerRadius = 5 * UI_RATIO;
    _btnCancel.layer.cornerRadius = 5 * UI_RATIO;
}

#pragma mark- UIPickerViewDataSource/UIPickerViewDelgate Methods

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (_selectedTextfieldsTag == 5) { //Year of Birth Tapped
        return 100;
    } else {                       //Country Tapped
        return [_arrCountry count];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    int minusValue = 0;
    if (_createAccountMode == AWCreateAccountViewModeSocial) {
        minusValue = - 2;
    }
    if (_selectedTextfieldsTag == 5) { //Year of Birth Tapped
        AWCreateAccountTVC * cell = (AWCreateAccountTVC *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5+minusValue inSection:0]];
        NSString * year = [NSString stringWithFormat:@"%ld",startYear-row];
        [cell.tfTitle setText:year];
        [cell.tfNonEditableTitle setText:year];
    } else {                      //Country Tapped
        AWCreateAccountTVC * cell = (AWCreateAccountTVC *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6+minusValue inSection:0]];
        NSString * country = [NSString stringWithFormat:@"%@",[_arrCountry objectAtIndex:row]];
        [cell.tfTitle setText:country];
        [cell.tfNonEditableTitle setText:country];
    }
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString * title;
    if (_selectedTextfieldsTag == 5) { //Year of Birth Tapped
        title = [NSString stringWithFormat:@"%ld",startYear-row];
    } else {                      //Country Tapped
        title = [NSString stringWithFormat:@"%@",[_arrCountry objectAtIndex:row]];
    }
    NSAttributedString * attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    return attString;
    
}


#pragma mark- IBAction Methods

- (IBAction)tickClicked:(id)sender {
    [(UIButton *)sender setSelected:![(UIButton *)sender isSelected]];
}

- (IBAction)join:(id)sender {
    SocialLoginHelper *loginHelper = [SocialLoginHelper sharedInstance];
    AWCreateAccountVM * awcvm = [AWCreateAccountVM sharedInstance];
    NSString * errorString;
//    NSString * country;
//    NSString * birthYear;
//    NSString * firstName;
//    NSString * surnameName;
    NSString * email;
    NSString * password;
    NSString * confirmPassword;
    
    if (![loginHelper hasAPNSToken]) {
        [self showValidationAlerts:@"Please allow Push Notifications"];
        return;
    }
    
    if (!_dicForForm) {
        [self showValidationAlerts:@"Please fill in all fields"];
        return;
    }
//    firstName = [_dicForForm valueForKey:@"0"];
//    if ((![awcvm isValidFirstName:firstName error:&errorString]) || ([firstName length] == 0)) {
//        [self showValidationAlerts:errorString];
//        return;
//    }
//    surnameName = [_dicForForm valueForKey:@"1"];
//    if ((![awcvm isValidSurname:surnameName error:&errorString]) || ([surnameName length] == 0)) {
//        [self showValidationAlerts:errorString];
//        return;
//    }
    
    if (_createAccountMode == AWCreateAccountViewModeNormal) {
        email = [_dicForForm valueForKey:@"2"];
        if (![awcvm isValidEmailAddress:email error:&errorString]) {
            [self showValidationAlerts:errorString];
            return;
        }
        
        password = [_dicForForm valueForKey:@"3"];
        if (![awcvm isValidPassword:password error:&errorString]) {
            [self showValidationAlerts:errorString];
            return;
        }
        confirmPassword = [_dicForForm valueForKey:@"4"];
        if (![awcvm isValidPasswordConfirm:password withConfirmPassword:confirmPassword error:&errorString]) {
            [self showValidationAlerts:errorString];
            return;
        }
    }
//    birthYear = [_dicForForm valueForKey:@"5"];
//    if ((![awcvm isEmptyBirthYear:birthYear error:&errorString])|| ([birthYear length] == 0)) {
//        [self showValidationAlerts:errorString];
//        return;
//    }
//    country = [_dicForForm valueForKey:@"6"];
//    if ((![awcvm isEmptyCountry:country error:&errorString]) ||([country length] == 0)) {
//        [self showValidationAlerts:errorString];
//        return;
//    }
    if (!_tickButton.selected) {
        [self showValidationAlerts:@"Please agree to our terms & conditions"];
        return;
    } else {
        //Create a new account
        [self showActivityIndicator:NO];
        NSDictionary * dataDictionary;
        
        if (_createAccountMode == AWCreateAccountViewModeSocial) {
            dataDictionary = @{AS_FIRST_NAME :[self getValue:_dicForForm forKey:@"0"],
                               AS_SURNAME :[self getValue:_dicForForm forKey:@"1"],
                               AS_EMAIL :[self getValue:_dicForForm forKey:@"2"],
                               AS_YEAR_OF_BIRTH :[self getValue:_dicForForm forKey:@"5"],
                               AS_LOCATION :@"",
                               AS_PASSWORD :[self getValue:_dicForForm forKey:@"id"],
                               AS_NOTIFICATION_TOKEN :[loginHelper apnsToken],
                               AS_DEVICE_ID :[loginHelper deviceID],
                               AS_SIGNUP_TYPE :[self getValue:_dicForForm forKey:@"signup_type"],
                               AS_COUNTRY :[self getValue:_dicForForm forKey:@"0"]
                               };
        }else{
            dataDictionary = @{AS_FIRST_NAME :[self getValue:_dicForForm forKey:@"0"],
                               AS_SURNAME :[self getValue:_dicForForm forKey:@"1"],
                               AS_EMAIL :[self getValue:_dicForForm forKey:@"2"],
                               AS_YEAR_OF_BIRTH :[self getValue:_dicForForm forKey:@"5"],
                               AS_LOCATION :@"",
                               AS_PASSWORD :[self getValue:_dicForForm forKey:@"4"],
                               AS_NOTIFICATION_TOKEN :[loginHelper apnsToken],
                               AS_DEVICE_ID :[loginHelper deviceID],
                               AS_SIGNUP_TYPE :@"manual",
                               AS_COUNTRY :[self getValue:_dicForForm forKey:@"6"]
                               };
        }
        dataDictionary = @{@"user":dataDictionary};
        dataDictionary = @{@"data":dataDictionary};
        [[ASAccount sharedASAccount]createAccount:dataDictionary];
        [[ASAccount sharedASAccount]setDelegate:self];
    }
}

- (NSString *)getValue:(NSDictionary *)dic forKey:(NSString *)str{
    NSString *value = [dic valueForKey:str];
    if (value && [value length]>0) {
        return value;
    }
    return @"";
}

#pragma mark - ASAccountDelegate

- (void)createAccountFinishedWithAccesToken:(NSString *)token withError:(NSError *)error {
    [self hideActivityIndicator];
    NSString * alertMessage, * alertTitle;
    if (error) {
        if ([[error.userInfo valueForKey:@"error_code"] integerValue]== 1203) {
            alertMessage = @"Sorry! Server busy. Try again.";
            alertTitle = @"SportScore";
        } else if ([[error.userInfo valueForKey:@"error_code"] integerValue]== 1203) {
                alertMessage = @"Sorry! Server busy. Try again.";
                alertTitle = @"SportScore";
            } else if ([[error.userInfo valueForKey:@"error_code"] integerValue]== 1204) {
                alertMessage = @"Sorry! Your email already exits.";
                alertTitle = @"SportScore";
            } else if ([[error.userInfo valueForKey:@"error_code"] integerValue]== 1206) {
                alertMessage = @"Unauthorized access. Try again";
                alertTitle = @"SportScore";
            } else if ([[error.userInfo valueForKey:@"error_code"] integerValue]== 1208) {
                alertMessage = @"An account already exists with this email address. Try again.";
                alertTitle = @"SportScore";
            } else {
                alertMessage = @"No Internet Connectivity.";
                alertTitle = @"SportScore";
            }
        
//        alertMessage = [error.userInfo valueForKey:ASE_ERROR];
//        alertTitle = @"SignUp Error!";
        UIAlertView * errorAlert = [[UIAlertView alloc]initWithTitle:alertTitle message:alertMessage delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [errorAlert show];
    } else {
        [[NSUserDefaults standardUserDefaults]setValue:token forKey:APIToken];
        [[NavigationHelper sharedInstance] pushToDrawerVC:YES withOpen:20];
    }
}

- (IBAction)cancelBtnTap:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) hidePicker {
    int minusValue = 0;
    if (_createAccountMode == AWCreateAccountViewModeSocial) {
        minusValue = - 2;
    }
    if (_selectedTextfieldsTag == 5) {
        AWCreateAccountTVC * birthYearcell = (AWCreateAccountTVC *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5+minusValue inSection:0]];
        [birthYearcell endEditing:TRUE];
    } else {
        AWCreateAccountTVC * countryYearcell = (AWCreateAccountTVC *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6+minusValue inSection:0]];
        [countryYearcell endEditing:TRUE];
    } 
}
@end
