//
//  GIDSDKConstantsAndEnums.h
//  greenID Generic
//
//  Created by Stefan Bouwer on 11/4/16.
//  Copyright © 2016 VIX Verify. All rights reserved.
//

// Selfie scan startup keys

#define kGIDSDKSelfieScanEyeThreshold @"selfieEyeThreshold" // Default is 20
#define kGIDSKDSelfieScanNumberOfBlinks @"selfieNumberOfBlinks" // Default is 2
#define kGIDSDKSelfieScanResetTimeout @"selfieResetTimeout" // Default is 10
#define kGIDSDKDocumentCaptureResetTimeout @"documentCaptureResetTimeout" // Default is 15
#define kGIDSDKDocumentCaptureLicenceResetTimeout @"documentCaptureLicenceResetTimeout" // Default is 15
#define kGIDSDKDocumentCapturePassportResetTimeout @"documentCapturePassportResetTimeout" // Default is 15
#define kGIDSDKDocumentCaptureGreenIDResetTimeout @"documentCaptureGreenIDResetTimeout" // Default is 15
#define kGIDSDKMobileConfigurationUrl @"https://config.vixverify.com/certs/"
#define kGIDSDKMobileConfigCertificatesArray @"mobileConfigCertificatesArray"
#define kGIDSDKMobileConfigCertificatesPrimaryDomain @"mobileconfig.vixverify.com"

// User Inactivity startup keys
#define kGIDSDKMaxIdleTimeSeconds @"inactivityTimeoutSeconds" // Default is 300

typedef NS_ENUM(NSInteger, GIDErrorCode) {
    GIDErrorCodeInternal = -1001,
    GIDErrorCodeNetwork = -1002,
    GIDErrorCodeOCR = -1003,
    GIDErrorCodeAID = -1004,
    GIDErrorCodeSnap = -1005,
    GIDErrorCodeWebApp = -1006,
    GIDErrorCodeUserInactivity = -1007,
    GIDErrorCodeResourceBundle = -1008,
    GIDErrorCodeInitFailed = -1009,
    GIDErrorCodeNetworkSecurityError = -10010,
};

typedef NS_ENUM(NSInteger, GIDResultCode) {
    GIDResultCodeError = -1,
    GIDResultCodeNoNetwork = -2,
    GIDResultCodePlaceholder = -3,
    GIDResultCodeNetworkSecurityError = -4,
    GIDResultCodeSuccess = 0,
    GIDResultCodeCancelled = 1,
    GIDResultCodeBack = 2,
    GIDResultCodeUserInactivity = 3,
    GIDResultCodeResourceBundle = 4
};

typedef NS_ENUM(NSInteger, GIDLogLevel) {
    GIDLogLevelNone = 0,
    GIDLogLevelError = 1,
    GIDLogLevelWarn = 2,
    GIDLogLevelInfo = 4,
    GIDLogLevelTasks = 8,
    GIDLogLevelRequests = 16,
    GIDLogLevelDebug = 32,
    GIDLogLevelUI = 64,
    GIDLogLevelVerbose = 128
};

typedef NS_ENUM(NSInteger, GIDAnalyticsCode) {
    GIDAnalyticsCodeUnknown = 0,
    GIDAnalyticsCodeLoadingScreen = 1,
    GIDAnalyticsCodeDocumentCapture = 2,
    GIDAnalyticsCodeDocumentReview = 3,
    GIDAnalyticsCodeSelfieCapture = 4,
    GIDAnalyticsCodeAdditionalDocumentCapture = 5,
    GIDAnalyticsCodeLoadingScreenRemove = 6,
    GIDAnalyticsCodeForeground = 7,
    GIDAnalyticsCodeBackground = 8,
    GIDAnalyticsCodeFinish = 9,
    GIDAnalyticsCodeUITouch = 10,
};
