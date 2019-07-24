//
// Copyright © 2019 Alexander Rogachev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "URLs.h"
NS_ASSUME_NONNULL_BEGIN

@interface Image : NSObject
@property(nonatomic, strong) NSString *identifire;
@property(nonatomic, strong) NSString *color;
@property(nonatomic, strong) URLs *urls;
@property(nonatomic) double width;
@property(nonatomic) double height;

- (instancetype)initWithJSON:(NSDictionary *)JSON;
@end

NS_ASSUME_NONNULL_END
