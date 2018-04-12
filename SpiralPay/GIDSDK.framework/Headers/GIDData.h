//
//  GIDData.h
//  greenID Generic
//
//  Created by Jawad Ahmed on 10/21/15.
//  Copyright © 2016 VIX Verify. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GIDData : NSObject
// Required
@property (nonatomic, copy) NSString *accountID DEPRECATED_MSG_ATTRIBUTE("Public access to GIDData will be removed in a future release.  Please use [[GIDMainViewController alloc] initWithConfig:] instead, and remove GIDData from your setup.");
@property (nonatomic, copy) NSString *apiCode DEPRECATED_ATTRIBUTE;
@property (nonatomic, copy) NSString *baseURL DEPRECATED_ATTRIBUTE;
@property (nonatomic, copy) NSString *mode DEPRECATED_ATTRIBUTE;
// Optional
@property (nonatomic, copy) NSString *ruleID DEPRECATED_ATTRIBUTE;
@property (nonatomic, copy) NSString *countryCode DEPRECATED_ATTRIBUTE;
@property (nonatomic, copy) NSString *customCSSPath DEPRECATED_ATTRIBUTE;
@property (nonatomic, copy) NSString *documentName DEPRECATED_ATTRIBUTE;
@property (nonatomic, copy) NSString *documentType DEPRECATED_ATTRIBUTE;
@property (nonatomic, copy) NSString *selectedDocumentType DEPRECATED_ATTRIBUTE;
@property (nonatomic, copy) NSNumber *enableFaceCapture DEPRECATED_ATTRIBUTE;
@property (nonatomic, copy) NSNumber *enableSkipBackOfCard DEPRECATED_ATTRIBUTE;
@property (nonatomic, copy) NSNumber *enableIdentityVerification DEPRECATED_ATTRIBUTE;
@property (nonatomic, copy) NSNumber *enableOCRConfirmationScreen DEPRECATED_ATTRIBUTE;
@property (nonatomic, copy) NSNumber *enableProcessOverviewScreen DEPRECATED_ATTRIBUTE;
@property (nonatomic, copy) NSNumber *enableInternalBrowser DEPRECATED_ATTRIBUTE;
@property (nonatomic, copy) NSString *verificationToken DEPRECATED_ATTRIBUTE;
@property (nonatomic, copy) NSDictionary *additionalParameters DEPRECATED_ATTRIBUTE;
// Can't override
@property (readonly, nonatomic) NSString *jbCheck;
@property (readonly, nonatomic) NSString *sdkCapability;
@property (nonatomic, retain) NSDictionary *params;
+ (instancetype)sharedData;

@end
