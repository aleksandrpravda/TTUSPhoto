//
// Copyright © 2019 Alexander Rogachev. All rights reserved.
//

#import "TTUSPageLoaderService.h"
#import "Image.h"
#import "TTUSNetworkService.h"

@interface TTUSPageLoaderService()
@property(nonatomic, assign) PhotoSearchParams params;
@property(nonatomic, strong) NSString *query;
@property(nonatomic, assign) BOOL hasNext;
@property(nonatomic, assign) NSUInteger pageNumber;
@property(nonatomic, assign) BOOL isLoading;
@end

@implementation TTUSPageLoaderService
- (instancetype)initWith:(PhotoSearchParams) params {
    self = [super init];
    if (self) {
        self.params = params;
        self.hasNext = true;
    }
    return self;
}

- (void)getPhotosQuery:(NSString *)query completion:(void(^)(NSArray *, NSError * _Nullable))completion {
    NSMutableCharacterSet *allowedCharacterSet = [NSMutableCharacterSet alphanumericCharacterSet];
    [allowedCharacterSet addCharactersInString:@".-_"];
    self.query = [query stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
    self.pageNumber = 1;
    [self searchFotos:self.query pageNumber:self.pageNumber params:self.params success:^(NSArray *images) {
        if (completion) {
            completion(images, nil);
        }
    } failure:^(NSError *error) {
        if (completion) {
            completion(nil, error);
        }
    }];
}

- (BOOL)loadNextCompletion:(void(^)(NSUInteger, NSArray *, NSError * _Nullable))completion {
    if (self.hasNext && !self.isLoading) {
        self.pageNumber++;
        [self searchFotos:self.query pageNumber:self.pageNumber params:self.params success:^(NSArray *images) {
            if (completion) {
                completion(self.pageNumber, images, nil);
            }
        } failure:^(NSError *error) {
            if (completion) {
                completion(self.pageNumber, nil, error);
            }
        }];
    }
    return self.hasNext;
}

- (void)searchFotos:(NSString *)query pageNumber:(NSUInteger)page params:(PhotoSearchParams)params success:(void(^)(NSArray *))success failure:(void(^)(NSError *))failure {
    self.isLoading = true;
    NSString *stringURL = [NSString stringWithFormat:@"%@/search/photos?page=%lu&per_page=%ld&order_by=%@&client_id=%@&query=%@", params.apiUrl, (unsigned long)page, (long)params.perPage, params.orderedBy, params.clientId, query];
    NSURL *url = [NSURL URLWithString:stringURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [TTUSNetworkService makeRequest:request success:^(NSDictionary * JSON) {
        NSArray *results = [JSON valueForKey:@"results"];
        NSInteger itemsCount = results.count;
        self.hasNext = itemsCount == self.params.perPage;
        NSMutableArray *images = [NSMutableArray array];
        for (NSDictionary *imageJSON in results) {
           @autoreleasepool {
               [images addObject:[[Image alloc] initWithJSON:imageJSON]];
           }
        }
        if (success) {
           dispatch_async(dispatch_get_main_queue(), ^{
               self.isLoading = false;
               success(images);
           });
        }
    } failure:^(NSError * error) {
        if (failure) {
           dispatch_async(dispatch_get_main_queue(), ^{
               self.isLoading = false;
               failure(error);
           });
        }
    }];
}
@end
