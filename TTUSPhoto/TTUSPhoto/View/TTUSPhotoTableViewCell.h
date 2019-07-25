//
// Copyright © 2019 Alexander Rogachev. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Image;
NS_ASSUME_NONNULL_BEGIN

@interface TTUSPhotoTableViewCell : UITableViewCell
- (void)updateData:(Image *)image;
@end

NS_ASSUME_NONNULL_END
