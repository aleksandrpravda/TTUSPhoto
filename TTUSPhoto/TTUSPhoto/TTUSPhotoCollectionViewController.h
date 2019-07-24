//
// Copyright © 2019 Alexander Rogachev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTUSPageLoaderService.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTUSPhotoCollectionViewController : UIViewController
- (instancetype)initWith:(NSArray *)images pageLoader:(id<TTUSPageLoader>)pageLoader;
@end

NS_ASSUME_NONNULL_END
