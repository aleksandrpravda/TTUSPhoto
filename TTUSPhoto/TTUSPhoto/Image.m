//
// Copyright © 2019 Alexander Rogachev. All rights reserved.
//

#import "Image.h"
@implementation Image
- (instancetype)initWithJSON:(NSDictionary *)JSON {
    self = [super init];
    if (self) {
        self.identifire = [[JSON valueForKey:@"id"] stringValue];
        self.color = [[JSON valueForKey:@"color"] stringValue];
        self.height = [[JSON valueForKey:@"height"] doubleValue];
        self.width = [[JSON valueForKey:@"width"] doubleValue];
        self.urls = [[URLs alloc] initWithJSON:[JSON valueForKey:@"urls"]];
    }
    return self;
}
@end
