//
//  AWCreateAccountViewModel.m
//  Awispa
//
//  Created by Damith Hettige on 11/25/14.
//  Copyright (c) 2014 Damith Hettige. All rights reserved.
//

#import "AWCreateAccountVM.h"

@implementation AWCreateAccountVM

+ (id)sharedInstance {
    static AWCreateAccountVM *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^ {
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark- Validation Methods

- (BOOL) isPassword:(NSString *)password matchWith:(NSString *)confirmPassword {
    if (![password isEqualToString:confirmPassword]) {
        return NO;
    }
    return YES;
}

- (BOOL) isValidEmail:(NSString *)email {
    NSString *regExPattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:email options:0 range:NSMakeRange(0, [email length])];
    if (regExMatches == 0) {
        return NO;
    }
    return YES;
}

- (BOOL) isFindWhiteSpaces:(NSString *)textString {
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSRange range = [textString rangeOfCharacterFromSet:whitespace];
    if (range.location != NSNotFound) {
        return NO;
    }
    return YES;
}

-(BOOL) validateAlphabets: (NSString *)alpha {
    NSString *abnRegex = @"[A-Za-z]+"; // check for one or more occurrence of string you can also use * instead + for ignoring null value
    NSPredicate *abnTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", abnRegex];
    BOOL isValid = [abnTest evaluateWithObject:alpha];
    return isValid;
}

- (BOOL) isValidNames:(NSString *)userName {
    BOOL checkAlphabets = [self validateAlphabets:userName];
    if (!checkAlphabets)  {
        return NO;
    }
    return YES;
}

- (BOOL) isEmptyNames:(NSString *)userName {
    if ([[userName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""] || userName==nil) {
        return NO;
    }
    return YES;
}

- (BOOL) isEmptyCountry:(NSString *)country error:(NSString **)errorMsg {
    if ([country length] == 0) {
        *errorMsg = @"Country cannot be empty.";
        return NO;
    }
    return YES;
}

- (BOOL) isEmptyBirthYear:(NSString *)birthYear error:(NSString **)errorMsg {
    if ([birthYear length] == 0) {
        *errorMsg = @"Birth Year cannot be empty.";
        return NO;
    }
    return YES;
}


- (BOOL)isValidEmailAddress:(NSString *)data error:(NSString **)errorMsg {
    if (![self isEmptyNames:data]) {
        *errorMsg = @"Please provide a valid email address.";
        return NO;
    } else if (![self isValidEmail:data]) {
        *errorMsg = @"Please enter a valid email address";
        return NO;
    } else if (![self isFindWhiteSpaces:data]) {
        *errorMsg = @"Please enter a valid email address without blank spaces";
        return NO;
    }
    return YES;
}

- (BOOL)isValidFirstName:(NSString *)data error:(NSString **)errorMsg {
    if (![self isEmptyNames:data]) {
        *errorMsg = @"First Name cannot be empty.";
        return NO;
    } else if ([self validateAlphabets:data] == NO) {
        *errorMsg = @"Enter a valid First Name with alphabetic letter only.";
        return NO;
    }
    return YES;
}

- (BOOL)isValidSurname:(NSString *)data error:(NSString **)errorMsg {
    if (![self isEmptyNames:data]) {
        *errorMsg = @"Surname Name cannot be empty.";
        return NO;
    } else if ([self validateAlphabets:data] == NO) {
        *errorMsg = @"Enter a valid Surname with alphabetic letter only.";
        return NO;
    }
    return YES;
}

- (BOOL)isValidPassword:(NSString *)data error:(NSString **)errorMsg {
    if (![self isEmptyNames:data]) {
        *errorMsg = @"Please enter a password";
        return NO;
    } else if (![self isPasswordMinLength:data]) {
        *errorMsg = @"Your password must contain at least 4 characters.";
        return NO;
    }
    return YES;
}

- (BOOL)isValidPasswordConfirm:(NSString *)password withConfirmPassword:(NSString *)confirmPassword error:(NSString **)errorMsg {
    if (![self isEmptyNames:confirmPassword]) {
        *errorMsg = @"Please confirm your password";
        return NO;
    } else if (![self isPassword:password matchWith:confirmPassword]) {
        *errorMsg = @"Your passwords do not match. Please try again";
        return NO;
    }
    return YES;
}

- (BOOL)isPasswordMinLength:(NSString *)password {
    if (password.length < 4) {
        return NO;
    }
    return YES;
}



@end
