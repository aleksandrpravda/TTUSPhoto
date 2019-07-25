//
// Copyright © 2019 Alexander Rogachev. All rights reserved.
//

#import "Image.h"
#import "NSDictionary+TTUSValidDictionary.h"
@implementation Image
- (instancetype)initWithJSON:(NSDictionary *)JSON {
    self = [super init];
    if (self) {
        self.identifire = [JSON validatedValueForKey:@"id"];
        self.color = [JSON validatedValueForKey:@"color"];
        self.height = [[JSON validatedValueForKey:@"height"] doubleValue];
        self.width = [[JSON validatedValueForKey:@"width"] doubleValue];
        self.descr = [JSON validatedValueForKey:@"description"];
        self.altDescr = [JSON validatedValueForKey:@"alt_description"];
        self.urls = [[URLs alloc] initWithJSON:[JSON validatedValueForKey:@"urls"]];
    }
    return self;
}
@end
