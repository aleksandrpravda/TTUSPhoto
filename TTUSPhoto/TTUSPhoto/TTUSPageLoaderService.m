//
// Copyright © 2019 Alexander Rogachev. All rights reserved.
//

#import "TTUSPageLoaderService.h"
#import "TTUSPhotoSearchService.h"
#import "Image.h"

@interface TTUSPageLoaderService()
@property(nonatomic, assign) PhotoSearchParams params;
@property(nonatomic, strong) TTUSPhotoSearchService *photoSearchService;
@property(nonatomic, strong) NSString *query;
@property(nonatomic, assign) BOOL hasNext;
@property(nonatomic, assign) NSUInteger pageNumber;
@end

@implementation TTUSPageLoaderService
- (instancetype)initWith:(PhotoSearchParams) params {
    self = [super init];
    if (self) {
        self.params = params;
        self.pageNumber = 0;
        self.hasNext = true;
        self.query = @"";
    }
    return self;
}

- (void)getPhotosQuery:(NSString *)query success:(void(^)(NSArray *))success failure:(void(^)(NSError *))failure {
    self.query = query;
    NSString *stringURL = [NSString stringWithFormat:@"%@/search/photos?page=%lu&per_page=%ld&order_by=%@&client_id=%@&query=%@", self.params.apiUrl, (unsigned long)self.pageNumber, (long)self.params.perPage, self.params.orderedBy, self.params.clientId, self.query];
    [self.photoSearchService getPhotos:[NSURL URLWithString:stringURL]
                               success:^(NSDictionary * JSON) {
                                   NSArray *results = [JSON valueForKey:@"results"];
                                   NSInteger itemsCount = results.count;
                                   self.hasNext = itemsCount == self.params.perPage;
                                   NSMutableArray *images = [NSMutableArray array];
                                   for (NSDictionary *imageJSON in results) {
                                       [images addObject:[[Image alloc] initWithJSON:imageJSON]];
                                   }
                               }
                               failure:failure
     ];
}

- (BOOL)loadNextCompletion:(void(^)(NSUInteger, NSArray *, NSError * _Nullable))completion {
    if (self.hasNext) {
        self.pageNumber++;
        [self getPhotosQuery:self.query success:^(NSArray *images) {
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
@end
