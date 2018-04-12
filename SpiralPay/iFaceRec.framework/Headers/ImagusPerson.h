//
//  ImagusPerson.h
//  imagus-facerec-objc
//
//  Created by mattgray on 30/10/17.
//  Copyright © 2017 Vix Verify. All rights reserved.
//

#ifndef ImagusPerson_h
#define ImagusPerson_h

#import "ImagusDB.h"
#import "iFaceRec.h"

@interface ImagusPerson : NSObject
- (nonnull instancetype)init ;
- (nonnull instancetype)initWithName:(NSString * _Nonnull)name;
- (nonnull instancetype)initWithDb:(ImagusDB * _Nonnull)db personID:(NSString * _Nonnull)personID;
- (IFR_UUID)getID;
- (int)getTagCount;

- (NSString * _Nonnull)getTagAt:(size_t)index;
- (bool)hasTagWithName:(NSString * _Nonnull)name;
- (void)addTagWithName:(NSString * _Nonnull)name;
- (void)removeTagWithName:(NSString * _Nonnull)name;


- (void)setNameWithName:(NSString * _Nonnull)name;
- (void)saveWithDatabase:(ImagusDB * _Nonnull)database;
@end


#endif /* ImagusPerson_h */
