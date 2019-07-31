//
// Copyright © 2019 Alexander Rogachev. All rights reserved.
//

#import "AppDelegate.h"
#import "TTUSAppCoordinator.h"
@interface AppDelegate ()
@property (strong, nonatomic) TTUSAppCoordinator *appCoordinator;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.appCoordinator = [[TTUSAppCoordinator alloc] initWith:self.window];
    [self.appCoordinator start];
    return YES;
}

@end
