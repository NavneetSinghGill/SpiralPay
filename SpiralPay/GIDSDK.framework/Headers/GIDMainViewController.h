//
//  GIDMainViewController.h
//  greenID Generic
//
//  Created by Jawad Ahmed on 10/1/15.
//  Copyright © 2016 VIX Verify. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "GIDErrorProtocol.h"
#import <iFaceRec/iFaceRec-umbrella.h>

@class GIDMainViewController;

typedef void (^GIDWebviewLoadCompletionHandler)(void);

@protocol GIDDelegate <NSObject>
- (void)mainViewController:(nonnull GIDMainViewController *)mainViewController didCompleteProcessWithPayload:(nullable NSDictionary *)payload resultCode:(GIDResultCode)resultCode error:(nullable id <GIDErrorProtocol>)error;
@optional
- (void)mainViewController:(nonnull GIDMainViewController *)mainViewController didCompleteProcessWithPayload:(nullable NSDictionary *)payload resultCode:(GIDResultCode)resultCode DEPRECATED_MSG_ATTRIBUTE("Please use the mainViewController:didCompleteProcessWithPayload:resultCode:error: method instead");
@end

@interface GIDMainViewController : UIViewController <WKNavigationDelegate, WKScriptMessageHandler, UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, weak, nullable) id <GIDDelegate> delegate;
- (nullable instancetype)initWithConfig:(nullable NSDictionary *)configDict;
- (nullable instancetype)init DEPRECATED_MSG_ATTRIBUTE("Please use initWithConfig: instead.");
- (void) setLoggingLevel:(GIDLogLevel)level;
@end
