//
//  CFACatfishAir.h
//  Catfish Air
//
//  Created by CH0007 on 1/29/15.
//
//
//typedef NS_ENUM(NSInteger, CFAAppTheme) {
//    CFAAppThemeBlue=1,
//    CFAAppThemeGreen,
//    CFAAppThemeOrange,
//    CFAAppThemeTurqoise,
//    CFAAppThemePurple,
//    CFAAppThemeBlack,
//    CFAAppThemeDefault
//};

typedef NS_ENUM(NSInteger, CFADocumentType) {
    CFALicense=1,
    CFAPassport_Portrait,
    CFAPassport_Landscape,
    CFA_ID2_Document,
    CFAGreenID
};
typedef NS_ENUM(NSInteger, CFADocumentSide) {
    CFAFront=1,
    CFABack
};
typedef NS_ENUM(NSInteger, CFACaptureMode) {
    CFAAuto=1,
    CFAManual
};
typedef NS_ENUM(NSInteger, CFACompressionType) {
    CFAJPEG=1
};

#import <Foundation/Foundation.h>

@protocol CFACatfishAirDocumentCaptureDelegate;

/**
 *  The CFACatfishAirDocument encapsulates methods to initiate Framework, properties, delegate methods
 *  that returns captured or cropped documents.
 */
@interface CFACatfishAirDocument : NSObject
@property (nonatomic, weak) id<CFACatfishAirDocumentCaptureDelegate> delegate;

/**
 *  Initialize Document Scan
 *
 *  @param vc                           The Parent View Controller used to present child view controller.
 *  @param docSide                      The document side that needs to be scanned (Front or Back).
 *  @param docType                      The type of document (Licence, ID2, Passport).
 *  @param galleryEnabled               Option to upload a image from gallery.
 *  @param documentCaptureMode          Modes for Document Capture(AutoCapture or Manual Capture).
 *  @param timeout                      Integer timeout that control the transition from Auto to Manual capture.
 *  @param initialTimeOutToManualInSec  Initial timeout for resetting the blink count, if the desired blinks are not reached. 
 *  @param focusThreshold               Integer value that defines the focus threshold (possible values 1 – 255).200 is the suggested threshold
 *  @param glareThreshold               Float value that defines the glare threshold (possible values 0.005 - 0.5).0.005 is the suggested threshold
 *  @param compressionType              The Final cropped images will be compressed in the specified format. Currently, supports only JPEG
 *  @param compressionQuality           The Compression quality value for the above compression type selected. Valid values are in the range 0 -100.
 *  @param targetDPI                    The target resolution of the final rectified images. If a value of 0 is specified the default resolution is applied.
 *                                      Supported range is 300 to 1500.
 *  @param showTooltip                  Boolean Value to show tooltips on the screen when initiated for the first time.
 *  @param showCropper                  Boolean Value to show the cropper screen after the document rectification process completes.
 *  @param captureLivenessSelfie        Boolean Value that enables to capture sneaky selfie during document scan.
 *  @param enableFlashCapture           Boolean Value which determines to capture only (No flash) or both(No flash/ flash).
 *  @param enableLevelling              Boolean Value for enabling bubble level.If set to True, document is captured only when the bubble turns Green and
                                        centered.
 *  @param enableRectification          Boolean Value for enabling rectification of image.If set to True,image will be rectified and it is set to false image will not be rectified.
 *  @param locale                       This is a string value which Displays the selected language code for the application. For example: en for English. zh for               Chinese, de for German etc. By default, it is English.
 */
-(void)scanDocument:(UIViewController*)vc documentSide:(CFADocumentSide)docSide documentType:(CFADocumentType)docType enablePickFromGallery:(BOOL) galleryEnabled documentCaptureMode:(CFACaptureMode)documentCaptureMode timeouttoManualinSec:(int)timeout initialTimeOutToManualInSec:(int)initialTimeOutToManualInSec focusThreshold:(int)focusThreshold glareThreshold:(float)glareThreshold  compressionType:(CFACompressionType)compressionType compressionQuality:(int)compressionQuality targetDPI:(int)targetDPI showTooltip:(BOOL)showTooltip showCropper:(BOOL)showCropper captureLivenessSelfie:(BOOL)captureLivenessSelfie enableFlashCapture:(BOOL)enableFlashCapture enableLevelling:(BOOL)enableLevelling enableRectification:(BOOL)enableRectification locale:(NSString*)locale;
/**
 *  This function gives version of SDK
 *
 *  @return The current build version of SDK
 */
-(NSString*)getVersion;
/**
 * Get shared Instance
 */
+(id)sharedInstance;
/**
 * Starts liveness selfie scan
 *
 *  @param compressionQuality                           The Compression quality value for the above compression type selected. Valid values are in the range 0 -100.
 */
-(void)scanLivenessSelfieWithCompressionQuality:(int)compressionQuality;
/**
 * Use this method to handle liveness selfie in background lifecycle
 */
-(void)cancelLivenessSelfie;
@end

@protocol CFACatfishAirDocumentCaptureDelegate <NSObject>

-(void)catfishAir:(CFACatfishAirDocument*)catfishAir didFinishDocumentScan:(NSData*)docData docFlashData:(NSData*)docFlashData originalDocData:(NSData*)originalDocData originalDocFlashData:(NSData*)originalDocFlashData livenessSelfieData:(NSData*)livenessSelfieData autoCaptured:(BOOL)autoCaptured focus:(BOOL)focus glare:(BOOL)glare faceDetected:(BOOL)faceDetected;

-(void)catfishAirdidCancelDocumentScan:(CFACatfishAirDocument*)catfishAir;

-(void)onPassportMRZData:(NSString*)MRZString1 mrzString2:(NSString*)MRZString2 catfishAir :(CFACatfishAirDocument*)catfishAir;

-(void)on2DBarcodeData:(NSDictionary*)dict2DBarcode catfishAir :(CFACatfishAirDocument*)catfishAir;

-(void)catfishAir:(CFACatfishAirDocument*)catfishAir didFinishDocumentScanWithError:(NSString*)error;

-(void)catfishAir:(CFACatfishAirDocument*)catfishAir didFinishLivenessSelfie:(NSData*)livenessSelfieData;

-(void)catfishAir:(CFACatfishAirDocument*)catfishAir didFinishLivenessSelfieWithError:(NSString*)error;
@end




