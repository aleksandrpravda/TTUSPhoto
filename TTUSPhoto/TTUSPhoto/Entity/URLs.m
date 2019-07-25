//
// Copyright © 2019 Alexander Rogachev. All rights reserved.
//

#import "URLs.h"
#import "NSDictionary+TTUSValidDictionary.h"
@implementation URLs
- (instancetype)initWithJSON:(NSDictionary *)JSON {
    self = [super init];
    if (self) {
        self.full = [JSON validatedValueForKey:@"full"];
        self.raw = [JSON validatedValueForKey:@"raw"];
        self.regular = [JSON validatedValueForKey:@"regular"];
        self.small = [JSON validatedValueForKey:@"small"];
        self.thumb = [JSON validatedValueForKey:@"thumb"];
    }
    return self;
}
@end
