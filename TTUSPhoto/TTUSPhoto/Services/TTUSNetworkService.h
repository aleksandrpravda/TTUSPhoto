//
// Copyright © 2019 Alexander Rogachev. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface TTUSNetworkService : NSObject
+ (void)makeRequest:(NSURLRequest *)request success:(void(^)(NSDictionary *))success failure:(void(^)(NSError *))failure;
@end

NS_ASSUME_NONNULL_END
