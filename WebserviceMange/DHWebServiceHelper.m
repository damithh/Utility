//
//  DHWebServiceHelper.m
//  WeatherForCast
//
//  Created by Damith Hettige on 3/5/15.
//  Copyright (c) 2015 D D C Hettige. All rights reserved.
//

#import "DHWebServiceHelper.h"

@implementation DHWebServiceHelper
+ (id)sharedManager {
    static DHWebServiceHelper *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

#pragma mark - Helper Methods
// to create request
- (NSURLRequest *)reqeustForURL:(NSString *)urlStr withHTTPMethod:(NSString *)httpMethod{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:REQUEST_TIMEOUT];
    // Specify that it will be a POST request
    request.HTTPMethod = httpMethod;
    // This is how we set header fields
    NSString *accessToken = [[ASHelper sharedHelper] getApiToken];
    if (accessToken && accessToken.length > 0) {
        [request setValue:accessToken forHTTPHeaderField:@"Token"];
    }
    [request setValue:@"application/json" forHTTPHeaderField:@"accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    return request;
}

// service connector method for GET
- (void)getDataFromServerWithURL:(NSString *)url withHTTPMethod:(NSString *)method withSelector:(SEL)selector {
    NSURLRequest *request = [self reqeustForURL:url withHTTPMethod:method];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:configuration ];
    NSURLSessionDataTask *dTask = [urlSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *jSonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if (error) {
            if (_syncStarted) {
                _syncStarted = NO;
            }
            [self hideActivityIndicator];
        }else{
            if ([self respondsToSelector:selector]) {
                NSMethodSignature *methodSig = [[self class] instanceMethodSignatureForSelector:selector];
                NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
                [invocation setSelector:selector];
                [invocation setTarget:self];
                [invocation setArgument:&jSonDic atIndex:2];
                [invocation invoke];
            }
        }
    }];
    [dTask resume];
}

// service connector method for POST
- (void)postDataWithURL:(NSString *)url withData:(NSDictionary *)dataDic withSelector:(SEL)selector{
    NSURLRequest *reqest = [self reqeustForURL:url withHTTPMethod:@"POST"];
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDic options:NSJSONWritingPrettyPrinted error:&error];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:reqest fromData:data completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error) {
            
        }else {
            if ([self respondsToSelector:selector]) {
                NSError *errorJSON;
                NSDictionary *dic =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&errorJSON];
                NSMethodSignature *methodSig = [[self class] instanceMethodSignatureForSelector:selector];
                NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
                [invocation setSelector:selector];
                [invocation setTarget:self];
                [invocation setArgument:&dic atIndex:2];
                [invocation invoke];
            }
        }
    }];
    [uploadTask resume];
}

// create POST request
- (void)getDataWithPOST:(NSString *)urlStr selector:(SEL)selector{
    [self getDataFromServerWithURL:urlStr withHTTPMethod:@"POST" withSelector:selector];
}

// create GET request
- (void)getDataWithGET:(NSString *)urlStr selector:(SEL)selector{
    [self getDataFromServerWithURL:urlStr withHTTPMethod:@"GET" withSelector:selector];
}

#pragma mark - Service get calls
- (void) getAccessToken:(NSString*)deviceId {
    [(EHAppDelegate *)[[UIApplication sharedApplication]delegate]showActivityIndicator];
    NSMutableString *url = [[NSMutableString alloc] initWithFormat:@"%@%@%@",BASE_URL,GET_ACCESS_TOKEN,deviceId];
    [self getDataWithPOST:url selector:@selector(accessTokenReceived:)];
}

- (void) getCountryList{
    NSMutableString *url = [[NSMutableString alloc] initWithFormat:@"%@%@",BASE_URL,GET_COUNTRIES];
    [self getDataWithGET:url selector:@selector(countryListReceived:)];
}

- (void) getGameList{
    NSMutableString *url = [[NSMutableString alloc] initWithFormat:@"%@%@",BASE_URL,GET_GAMES];
    [self getDataWithGET:url selector:@selector(gameListReceived:)];
}

- (void) getAdvertisingList{
    NSMutableString *url = [[NSMutableString alloc] initWithFormat:@"%@%@",BASE_URL,GET_ADVERTISING];
    [self getDataWithGET:url selector:@selector(advertisingListReceived:)];
}

- (void) getRegsteredPlayersList{
    NSMutableString *url = [[NSMutableString alloc] initWithFormat:@"%@%@",BASE_URL,GET_PLAYERS];
    [self getDataWithGET:url selector:@selector(registeredPlayerReceived:)];
}

