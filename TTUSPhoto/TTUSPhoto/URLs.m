//
// Copyright © 2019 Alexander Rogachev. All rights reserved.
//

#import "URLs.h"
@implementation URLs
- (instancetype)initWithJSON:(NSDictionary *)JSON {
    self = [super init];
    if (self) {
        self.full = [[JSON valueForKey:@"full"] stringValue];
        self.raw = [[JSON valueForKey:@"raw"] stringValue];
        self.regular = [[JSON valueForKey:@"regular"] stringValue];
        self.small = [[JSON valueForKey:@"small"] stringValue];
        self.thumb = [[JSON valueForKey:@"thumb"] stringValue];
    }
    return self;
}
@end
