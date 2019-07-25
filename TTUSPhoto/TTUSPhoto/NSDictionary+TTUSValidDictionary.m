//
// Copyright © 2019 Alexander Rogachev. All rights reserved.
//

#import "NSDictionary+TTUSValidDictionary.h"

@implementation NSDictionary (TTUSValidDictionary)
- (id)validatedValueForKey:(NSString *)key {
    id value = [self valueForKey:key];
    if (value == [NSNull null]) {
        value = nil;
    }
    return value;
}
@end