- (void) getQuestionsList{
    //    NSMutableString *url = [[NSMutableString alloc] initWithFormat:@"%@%@",BASE_URL,GET_QUESTIONS];
    //    [self getDataWithGET:url selector:@selector(questionsListReceived:)];
}


#pragma mark service POST call
- (void)sendPlayersToServer {
    NSArray *players = [[DMManager sharedManager]getPlayerListFromDB];
    NSMutableArray *dbArray = [[NSMutableArray alloc]initWithCapacity:[players count]];
    for (DMPlayer *player in players) {
        NSMutableDictionary * info = [[NSMutableDictionary alloc] init];
        [info setObject:player.player_name forKey:@"name"];
        [info setObject:player.player_email forKey:@"email"];
        [info setObject:player.player_signature forKey:@"digital_signature"];
        [info setObject:player.player_advertising_source_id forKey:@"id_advertising_source"];
        if (player.player_advertising_other && player.player_advertising_other.length>0) {
            [info setObject:player.player_advertising_other forKey:@"other_advertising_source"];
        } else {
            [info setObject:@"" forKey:@"other_advertising_source"];
        }
        [info setObject:player.player_country_id forKey:@"id_country"];
        [info setObject:player.player_team_id forKey:@"id_team"];
        [info setObject:[NSNumber numberWithInteger:0] forKey:@"newsletter_signup"];
        [info setObject:[NSNumber numberWithBool:1] forKey:@"leader"];
        [info setObject:player.player_yob forKey:@"yob"];
        [info setObject:player.player_game_id forKey:@"id_game"];
        [info setObject:player.player_date forKey:@"date"];
        [info setObject:player.player_time forKey:@"time"];
        [info setObject:player.player_noofplayers forKey:@"no_of_players"];
        NSManagedObjectID * moID = [player objectID];
        NSURL * instanceURL = moID.URIRepresentation;
        [info setObject:[instanceURL absoluteString] forKey:@"id_local"];
        [dbArray addObject:info];
    }
    NSDictionary * dic = @{@"players":dbArray};
    dic = @{@"data":dic};
    [self postDataWithURL:[NSString stringWithFormat:@"%@%@",BASE_URL,REGISTER_PLAYER] withData:dic withSelector:@selector(playerRegistraionSuccessFull:)];
}

- (void)sendServayDataToWebServer {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"player_id > %@",@0];
    NSMutableArray *feedBackArray  = [NSMutableArray arrayWithArray:[[DMManager sharedManager] getServayListFromDBWithPredicate:predicate]];
    NSArray *arrPlayerID = [feedBackArray valueForKey: @"player_id"];
    NSSet *set = [NSSet setWithArray: arrPlayerID];
    arrPlayerID = [set allObjects];
    NSMutableArray *surways = [[NSMutableArray alloc]initWithCapacity:[arrPlayerID count]];
    for (id value in arrPlayerID) {
        NSArray *filterdArray = [feedBackArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.player_id == %@",value]];
        NSMutableArray *dataDicArray = [[NSMutableArray alloc]init];
        for (DMPlayer_Question_Answer *surway in filterdArray) {
            NSDictionary *dic = @{@"id_answer": surway.answer_id, @"id_question": surway.question_id};
            [dataDicArray addObject:dic];
        }
        predicate = [NSPredicate predicateWithFormat:@"player_id == %@",value];
        NSArray *feedBacks = [[DMManager sharedManager]fetchEntity:@"DMPlayer_Feedback" withPredicate:predicate];
        NSString *feedBack =  @"";
        for (DMPlayer_Feedback *fb in feedBacks) {
            feedBack = fb.player_feedback;
            break;
        }
        NSDictionary *dic = @{@"answers":dataDicArray, @"id_player":value, @"feedback": feedBack};
        [surways addObject:dic];
    }
    NSDictionary *dic = @{@"surveys":surways};
    dic = @{@"data":dic};
    [self postDataWithURL:[NSString stringWithFormat:@"%@%@",BASE_URL,SUBMIT_ANSWERS]  withData:dic withSelector:@selector(surwaySubmitedSuccessFully:)];
}

