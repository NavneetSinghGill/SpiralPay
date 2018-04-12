//
//  ImagusDB.h
//  imagus-facerec-objc
//

#ifndef ImagusUUID_h
#define ImagusUUID_h
#import "iFaceRec.h"

@interface ImagusUUID : NSObject
@property (nonatomic)   IFR_UUID  uuid;
- (id) initWithString:(NSString *)fromString;
- (id) initWithIFR_UUID:(IFR_UUID)fromUUID;
- (BOOL) isEqual:(id)anObject;
@end


#endif /* ImagusUUID_h */
