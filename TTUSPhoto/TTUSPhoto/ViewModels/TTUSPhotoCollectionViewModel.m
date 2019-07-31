//
// Copyright © 2019 Alexander Rogachev. All rights reserved.
//

#import "TTUSPhotoCollectionViewModel.h"
#import <UIKit/UIKit.h>
#import "Image.h"
#import "URLs.h"

@implementation PhotoViewData
@end

@interface TTUSPhotoCollectionViewModel()
@property(weak, nonatomic) id<TTUSApiService> apiService;
@property(weak, nonatomic) id<TTUSImageloader> imageLoader;
@property(strong, nonatomic) NSMutableArray *images;
@property(strong, nonatomic) NSMutableArray *viewDatas;
@property(copy, nonatomic) NSString *query;
@property(nonatomic) BOOL isLoading;
@property(nonatomic) NSUInteger page;
@property(nonatomic) BOOL hasNext;
@end

@implementation TTUSPhotoCollectionViewModel
- (instancetype)initWith:(NSString *)query apiService:(id <TTUSApiService>)api imageLoader:(id<TTUSImageloader>)imageLoadr {
    self = [super init];
    if (self) {
        self.imageLoader = imageLoadr;
        self.apiService = api;
        self.page = 1;
        self.hasNext = YES;
        self.images = [NSMutableArray new];
        self.viewDatas = [NSMutableArray new];
        self.query = query;
    }
    return self;
}

@synthesize currentCount = _currentCount;
- (NSUInteger)currentCount {
    @synchronized (self) {
        _currentCount = self.images.count;
    }
    return _currentCount;
}

- (PhotoViewData * _Nullable)dataFor:(NSIndexPath *)indexpath {
    Image *image = [self.images objectAtIndex:indexpath.row];
    PhotoViewData *photoData = [self.viewDatas objectAtIndex:indexpath.row];
    if (!photoData.imageData) {
        [self.imageLoader loadImageWith:image.urls.thumb success:^(NSData *data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [photoData setImageData:data];
            });
        } failure:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //            [photoData setImageData:data]; ADD palceholder
            });
        }];
    }
    return photoData;
}

- (void)fetchPhotos {
    if (self.isLoading) {
        return;
    }
    self.isLoading = YES;
    [self.apiService getPhotosQuery:self.query
                               page:self.page
                            success:^(NSArray *result) {
                                if (result.count > 0) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        self.isLoading = false;
                                        self.page += 1;
                                        self.hasNext = self.apiService.params.perPage == result.count;
                                        for (Image *image in result) {
                                            [self.viewDatas addObject:[self fromImage:image]];
                                        }
                                        [self.images addObjectsFromArray:result];
                                        if ([self.delegate respondsToSelector:@selector(onfetchCompleted:)]) {
                                            [self.delegate onfetchCompleted:[self calculateIndexPathsToReload:result]];
                                        }
                                    });
                                } else {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        self.isLoading = false;
                                        self.hasNext = false;
                                        if ([self.delegate respondsToSelector:@selector(onfetchFailed:)]) {
                                            [self.delegate onfetchFailed:[NSString stringWithFormat:@"No data available for search text '%@'", self.query]];
                                        }
                                    });
                                }
                            }
                            failure:^(NSError *error) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    self.isLoading = false;
                                    if ([self.delegate respondsToSelector:@selector(onfetchFailed:)]) {
                                        [self.delegate onfetchFailed:error.userInfo.description];
                                    }
                                });
                            }
     ];
}

- (NSArray *)calculateIndexPathsToReload:(NSArray *)response {
    NSUInteger startIndex = self.images.count - response.count;
    NSUInteger endIndex = startIndex + response.count;
    NSMutableArray *indexPaths = [NSMutableArray new];
    for (NSUInteger index = startIndex; index < endIndex; ++index) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:index inSection:0]];
    }
    return indexPaths;
}

- (PhotoViewData *)fromImage:(Image *)image {
    PhotoViewData *viewData = [[PhotoViewData alloc] init];
    NSString *descr = image.descr;
    NSString *altDescr = image.altDescr;
    if (descr) {
        viewData.desc = descr;
    } else if (altDescr) {
        viewData.desc = altDescr;
    }
    viewData.imageData = [self.imageLoader getCachedImageData:image.urls.thumb];
    viewData.width = image.width;
    viewData.height = image.height;
    return viewData;
}
@end
