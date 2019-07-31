//
// Copyright © 2019 Alexander Rogachev. All rights reserved.
//

#import "TTUSApiService.h"
#import "Image.h"
//#import "TTUSNetworkService.h"

@interface TTUSApiServiceImpl()
@property(assign, nonatomic) PhotoSearchParams params;
@end

@implementation TTUSApiServiceImpl
- (instancetype)initWith:(PhotoSearchParams) params {
    self = [super init];
    if (self) {
        self.params = params;
    }
    return self;
}

- (void)getPhotosQuery:(NSString *)query page:(NSInteger)page success:(void(^)(NSArray *))success failure:(void(^)(NSError *))failure {
    NSMutableCharacterSet *allowedCharacterSet = [NSMutableCharacterSet alphanumericCharacterSet];
    [allowedCharacterSet addCharactersInString:@".-_"];
    NSString *searchQuesy = [query stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
    NSString *stringURL = [NSString stringWithFormat:@"%@/search/photos?page=%lu&per_page=%ld&order_by=%@&client_id=%@&query=%@", self.params.apiUrl, (unsigned long)page, (long)self.params.perPage, self.params.orderedBy, self.params.clientId, searchQuesy];
    NSURL *url = [NSURL URLWithString:stringURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self makeRequest:request success:^(NSDictionary * JSON) {
        NSArray *results = [JSON valueForKey:@"results"];
        NSMutableArray *images = [NSMutableArray array];
        for (NSDictionary *imageJSON in results) {
            @autoreleasepool {
                [images addObject:[[Image alloc] initWithJSON:imageJSON]];
            }
        }
        if (success) {
            success(images);
        }
    } failure:^(NSError * error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)makeRequest:(NSURLRequest *)request success:(void(^)(NSDictionary *))success failure:(void(^)(NSError *))failure {
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
