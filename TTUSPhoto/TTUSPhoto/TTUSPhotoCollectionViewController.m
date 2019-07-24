//
// Copyright © 2019 Alexander Rogachev. All rights reserved.
//

#import "TTUSPhotoCollectionViewController.h"

@interface TTUSPhotoCollectionViewController ()
@property(nonatomic, weak) id<TTUSPageLoader> pageLoader;
@property(nonatomic, strong) NSMutableDictionary *pages;
@end

@implementation TTUSPhotoCollectionViewController

- (instancetype)initWith:(NSArray *)images pageLoader:(id<TTUSPageLoader>)pageLoader {
    self = [super initWithNibName:NSStringFromClass(self.class) bundle:nil];
    if (self) {
        self.pageLoader = pageLoader;
        self.pages[[NSString stringWithFormat:@"%lu", (unsigned long)1]] = images;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)loadNext {
    [self.pageLoader loadNextCompletion:^(NSUInteger page, NSArray* images, NSError *error) {
        if (error) {
            NSLog(@"Error %@", error);
            //TODO add error
        } else if (images) {
            self.pages[[NSString stringWithFormat:@"%lu", (unsigned long)page]] = images;
        }
    }];
}

@end
