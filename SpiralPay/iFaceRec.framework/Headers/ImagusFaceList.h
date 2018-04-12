//
//  ImagusFaceList.h
//  imagus-facerec-objc
//
//  Created by mattgray on 30/10/17.
//  Copyright © 2017 Vix Verify. All rights reserved.
//

#ifndef ImagusFaceList_h
#define ImagusFaceList_h

#import "ImagusDB.h"
#import "ImagusFace.h"
#import "ImagusPerson.h"

@interface ImagusFaceList : NSObject
- (nonnull instancetype)init ;
- (nonnull instancetype)initWithFace:(ImagusFace * _Nullable)face;
- (nonnull instancetype)initWithImage:(CIImage * _Nonnull)image;
- (void)addFaceWithFace:(ImagusFace * _Nonnull)face;
- (void)addFaceWithFace:(ImagusFace * _Nonnull)face numToKeep:(NSInteger)numToKeep;
- (void)enrolToExistingPersonWithDatabase:(ImagusDB * _Nonnull)database person:(ImagusPerson * _Nonnull)person;
- (void)enrolToNewPersonWithDatabase:(ImagusDB * _Nonnull)database personName:(NSString * _Nonnull)personName;
- (IFR_FACELIST_HANDLE _Nonnull)getHandle ;
- (NSInteger)count ;
- (ImagusFace * _Nonnull)getFaceAt:(NSInteger)at ;
@end

#endif /* ImagusFaceList_h */
