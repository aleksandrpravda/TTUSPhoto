//
// Copyright © 2019 Alexander Rogachev. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (TTUSValidDictionary)
- (id _Nullable)validatedValueForKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
