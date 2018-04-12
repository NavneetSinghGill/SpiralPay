//
//  GIDErrorProtocol.h
//  greenID Generic
//
//  Created by Stefan Bouwer on 11/7/16.
//  Copyright © 2016 VIX Verify. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GIDSDKConstantsAndEnums.h"

@protocol GIDErrorProtocol <NSObject>

- (NSError *)underlyingError;
- (GIDErrorCode)gidErrorCode;
- (NSString *)gidErrorLocalizedFailureReason;
- (NSString *)gidErrorRecoverySuggestionString;
- (NSString *)gidErrorShortenedDescription;

@end
