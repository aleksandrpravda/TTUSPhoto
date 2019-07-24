//
// Copyright © 2019 Alexander Rogachev. All rights reserved.
//

#import "TTUSSearchViewController.h"

@interface TTUSSearchViewController ()
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UIButton *goBtn;
@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
@property(nonatomic, weak) id<TTUSQueryLoader> queryLoader;
@end

@implementation TTUSSearchViewController

- (instancetype)initWith:(id<TTUSQueryLoader>)queryLoader {
    self = [super initWithNibName:NSStringFromClass(self.class) bundle:nil];
    if (self) {
        self.queryLoader = queryLoader;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (IBAction)onGoBtn:(id)sender {
    [self.queryLoader getPhotosQuery:self.searchTextField.text success:^(NSArray *images) {
        
    } failure:^(NSError * error) {
        //TODO add fail
    }];
}

@end
