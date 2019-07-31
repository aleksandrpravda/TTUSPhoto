//
// Copyright © 2019 Alexander Rogachev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTUSPhotoCollectionViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTUSPhotoCollectionViewController : UIViewController<TTUSPhotoCollectionViewModelDelegate>
@property (strong, nonatomic) TTUSPhotoCollectionViewModel *viewModel;
@end

NS_ASSUME_NONNULL_END
