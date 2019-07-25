//
// Copyright © 2019 Alexander Rogachev. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTUSErrorHandler : NSObject
+ (void)handleError:(NSError *)error inController:(UIViewController *)controller;
+ (void)handleMessage:(NSString *)message inController:(UIViewController *)controller handler:(void (^ __nullable)(UIAlertAction *action))handler;
@end

NS_ASSUME_NONNULL_END
