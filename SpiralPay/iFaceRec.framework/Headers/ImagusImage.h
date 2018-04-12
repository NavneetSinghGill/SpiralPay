//
//  ImagusImage.h
//  imagus-facerec-objc
//
//  Created by mattgray on 30/10/17.
//  Copyright © 2017 Vix Verify. All rights reserved.
//

#ifndef ImagusImage_h
#define ImagusImage_h

#import "iFaceRec.h"

@interface ImagusImage : NSObject
@property (nonatomic) NSString * _Nullable creationData;
@property (nonatomic) int64_t UTCTime;
@property (nonatomic, readonly) int width;
@property (nonatomic, readonly) int height;
@property (nonatomic, readonly) int widthStep;
@property (nonatomic, readonly) int pixelWidth;
@property (nonatomic, readonly) unsigned char* _Nullable dataPointer;
- (UIImage * _Nullable)uiImageFromCIImageWithCiImage:(CIImage * _Nonnull)ciImage;
- (nonnull instancetype)initWithUiimage:(UIImage * _Nonnull)uiimage;
- (nonnull instancetype)initWithCiimage:(CIImage * _Nonnull)ciimage;
- (nonnull instancetype)initWithImageHandle:(IFR_IMAGE_HANDLE _Nonnull)imageHandle;
- (IFR_IMAGE_HANDLE _Nullable)getHandle;
- (NSString* _Nonnull)getTimeAsUTCString;
- (UIImage * _Nonnull)toUIImage;
- (CIImage * _Nonnull)toCIImage;
- (nonnull instancetype)init;
@end



#endif /* ImagusImage_h */
