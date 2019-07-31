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

@protocol TTUSApiService <NSObject>
@property(readonly, nonatomic) PhotoSearchParams params;
- (void)getPhotosQuery:(NSString *)query page:(NSInteger)page success:(void(^)(NSArray *))success failure:(void(^)(NSError *))failure;
@end

@interface TTUSApiServiceImpl : NSObject<TTUSApiService>
- (instancetype)initWith:(PhotoSearchParams)params;
@end

NS_ASSUME_NONNULL_END
