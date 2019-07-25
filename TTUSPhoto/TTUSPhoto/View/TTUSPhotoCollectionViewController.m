//
// Copyright © 2019 Alexander Rogachev. All rights reserved.
//

#import "TTUSPhotoCollectionViewController.h"
#import "TTUSPhotoTableViewCell.h"
#import "TTUSErrorHandler.h"

@interface TTUSPhotoCollectionViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, weak) id<TTUSPageLoader> pageLoader;
@property(nonatomic, strong) NSMutableDictionary *pages;
@end

@implementation TTUSPhotoCollectionViewController

- (instancetype)initWith:(NSArray *)images pageLoader:(id<TTUSPageLoader>)pageLoader {
    self = [super initWithNibName:NSStringFromClass(self.class) bundle:nil];
    if (self) {
        self.pageLoader = pageLoader;
        self.pages = [NSMutableDictionary new];
        self.pages[@(1)] = images;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:self.pageLoader.query];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(TTUSPhotoTableViewCell.class)
                                               bundle:nil]
         forCellReuseIdentifier:NSStringFromClass(TTUSPhotoTableViewCell.class)];
    NSArray *images = self.pages[@(1)];
    [self update:images page:1];
}

- (BOOL)loadNext {
    return [self.pageLoader loadNextCompletion:^(NSUInteger page, NSArray* images, NSError *error) {
        if (error) {
            [TTUSErrorHandler handleError:error inController:self];
        } else if (images) {
            self.pages[@(page)] = images;
            [self update:images page:page];
        }
    }];
}

- (void)update:(NSArray *)images page:(NSInteger)page {
    NSMutableArray *indexpaths = [NSMutableArray new];
    for (NSUInteger i = 0; i < images.count; ++i) {
        [indexpaths addObject:[NSIndexPath indexPathForRow:i inSection:page - 1]];
    }
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:page - 1]] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView setContentOffset:self.tableView.contentOffset animated:NO];
    [self.tableView insertRowsAtIndexPaths:indexpaths withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView insertSections:[NSIndexSet indexSetWithIndex:page] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:page]] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSInteger count = self.pages.count;
    if (indexPath.section >= count) {
        if ([self loadNext]) {
            return [self activityCell];
        } else {
            return nil;
        }
    }
    TTUSPhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(TTUSPhotoTableViewCell.class) forIndexPath:indexPath];
    NSArray *images = self.pages[@(indexPath.section + 1)];
    [cell updateData:images[indexPath.row]];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger count = self.pages.count;
    if (count > 0) {
        return count + 1;
    }
    return 0;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = self.pages.count;
    if (count > 0) {
        if (section >= count) {
            return 1;
        }
        NSArray *images = self.pages[@(section + 1)];
        return images.count;
    }
    return 0;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSInteger count = self.pages.count;
    if (count > 0) {
        if (section < count) {
            return [NSString stringWithFormat:@"Page %ld", (section + 1)];
        }
    }
    return nil;
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
@end
