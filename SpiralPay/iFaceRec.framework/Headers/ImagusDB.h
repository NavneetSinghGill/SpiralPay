//
//  ImagusDB.h
//  imagus-facerec-objc
//
//  Created by mattgray on 30/10/17.
//  Copyright © 2017 Vix Verify. All rights reserved.
//

#ifndef ImagusDB_h
#define ImagusDB_h
#import "iFaceRec.h"

@interface ImagusDB : NSObject
- (nullable instancetype)initWithDatabaseString:(NSString * _Nonnull)databaseString;
- (IFR_CONTEXT_HANDLE _Nullable)getHandle;
- (void)clear;
- (nonnull instancetype)init;
@end


#endif /* ImagusDB_h */
