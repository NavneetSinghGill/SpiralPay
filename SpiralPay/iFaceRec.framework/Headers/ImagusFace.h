//
//  ImagusFace.h
//  imagus-facerec-objc
//
//  Created by mattgray on 26/10/17.
//  Copyright © 2017 Vix Verify. All rights reserved.
//

@import UIKit;
#ifndef ImagusFace_h
#define ImagusFace_h

#import "iFaceRec.h"

@interface ImagusFace : NSObject
- (nullable instancetype)initWithUiimage:(UIImage * _Nonnull)uiimage;
- (nullable instancetype)initWithCiimage:(CIImage * _Nonnull)ciimage;
- (nonnull instancetype)initWithFaceHandle:(IFR_FACE_HANDLE _Nonnull)faceHandle;
- (UIImage * _Nonnull)getImage;
- (double)getQuality;
- (NSString * _Nonnull)getUUID;
- (IFR_FACE_HANDLE _Nullable)getHandle;
- (nonnull instancetype)init;
@end


#endif /* ImagusFace_h */