- (void)sendOfflineServayDataToWebServer {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"player_id == %@",@0];
    NSMutableArray *feedBackArray  = [NSMutableArray arrayWithArray:[[DMManager sharedManager] getServayListFromDBWithPredicate:predicate]];
    NSArray *arrPlayerName = [feedBackArray valueForKey: @"player_name"];
    NSSet *set = [NSSet setWithArray: arrPlayerName];
    arrPlayerName = [set allObjects];
    NSMutableArray *surways = [[NSMutableArray alloc]initWithCapacity:[arrPlayerName count]];
    for (id value in arrPlayerName) {
        NSArray *filterdArray = [feedBackArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.player_name == %@",value]];
        NSMutableArray *dataDicArray = [[NSMutableArray alloc]init];
        for (DMPlayer_Question_Answer *surway in filterdArray) {
            NSDictionary *dic = @{@"id_answer": surway.answer_id, @"id_question": surway.question_id};
            [dataDicArray addObject:dic];
        }
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"player_id == %@",value];
        NSArray *feedBacks = [[DMManager sharedManager]fetchEntity:@"DMPlayer_Feedback" withPredicate:predicate];
        NSString *feedBack =  @"";
        for (DMPlayer_Feedback *fb in feedBacks) {
            feedBack = fb.player_feedback;
            break;
        }
        NSDictionary *dic = @{@"answers":dataDicArray, @"player_name":value, @"feedback": feedBack};
        [surways addObject:dic];
    }
    NSDictionary *dic = @{@"surveys":surways};
    dic = @{@"data":dic};
    [self postDataWithURL:[NSString stringWithFormat:@"%@%@",BASE_URL,SURVEY_OFFLINE]  withData:dic withSelector:@selector(oflineSurwaySubmitedSuccessFully:)];
}



#pragma mark called back metod
- (void) accessTokenReceived:(NSDictionary *)objectNotation {
    [[ASHelper sharedHelper]setAPIToken:[objectNotation valueForKeyPath:@"data.hash"]];
    if (![[NSUserDefaults standardUserDefaults]boolForKey:ISDataBaseUpdated]) {
        [self wipeDataBase];
        [self getCountryList];
    } else {
        [self hideActivityIndicator];
    }
}


- (void) accessTokenReceivedFailedWithError:(NSError *)error {
    [self hideActivityIndicator];
}

- (void) countryListReceived:(NSDictionary *)objectNotation {
    EHAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    NSEntityDescription *entityDes= [NSEntityDescription entityForName:@"DMCountry" inManagedObjectContext:delegate.managedObjectContext];
    NSArray * objects = [objectNotation valueForKeyPath:@"data.country"];
    for (NSDictionary * gameDict in objects) {
        DMCountry *county = [[DMCountry alloc]initWithEntity:entityDes insertIntoManagedObjectContext:delegate.managedObjectContext];
        county.country_id = [NSNumber numberWithInt:[[gameDict objectForKey:@"id"]intValue]];
        county.country_name = [gameDict objectForKey:@"name"];
        county.country_status = [NSNumber numberWithInt:[[gameDict objectForKey:@"status"]intValue]];
    }
    [delegate saveContext];
    _dataBaseUpdated = YES;
    [self getGameList];
}

- (void) countryListReceivedFailedWithError:(NSError *)error {
    _dataBaseUpdated = NO;
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:ISDataBaseUpdated];
    [self hideActivityIndicator];
}

- (void) gameListReceived:(NSDictionary *)objectNotation {
    EHAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    NSEntityDescription *entitiDescription = [NSEntityDescription entityForName:@"DMGame" inManagedObjectContext:delegate.managedObjectContext];
    NSArray * objects = [objectNotation valueForKeyPath:@"data.game"];
    for (NSDictionary * gameDict in objects) {
        DMGame *dGame = [[DMGame alloc]initWithEntity:entitiDescription insertIntoManagedObjectContext:delegate.managedObjectContext];
        [dGame setGame_id:[NSNumber numberWithInt:[[gameDict objectForKey:@"id"]intValue]]];
        [dGame setGame_name:[gameDict objectForKey:@"name"]];
        [dGame setGame_status:[NSNumber numberWithInt:[[gameDict objectForKey:@"status"]intValue]]];
    }
    [delegate saveContext];
    [self getAdvertisingList];
    if (_dataBaseUpdated) {
        _dataBaseUpdated = YES;
    }
}

- (void) gameListReceivedFailedWithError:(NSError *)error {
    _dataBaseUpdated = NO;
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:ISDataBaseUpdated];
    [self hideActivityIndicator];
}

- (void) advertisingListReceived:(NSDictionary *)objectNotation {
    [self getQuestionsList];
    EHAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    NSEntityDescription *entDes = [NSEntityDescription entityForName:@"DMAdvertising_source" inManagedObjectContext:delegate.managedObjectContext];
    NSArray * objects = [objectNotation valueForKeyPath:@"data.advertising_source"];
    for (NSDictionary * adDict in objects) {
        DMAdvertising_source *ad = [[DMAdvertising_source alloc]initWithEntity:entDes insertIntoManagedObjectContext:delegate.managedObjectContext];
        ad.advertising_id = [NSNumber numberWithInt:[[adDict objectForKey:@"id"]intValue]];
        ad.advertising_title = [adDict objectForKey:@"title"];
        ad.advertising_type = [adDict objectForKey:@"type"];
    }
    [delegate saveContext];
    if (_dataBaseUpdated) {
        _dataBaseUpdated = YES;
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:ISDataBaseUpdated];
        [self hideActivityIndicator];
    }
}

