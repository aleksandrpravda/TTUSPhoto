//
// Copyright © 2019 Alexander Rogachev. All rights reserved.
//

#import "AppDelegate.h"
#import "TTUSPhotoSearchService.h"
#import "TTUSSearchViewController.h"
#import "TTUSPhotoCollectionViewController.h"

@interface AppDelegate ()
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) TTUSPageLoaderService *pageLoaderService;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    PhotoSearchParams params;
    params.apiUrl = @"https://api.unsplash.com";
    params.perPage = 30;
    params.clientId = @"ee803fdfeeca8944ac3ff589fd73f22fa64c7c373760488c0796f2e292eb0271";
    params.orderedBy = @"latest";
    
    self.pageLoaderService = [[TTUSPageLoaderService alloc] initWith:params];
    TTUSSearchViewController *initialViewController = [[TTUSSearchViewController alloc] initWith:self.pageLoaderService];
    
    self.navigationController = [UINavigationController new];
//    self.navigationController.navigationBar.barTintColor = [UIColor darkGrayColor];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self.navigationController pushViewController:initialViewController animated:NO];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)presentPhotoCollectionController:(NSArray *)images {
    TTUSPhotoCollectionViewController *controller = [[TTUSPhotoCollectionViewController alloc]initWith:images
                                                                                            pageLoader:self.pageLoaderService];
    [self.navigationController pushViewController:controller animated:YES];
}

- (NSURLCache *)getURLCache {
    return [[NSURLCache alloc] initWithMemoryCapacity:[self megaBytes:50]
                                         diskCapacity:[self megaBytes:100]
                                             diskPath:@"TTUSPhoto.unsplashPhotos"];
}

- (NSInteger)megaBytes:(NSInteger)value {
    return value * 1024 * 1024;
}

@end
