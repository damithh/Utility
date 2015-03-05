//
//  DHWebServiceHelper.h
//  WeatherForCast
//
//  Created by Damith Hettige on 3/5/15.
//  Copyright (c) 2015 D D C Hettige. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DHWebServiceHelper : NSObject

+ (id)sharedManager;

- (void) getAccessToken:(NSString*)deviceId;
- (void) getCountryList;
- (void) getGameList;
- (void) getAdvertisingList;
- (void) getRegsteredPlayersList;
- (void) getQuestionsList;
- (void)sendPlayersToServer;
- (void)sendServayDataToWebServer;

@end
