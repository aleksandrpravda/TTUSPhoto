//
// Copyright © 2019 Alexander Rogachev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTUSPageLoaderService.h"
NS_ASSUME_NONNULL_BEGIN

@interface TTUSSearchViewController : UIViewController
- (instancetype)initWith:(id<TTUSQueryLoader>)queryLoader;
@end

NS_ASSUME_NONNULL_END
