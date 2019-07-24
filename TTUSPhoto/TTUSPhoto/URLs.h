//
// Copyright © 2019 Alexander Rogachev. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface URLs : NSObject
@property(nonatomic, strong) NSString *raw;
@property(nonatomic, strong) NSString *full;
@property(nonatomic, strong) NSString *regular;
@property(nonatomic, strong) NSString *small;
@property(nonatomic, strong) NSString *thumb;

- (instancetype)initWithJSON:(NSDictionary *)JSON;
@end

NS_ASSUME_NONNULL_END
