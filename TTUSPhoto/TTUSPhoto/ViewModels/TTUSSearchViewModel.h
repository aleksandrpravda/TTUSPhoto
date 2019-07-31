//
// Copyright © 2019 Alexander Rogachev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTUSAppCoordinator.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TTUSSearchViewModelDelegate <NSObject>
- (void)clearText;
@end

@interface TTUSSearchViewModel : NSObject
@property(weak, nonatomic) id<TTUSAppCoordinatorDelegate> coordinatorDelegate;
@property(weak, nonatomic) id<TTUSSearchViewModelDelegate> delegate;
- (void)search:(NSString *)query;
@end

NS_ASSUME_NONNULL_END