- (void) advertisingListReceivedFailedWithError:(NSError *)error {
    _dataBaseUpdated = NO;
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:ISDataBaseUpdated];
    [self hideActivityIndicator];
}

- (void) registeredPlayerReceived:(NSDictionary *)objectNotation {
    EHAppDelegate * appDelegate = [[UIApplication sharedApplication]delegate];
    NSArray * aObjects = [objectNotation valueForKeyPath:@"data.player"];
    for (NSDictionary *dic in aObjects) {
        NSNumber *playerWebID = [NSNumber numberWithInt:[[dic objectForKey:@"id"]intValue]];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"player_web_id==%@",playerWebID];
        NSArray *players = [[DMManager sharedManager] fetchEntity:@"DMPlayer" withPredicate:predicate];
        if (!players || [players count]<=0) {
            NSEntityDescription * entDes = [NSEntityDescription entityForName:@"DMPlayer" inManagedObjectContext:appDelegate.managedObjectContext];
            DMPlayer * playerObj = [[DMPlayer alloc]initWithEntity:entDes insertIntoManagedObjectContext:appDelegate.managedObjectContext];
            playerObj.player_name = [dic objectForKey:@"name"];
            playerObj.player_web_id = [NSNumber numberWithInt:[[dic objectForKey:@"id"]intValue]];
        }
    }
    [appDelegate saveContext];
    _syncStarted = NO;
}

- (void) registeredPlayerJSONFailedWithError:(NSError *)error {
    
}

- (void)playerRegistraionSuccessFull:(NSDictionary *)dataDic {
    NSArray *array = [dataDic valueForKeyPath:@"data.ids"];
    EHAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    for (NSDictionary *dic  in array) {
        DMPlayer *managedObject=(DMPlayer *) [delegate.managedObjectContext objectWithID:[delegate.persistentStoreCoordinator managedObjectIDForURIRepresentation:[NSURL URLWithString:[dic valueForKey:@"local_id"]]]];
        managedObject.player_web_id = [dic valueForKey:@"remote_id"];
    }
    [delegate saveContext];
    [self sendServayDataToWebServer];
}

- (void)playerRegistraionFailed:(NSError *)error {
    
}

-(void)surwaySubmitedSuccessFully:(NSDictionary *)dataDic {
    EHAppDelegate * appDelegate = [[UIApplication sharedApplication]delegate];
    NSArray * aObjects = [dataDic valueForKeyPath:@"data.ids"];
    for (id value in aObjects) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"player_id==%@",value];
        NSArray *surways = [[DMManager sharedManager]fetchEntity:@"DMPlayer_Question_Answer" withPredicate:predicate];
        for (DMPlayer_Question_Answer *surway in surways) {
            [appDelegate.managedObjectContext deleteObject:surway];
        }
        predicate = [NSPredicate predicateWithFormat:@"player_id == %@",value];
        NSArray *feedBacks = [[DMManager sharedManager]fetchEntity:@"DMPlayer_Feedback" withPredicate:predicate];
        for (DMPlayer_Feedback *fb in feedBacks) {
            [appDelegate.managedObjectContext deleteObject:fb];
        }
    }
    [appDelegate saveContext];
    [self sendOfflineServayDataToWebServer];
}

- (void)surwaySubmitedFailed:(NSError *)error {
    
}

-(void)oflineSurwaySubmitedSuccessFully:(NSDictionary *)dataDic{
    EHAppDelegate * appDelegate = [[UIApplication sharedApplication]delegate];
    NSArray * aObjects = [dataDic valueForKeyPath:@"data.names"];
    for (id value in aObjects) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"player_name==%@",value];
        NSArray *surways = [[DMManager sharedManager]fetchEntity:@"DMPlayer_Question_Answer" withPredicate:predicate];
        for (DMPlayer_Question_Answer *surway in surways) {
            [appDelegate.managedObjectContext deleteObject:surway];
        }
        predicate = [NSPredicate predicateWithFormat:@"player_id == %@",value];
        NSArray *feedBacks = [[DMManager sharedManager]fetchEntity:@"DMPlayer_Feedback" withPredicate:predicate];
        for (DMPlayer_Feedback *fb in feedBacks) {
            [appDelegate.managedObjectContext deleteObject:fb];
        }
    }
    [appDelegate saveContext];
    [self getRegsteredPlayersList];
}

#pragma mark - SYNC

@end
