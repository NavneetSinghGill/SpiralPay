//
//  GIDLogManager.h
//  greenID Generic
//
//  Created by Stefan Bouwer on 4/24/17.
//  Copyright © 2017 VIX Verify. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GIDLoggerDelegate <NSObject>

@optional
- (void)sdkDidLog:(NSString *)loggedString;
- (void)sdkDidLogLevel:(NSString *)levelString levelCode:(GIDLogLevel)level analyticsCode:(GIDAnalyticsCode)analyticsCode source:(NSString *)source message:(NSString *)message;
@end

@interface GIDLogManager : NSObject
+ (instancetype)sharedData;

@property (nonatomic, weak) id <GIDLoggerDelegate> logger;
@property (nonatomic) int logLevel;
@end



