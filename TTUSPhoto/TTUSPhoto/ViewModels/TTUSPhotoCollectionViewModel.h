//
// Copyright © 2019 Alexander Rogachev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTUSApiService.h"
#import "TTUSImageloader.h"
@class Image;
NS_ASSUME_NONNULL_BEGIN

@interface PhotoViewData: NSObject
@property(copy, nonatomic) NSString *desc;
@property(strong, nonatomic) NSData *imageData;
@property(nonatomic) double width;
@property(nonatomic) double height;
@end

@protocol TTUSPhotoCollectionViewModelDelegate <NSObject>
- (void)onfetchCompleted:(NSArray *)indexpaths;
- (void)onfetchFailed:(NSString *)reason;
@end

@interface TTUSPhotoCollectionViewModel : NSObject
@property(readonly, nonatomic) BOOL hasNext;
@property(readonly, nonatomic) NSUInteger currentCount;
@property(weak, nonatomic) id<TTUSPhotoCollectionViewModelDelegate> delegate;
- (instancetype)initWith:(NSString *)query apiService:(id <TTUSApiService>)api imageLoader:(id<TTUSImageloader>)imageLoadr;
- (void)fetchPhotos;
- (PhotoViewData * _Nullable)dataFor:(NSIndexPath *)indexpath;
@end

NS_ASSUME_NONNULL_END
