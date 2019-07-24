//
// Copyright © 2019 Alexander Rogachev. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef struct PhotoSearchParams {
    NSInteger perPage;
    NSString *orderedBy;
    NSString *clientId;
    NSString *apiUrl;
} PhotoSearchParams;

@protocol TTUSQueryLoader <NSObject>
- (void)getPhotosQuery:(NSString *)query success:(void(^)(NSArray *))success failure:(void(^)(NSError *))failure;
@end

@protocol TTUSPageLoader <NSObject>
- (BOOL)loadNextCompletion:(void(^)(NSUInteger, NSArray *,NSError * _Nullable))completion;
@end

@interface TTUSPageLoaderService : NSObject<TTUSQueryLoader, TTUSPageLoader>
- (instancetype)initWith:(PhotoSearchParams)params;
- (void)getPhotosQuery:(NSString *)query success:(void(^)(NSArray *))success failure:(void(^)(NSError *))failure;
- (BOOL)loadNextCompletion:(void(^)(NSUInteger, NSArray *, NSError * _Nullable))completion;
@end

NS_ASSUME_NONNULL_END
