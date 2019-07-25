//
// Copyright © 2019 Alexander Rogachev. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface TTUSPhotoSearchService : NSObject
- (void)getPhotos:(NSURL *)url success:(void(^)(NSDictionary *))success failure:(void(^)(NSError *))failure;
@end

NS_ASSUME_NONNULL_END
