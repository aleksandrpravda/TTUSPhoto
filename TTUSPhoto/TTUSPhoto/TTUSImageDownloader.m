//
// Copyright © 2019 Alexander Rogachev. All rights reserved.
//

#import "TTUSImageDownloader.h"

@interface TTUSImageDownloader()
@property(atomic, strong) NSURLCache *cache;
@property(atomic, strong) NSURLSessionDataTask* dataTask;
@end

@implementation TTUSImageDownloader

- (instancetype)initWithCahce:(NSURLCache *)cache {
    self = [super init];
    if (self) {
        self.cache = cache;
    }
    return self;
}
- (void)loadImageWith:(NSString *)stringURL success:(void(^)(NSData *))success failure:(void(^)(NSError *))failure {
    NSURL *url = [NSURL URLWithString:stringURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSCachedURLResponse *cachedResponse = [self.cache cachedResponseForRequest:request];
    if (cachedResponse) {
        NSLog(@"Data loaded from cache");
        NSData *data = cachedResponse.data;
        success(data);
        return;
    }
    
    __block NSURLRequest *blockRequest = request;
    __weak TTUSImageDownloader *weakSelf = self;
    
    self.dataTask = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        __strong TTUSImageDownloader *strongSelf = weakSelf;
        strongSelf.dataTask = nil;
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(error);
            });
        } else {
            if (response && data) {
                NSCachedURLResponse *cachedResponse = [[NSCachedURLResponse alloc] initWithResponse:response data:data];
                [strongSelf.cache storeCachedResponse:cachedResponse forRequest:blockRequest];
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"Data loaded from URL %@", response.URL.absoluteString);
                    success(data);
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    failure(nil);
                });
            }
        }
    }];
    [self.dataTask resume];
}

- (void)cancel {
    [self.dataTask cancel];
}

@end
