//
// Copyright © 2019 Alexander Rogachev. All rights reserved.
//

#import "Coordinator.h"
@class UIWindow;
NS_ASSUME_NONNULL_BEGIN

@protocol TTUSAppCoordinatorDelegate <NSObject>
- (void)goToCollection:(NSString *)query;
@end

@interface TTUSAppCoordinator : Coordinator
- (instancetype)initWith:(UIWindow *)window;
@end

NS_ASSUME_NONNULL_END
