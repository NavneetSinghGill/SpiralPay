//
//  ImagusCamera.h
//  imagus-facerec-objc
//
//  Created by mattgray on 26/10/17.
//  Copyright © 2017 Vix Verify. All rights reserved.
//

#ifndef ImagusCamera_h
#define ImagusCamera_h

#import "iFaceRec.h"
#import "ImagusFace.h"

@protocol ImagusCameraDelegate
- (void)onFaceAvailableWithFace:(ImagusFace * _Nonnull)face;
- (void)onCaptureWithImage:(CIImage * _Nonnull)image;
@end

@interface ImagusCamera : NSObject <AVCaptureVideoDataOutputSampleBufferDelegate>
@property (nonatomic, readonly, strong) AVCaptureSession * _Nonnull captureSession;
@property (nonatomic, weak) id <ImagusCameraDelegate> _Nullable delegate;
- (nonnull instancetype)initWithPosition:(AVCaptureDevicePosition)position;
- (void)captureOutput:(AVCaptureOutput * _Null_unspecified)captureOutput didOutputSampleBuffer:(CMSampleBufferRef _Null_unspecified)sampleBuffer fromConnection:(AVCaptureConnection * _Null_unspecified)connection;
- (nonnull instancetype)init;

+ (NSArray<ImagusFace *> * _Nonnull)detectWithPersonciImage:(CIImage * _Nonnull)personciImage faceDetector:(CIDetector * _Nullable)faceDetector;

@end

#endif /* ImagusCamera_h */
