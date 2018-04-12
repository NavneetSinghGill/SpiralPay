//
//  ImagusSearchResult.h
//  imagus-facerec-objc
//
//  Created by mattgray on 30/10/17.
//  Copyright © 2017 Vix Verify. All rights reserved.
//

#ifndef ImagusSearchResult_h
#define ImagusSearchResult_h

#import "iFaceRec.h"

@interface ImagusSearchResult : NSObject

@property (nonatomic,assign) float distance;
@property (nonatomic,strong) NSString * _Nullable enrolmentId;
@property (nonatomic,strong) NSString * _Nullable personId;
@property (nonatomic,assign) int64_t matchQuality;
@property (nonatomic,strong) NSString * _Nullable personName;
@property (nonatomic,assign) float margin;


- (nonnull instancetype)initWithResult:(IFR_DISTANCERESULT)result ;

@end

#endif /* ImagusSearchResult_h */
