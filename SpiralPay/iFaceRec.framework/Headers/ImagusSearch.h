//
//  ImagusSearch.h
//  imagus-facerec-objc
//
//  Created by mattgray on 30/10/17.
//  Copyright © 2017 Vix Verify. All rights reserved.
//

#ifndef ImagusSearch_h
#define ImagusSearch_h

#import "iFaceRec.h"
#import "ImagusDB.h"
#import "ImagusFaceList.h"
#import "ImagusSearchResult.h"

@interface ImagusSearch : NSObject
- (nonnull instancetype)initWithDatabase:(ImagusDB * _Nonnull)database ;
- (ImagusSearchResult * _Nullable)resultAtI:(NSInteger)i ;
- (NSInteger)resultCount ;
- (void)searchWithFaceList:(ImagusFaceList * _Nonnull)faceList;
- (nonnull instancetype)init ;
@end

#endif /* ImagusSearch_h */
