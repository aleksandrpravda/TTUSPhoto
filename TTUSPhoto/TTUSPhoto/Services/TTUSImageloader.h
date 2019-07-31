//
// Copyright © 2019 Alexander Rogachev. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TTUSImageloader <NSObject>
- (void)loadImageWith:(NSString *)stringURL success:(void(^)(NSData *))success failure:(void(^)(NSError *))failure;
- (NSData * _Nullable)getCachedImageData:(NSString *)stringURL;
- (void)cancel;
@end

@interface TTUSImageloaderImpl : NSObject<TTUSImageloader>
- (instancetype)initWithCahce:(NSURLCache *)cache;
@end

NS_ASSUME_NONNULL_END
