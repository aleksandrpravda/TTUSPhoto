//
// Copyright © 2019 Alexander Rogachev. All rights reserved.
//

#import "TTUSPhotoSearchService.h"
@implementation TTUSPhotoSearchService
- (void)getPhotos:(NSURL *)url success:(void(^)(NSDictionary *))success failure:(void(^)(NSError *))failure {
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self makeRequest:request success:success failure:failure];
}

- (void)makeRequest:(NSURLRequest *)request success:(void(^)(NSDictionary *))success failure:(void(^)(NSError *))failure {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            if (failure) {
                failure(error);
            }
        } else {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if (success) {
                success(json);
            }
        }
    }];
    [dataTask resume];
}
@end
