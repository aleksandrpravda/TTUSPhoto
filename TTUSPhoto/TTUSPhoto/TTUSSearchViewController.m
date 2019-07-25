//
// Copyright © 2019 Alexander Rogachev. All rights reserved.
//

#import "TTUSSearchViewController.h"
#import "AppDelegate.h"
#import "TTUSErrorHandler.h"

@interface TTUSSearchViewController ()
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UIButton *goBtn;
@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) id<TTUSQueryLoader> queryLoader;
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
    [self.goBtn setEnabled:NO];
    [self.searchTextField addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
    [self.activityIndicator setHidden:YES];
    [self.activityIndicator stopAnimating];
}

- (IBAction)onGoBtn:(id)sender {
    [self.goBtn setEnabled:NO];
    [self.activityIndicator setHidden:NO];
    [self.activityIndicator startAnimating];
    [self.queryLoader getPhotosQuery:self.searchTextField.text completion:^(NSArray * images, NSError *error) {
        [self.activityIndicator setHidden:YES];
        [self.activityIndicator stopAnimating];
        if (error) {
            [TTUSErrorHandler handleError:error inController:self];
            self.searchTextField.text = @"";
        } else if (images.count == 0) {
            [TTUSErrorHandler handleMessage:[NSString stringWithFormat:@"There is no data for request \"%@\"", self.searchTextField.text] inController:self handler:nil];
            self.searchTextField.text = @"";
        } else {
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate presentPhotoCollectionController:images];
            [self.goBtn setEnabled:YES];
        }
    }];
}

- (void)textFieldDidChange:(UITextView *)textView {
    [self.goBtn setEnabled:textView.text.length >= 3];
}

@end
