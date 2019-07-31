//
// Copyright © 2019 Alexander Rogachev. All rights reserved.
//

#import "TTUSAppCoordinator.h"
#import "TTUSImageloader.h"
#import "TTUSSearchViewController.h"
#import "TTUSSearchViewModel.h"
#import "TTUSPhotoCollectionViewModel.h"
#import "TTUSPhotoCollectionViewController.h"
#import "TTUSApiService.h"

@interface TTUSAppCoordinator() <TTUSAppCoordinatorDelegate>
@property(strong, nonatomic) UIWindow *window;
@property(strong, readonly) UINavigationController *rootViewController;
@property(strong, readonly) TTUSSearchViewModel *searchViewModel;
@property(strong, readonly) TTUSImageloaderImpl *imageLoader;
@property(strong, readonly) TTUSApiServiceImpl *apiService;
@end

@implementation TTUSAppCoordinator
- (instancetype)initWith:(UIWindow *)window {
    self = [super init];
    if (self) {
        self.window = window;
    }
    return self;
}

- (void)start {
    if (!self.window) {
        return;
    }
    [self.window setRootViewController:self.rootViewController];
    [self.window makeKeyAndVisible];
    TTUSSearchViewController *viewController = [[TTUSSearchViewController alloc] init];
    viewController.viewModel = self.searchViewModel;
    [self.rootViewController pushViewController:viewController animated:false];
}

- (void)finish {}

- (NSURLCache *)getURLCache {
    return [[NSURLCache alloc] initWithMemoryCapacity:[self megaBytes:50]
                                         diskCapacity:[self megaBytes:100]
                                             diskPath:@"TTUSPhoto.unsplashPhotos"];
}

- (NSInteger)megaBytes:(NSInteger)value {
    return value * 1024 * 1024;
}

@synthesize searchViewModel = _searchViewModel;

- (TTUSSearchViewModel *)searchViewModel {
    @synchronized (self) {
        if (_searchViewModel == nil) {
            _searchViewModel = [[TTUSSearchViewModel alloc] init];
            _searchViewModel.coordinatorDelegate = self;
        }
    }
    return _searchViewModel;
}
#pragma mark - App Coordinator Delegate

- (void)goToCollection:(NSString *)query {
    TTUSPhotoCollectionViewModel *viewModel = [[TTUSPhotoCollectionViewModel alloc] initWith:query apiService:self.apiService imageLoader:self.imageLoader];
    TTUSPhotoCollectionViewController *viewController = [[TTUSPhotoCollectionViewController alloc] initWithNibName:NSStringFromClass([TTUSPhotoCollectionViewController class]) bundle:nil];
    viewController.viewModel = viewModel;
    [self.rootViewController pushViewController:viewController animated:YES];
}

#pragma mark - API Service

@synthesize apiService = _apiService;

- (TTUSApiServiceImpl *)apiService {
    @synchronized (self) {
        if (_apiService == nil) {
            PhotoSearchParams params;
            params.apiUrl = @"https://api.unsplash.com";
            params.perPage = 30;
            params.clientId = @"ee803fdfeeca8944ac3ff589fd73f22fa64c7c373760488c0796f2e292eb0271";
            params.orderedBy = @"latest";
            _apiService = [[TTUSApiServiceImpl alloc] initWith:params];
        }
    }
    return _apiService;
}

#pragma mark - Image Loader

@synthesize imageLoader = _imageLoader;

- (TTUSImageloaderImpl *)imageLoader {
    @synchronized (self) {
        if (_imageLoader == nil) {
            _imageLoader = [[TTUSImageloaderImpl alloc] initWithCahce:[self getURLCache]];
        }
    }
    return _imageLoader;
}

#pragma mark - Root View Controller

@synthesize rootViewController = _rootViewController;

- (UINavigationController *)rootViewController {
    @synchronized (self) {
        if (_rootViewController == nil) {
            _rootViewController = [[UINavigationController alloc] init];
        }
    }
    return _rootViewController;
}
@end
