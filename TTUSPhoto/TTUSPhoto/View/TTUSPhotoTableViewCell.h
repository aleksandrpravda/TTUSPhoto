//
// Copyright © 2019 Alexander Rogachev. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PhotoViewData;
NS_ASSUME_NONNULL_BEGIN

@interface TTUSPhotoTableViewCell : UITableViewCell
- (void)updateData:(PhotoViewData * _Nullable)viewData;
- (void)removeObserver;
@end

NS_ASSUME_NONNULL_END
