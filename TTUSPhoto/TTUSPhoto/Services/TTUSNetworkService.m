//
// Copyright © 2019 Alexander Rogachev. All rights reserved.
//

#import "TTUSNetworkService.h"

@implementation TTUSNetworkService
+ (void)makeRequest:(NSURLRequest *)request success:(void(^)(NSDictionary *))success failure:(void(^)(NSError *))failure {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            if (failure) {
                failure(error);
            }
        } else {
            NSError *error = nil;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            if (error) {
                if (failure) {
                    failure(error);
                }
            } else {
                if (success) {
                    success(json);
                }
            }
        }
    }];
    [dataTask resume];
}
@end
