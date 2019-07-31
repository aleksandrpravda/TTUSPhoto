//
// Copyright © 2019 Alexander Rogachev. All rights reserved.
//

#import "TTUSSearchViewController.h"
#import "TTUSErrorHandler.h"

@interface TTUSSearchViewController ()<TTUSSearchViewModelDelegate>
@property (weak, nonatomic) IBOutlet UIButton *goBtn;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@end

@implementation TTUSSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewModel.delegate = self;
    [self.goBtn setEnabled:NO];
    [self.searchTextField addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
}

- (IBAction)onGoBtn:(id)sender {
    [self.goBtn setEnabled:NO];
    [self.viewModel search:self.searchTextField.text];
}

- (void)textFieldDidChange:(UITextView *)textView {
    [self.goBtn setEnabled:textView.text.length >= 3];
}

#pragma mark - View Model delegate

- (void)clearText {
    [self.searchTextField setText:@""];
}

@end
