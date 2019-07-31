//
// Copyright © 2019 Alexander Rogachev. All rights reserved.
//

#import "TTUSSearchViewModel.h"

@implementation TTUSSearchViewModel
- (void)search:(NSString *)query {
    if ([self.delegate respondsToSelector:@selector(clearText)]) {
        [self.delegate clearText];
    }
    if ([self.coordinatorDelegate respondsToSelector:@selector(goToCollection:)]) {
        [self.coordinatorDelegate goToCollection:query];
    }
}
@end
