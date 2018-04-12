//
//  CFACatfishAir.h
//  Catfish Air
//
//  Created by CH0007 on 1/29/15.
//
//

typedef NS_ENUM(NSInteger, CFASelfieCaptureMode) {
    CFAAutoCapture=1,
    CFAManualCapture,
    CFASemi_Auto
};

#import <Foundation/Foundation.h>
@protocol CFACatfishAirSelfieCaptureDelegate;

/**
 *  The CFACatfishAirSelfie encapsulates methods to initiate Framework, properties, delegate methods
 *  that returns captured or cropped documents.
 */
@interface CFACatfishAirSelfie : NSObject
@property (nonatomic, weak) id<CFACatfishAirSelfieCaptureDelegate> delegate;



/**
 *  Initialize Selfie Scan
 *
 *  @param vc                               The Parent View Controller used to present child view controller.
 *  @param selfieCaptureMode                Modes for Selfie Capture(AutoCapture, Semi Auto or Manual Capture).
 *  @param blurIntensityThreshold           This is an integer value that will decide to control the blur in the images and the higher the value, the most blur      images will be captured. Valid values are in the range 1 to 100.
 *  @param faceMotionThreshold              This is a float value that will decide the percentage of pixels inside the face box that need to be in motion. If you increase this value more face motion will be tolerated and easy to capture. Valid values are in the range 0 to 1.
 *  @param eyeMotionThreshold               This is a float value that will decide the percentage of pixels inside the eye box that need to be in motion. If you decrease this value small eye motion will be detected and easy to capture. Valid values are in the range 0 to 1.
 *  @param roiFocusThreshold                This is an integer value that will decide the threshold for Focus value of the Selfie Image within the Oval. Valid values are in the range 0-254.
 *  @param eyeIntensityThreshold            This is an integer value that will decide the threshold for eye Motion intensity that is estimated by taking the difference between two consecutive frames. Valid values are in the range 0 to 100.
 *  @param useOpenEyeDetector               Boolean value that will enable algorithm to detect open eyes.
 *  @param resetTimeOutInSec                Timeout for resetting the blink count, if the desired blinks are not reached.
 *  @param isdebugMode                      On screen statistics to be displayed during selfie capture.
 *  @param compressionQuality               The Compression quality value jpeg compression used for selfie. Valid values are in the range 0 -100.
 *  @param showTooltip                      Boolean Value to show tooltips on the screen when initiated for the first time.
 *  @param enableSwitchCamera               Boolean Value to switch camera(trigger manual Capture if back Camera).
 *  @param showConfirmationScreen           Boolean Value to show confirmation screen when capture mode is AUTO.
 *  @param captureLivenessOnConfirmation    Refers to a boolean variable. If set to “True”, the application will click the liveness selfie and if set to “False” then application will not click liveness selfie.
 *  @param locale                           This is a string value which Displays the selected language code for the application. For example: en for English. zh for               Chinese, de for German etc. By default, it is English.
 */
-(void)scanSelfie:(UIViewController*)vc selfieCaptureMode:(CFASelfieCaptureMode)selfieCaptureMode blurIntensityThreshold:(int)blurIntensityThreshold faceMotionThreshold:(double)faceMotionThreshold eyeMotionThreshold:(double)eyeMotionThreshold roiFocusThreshold:(int)roiFocusThreshold eyeIntensityThreshold:(int)eyeIntensityThreshold useOpenEyeDetector:(BOOL)useOpenEyeDetector resetTimeOutInSec:(int)resetTimeOutInSec isdebugMode:(BOOL)isdebugMode  compressionQuality:(int)compressionQuality showTooltip:(BOOL)showTooltip enableSwitchCamera:(BOOL)enableSwitchCamera showConfirmationScreen:(BOOL)showConfirmationScreen captureLivenessOnConfirmation:(BOOL)captureLivenessOnConfirmation locale:(NSString*)locale;

/**
 *  This function gives version of SDK
 *
 *  @return The current build version of SDK
 */
-(NSString*)getVersion;

/**
 *  Initialize a blank View with given text
 *
 *  @param vc       The Parent View Controller used to present child view controller.
 */
-(void)showTextView:(UIViewController*)vc;



+(id)sharedInstance;



@end

@protocol CFACatfishAirSelfieCaptureDelegate <NSObject>

-(void)catfishAir:(CFACatfishAirSelfie*)catfishAir didFinishSelfieScan:(NSData*)selfieData livenessSelfieData:(NSData*)livenessSelfieData autoCaptured:(BOOL)autoCaptured ;

-(void)catfishAirdidCancelSelfieScan:(CFACatfishAirSelfie*)catfishAir;

-(void)catfishAir:(CFACatfishAirSelfie*)catfishAir didFinishSelfieScanWithError:(NSString*)error;


@end




