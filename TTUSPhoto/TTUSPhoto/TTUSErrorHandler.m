//
// Copyright © 2019 Alexander Rogachev. All rights reserved.
//

#import "TTUSErrorHandler.h"

@implementation TTUSErrorHandler
+ (void)handleError:(NSError *)error inController:(UIViewController *)controller{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Error!"
                                 message:error.userInfo.description
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okButton = [UIAlertAction
                                actionWithTitle:@"Ok"
                                style:UIAlertActionStyleDefault
                                handler:nil];
    [alert addAction:okButton];
    [controller presentViewController:alert animated:YES completion:nil];
}

+ (void)handleMessage:(NSString *)message inController:(id)controller handler:(void (^ __nullable)(UIAlertAction *action))handler {
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Message!"
                                 message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"Ok"
                               style:UIAlertActionStyleDefault
                               handler:handler];
    [alert addAction:okButton];
    [controller presentViewController:alert animated:YES completion:nil];
}
@end
