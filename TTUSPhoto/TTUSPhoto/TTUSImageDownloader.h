//
// Copyright © 2019 Alexander Rogachev. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTUSImageDownloader : NSObject
- (instancetype)initWithCahce:(NSURLCache *)cache;
- (void)loadImageWith:(NSString *)stringURL success:(void(^)(NSData *))success failure:(void(^)(NSError *))failure;
- (void)cancel;
@end

NS_ASSUME_NONNULL_END
