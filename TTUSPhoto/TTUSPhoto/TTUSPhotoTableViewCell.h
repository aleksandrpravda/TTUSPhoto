//
// Copyright © 2019 Alexander Rogachev. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTUSPhotoTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imageThumbView;
@property (strong, nonatomic) IBOutlet UIView *descriptionContainerView;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@end

NS_ASSUME_NONNULL_END
