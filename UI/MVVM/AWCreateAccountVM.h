//
//  AWCreateAccountViewModel.h
//  Awispa
//
//  Created by Damith Hettige on 11/25/14.
//  Copyright (c) 2014 Damith Hettige. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AWCreateAccountVM : NSObject
+ (id)sharedInstance;

- (BOOL) isValidNames:(NSString *)userName;
- (BOOL) isEmptyNames:(NSString *)userName;
- (BOOL) isValidEmail:(NSString *)email;
- (BOOL) isFindWhiteSpaces:(NSString *)textString;
- (BOOL) isValidPassword:(NSString *)password;
- (BOOL) isPassword:(NSString *)password matchWith:(NSString *)confirmPassword;
- (BOOL) isValidCountry:(NSString *)country;
- (BOOL) isValidDob:(NSString *)dob;

- (BOOL) isValidEmailAddress:(NSString *)data error:(NSString **)errorMsg;
- (BOOL) isValidFirstName:(NSString *)data error:(NSString **)errorMsg;
- (BOOL) isValidSurname:(NSString *)data error:(NSString **)errorMsg;
- (BOOL) isValidPassword:(NSString *)data error:(NSString **)errorMsg;
- (BOOL) isValidPasswordConfirm:(NSString *)password withConfirmPassword:(NSString *)confirmPassword error:(NSString **)errorMsg;
- (BOOL)isPasswordMinLength:(NSString *)password;
- (BOOL) isEmptyCountry:(NSString *)country error:(NSString **)errorMsg;
- (BOOL) isEmptyBirthYear:(NSString *)birthYear error:(NSString **)errorMsg;

@end
