//
// Copyright © 2019 Alexander Rogachev. All rights reserved.
//

#import "TTUSPhotoCollectionViewController.h"
#import "TTUSPhotoTableViewCell.h"
#import "TTUSErrorHandler.h"

@interface TTUSPhotoCollectionViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation TTUSPhotoCollectionViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(TTUSPhotoTableViewCell.class)
                                               bundle:nil]
         forCellReuseIdentifier:NSStringFromClass(TTUSPhotoTableViewCell.class)];
    self.viewModel.delegate = self;
    [self.viewModel fetchPhotos];
}

- (void)viewDidDisappear:(BOOL)animated {
    for(UITableViewCell *cell in self.tableView.visibleCells) {
        if ([cell isKindOfClass:[TTUSPhotoTableViewCell class]]) {
            [((TTUSPhotoTableViewCell *)cell) removeObserver];
        }
    }
    [super viewDidDisappear:animated];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if ((self.viewModel.currentCount == 0 || indexPath.section == 1) && self.viewModel.hasNext) {
        [self.viewModel fetchPhotos];
        return [self activityCell];
    }
    TTUSPhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(TTUSPhotoTableViewCell.class) forIndexPath:indexPath];
    [cell updateData:[self.viewModel dataFor:indexPath]];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.viewModel.currentCount > 0) {
        if (self.viewModel.hasNext) {
            return 2;
        }
        return 1;
    }
    if (self.viewModel.hasNext) {
        return 1;
    }
    return 0;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return 1;
    }
    if (self.viewModel.currentCount > 0) {
        return self.viewModel.currentCount;
    }
    if (self.viewModel.hasNext) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)activityCell {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 100)];
    cell.backgroundColor = [UIColor grayColor];
    UIActivityIndicatorView *iView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    iView.hidesWhenStopped = YES;
    iView.translatesAutoresizingMaskIntoConstraints = NO;
    [iView startAnimating];
    [cell addSubview:iView];
    NSLayoutConstraint *horizontalConstraint = [NSLayoutConstraint constraintWithItem:iView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *verticalConstraint = [NSLayoutConstraint constraintWithItem:iView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    [NSLayoutConstraint activateConstraints:@[horizontalConstraint, verticalConstraint]];
    return cell;
}

#pragma - mark View Model Delegate

- (void)onfetchCompleted:(NSArray *)indexpaths {
    if (@available(iOS 11.0, *)) {
        [self.tableView performBatchUpdates:^{
            if (self.tableView.numberOfSections == 1) {
                [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                if (self.viewModel.hasNext) {
                    [self.tableView insertSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
                }
            }
            [self.tableView insertRowsAtIndexPaths:indexpaths withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView setContentOffset:self.tableView.contentOffset animated:NO];
        } completion:nil];
    } else {
        [self.tableView beginUpdates];
        if (self.tableView.numberOfSections == 1 && self.viewModel.hasNext) {
            [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        }
        [self.tableView insertRowsAtIndexPaths:indexpaths withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView setContentOffset:self.tableView.contentOffset animated:NO];
        [self.tableView endUpdates];
    }
    if (!self.viewModel.hasNext) {
        [self.tableView reloadData];
    }
}

- (void)onfetchFailed:(NSString *)reason {
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@""
                                 message:reason
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"Ok"
                               style:UIAlertActionStyleDefault
                               handler:nil];
    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];
    [self.tableView reloadData];
}
@end
