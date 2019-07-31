//
// Copyright © 2019 Alexander Rogachev. All rights reserved.
//

#import "TTUSPhotoTableViewCell.h"
#import "Image.h"
#import "URLs.h"
#import "TTUSPhotoCollectionViewModel.h"

@interface TTUSPhotoTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageThumbView;
@property (weak, nonatomic) IBOutlet UIView *descriptionContainerView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) NSLayoutConstraint *aspectConstrain;
@property (strong, nonatomic) PhotoViewData *viewData;
@end

@implementation TTUSPhotoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)updateData:(PhotoViewData * _Nullable)viewData {
    self.viewData = viewData;
    if (viewData.imageData) {
        [self.activityIndicator setHidden:YES];
        [self.activityIndicator stopAnimating];
    }
    CGFloat aspect = viewData.width / viewData.height;
    [self addAspectConstraint:aspect];
    if (viewData.desc) {
        [self.descriptionLabel setText:viewData.desc];
        [self.descriptionContainerView setHidden:NO];
    } else {
        [self.descriptionContainerView setHidden:YES];
    }
    [self.imageThumbView setImage:[UIImage imageWithData:viewData.imageData]];
    [self.viewData addObserver:self
                    forKeyPath:@"imageData"
                       options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                       context:@"cellContext"
     ];
}

- (void)removeObserver {
    [self.viewData removeObserver:self forKeyPath:@"imageData" context:@"cellContext"];
    self.viewData = nil;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self removeObserver];
    [self.imageThumbView setImage:nil];
    if (self.aspectConstrain) {
        [self.imageThumbView removeConstraint:self.aspectConstrain];
    }
    self.aspectConstrain = nil;
    [self.descriptionLabel setText:nil];
    [self.descriptionContainerView setHidden:YES];
    [self.activityIndicator setHidden:NO];
    [self.activityIndicator startAnimating];
}

- (void)addAspectConstraint:(float)aspect {
    if (self.aspectConstrain) {
        [NSLayoutConstraint deactivateConstraints:@[self.aspectConstrain]];
        self.aspectConstrain = nil;
    }
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.imageThumbView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.imageThumbView attribute:NSLayoutAttributeHeight multiplier:aspect constant:0.0];
    constraint.priority = 999;
    self.aspectConstrain = constraint;
    [NSLayoutConstraint activateConstraints:@[self.aspectConstrain]];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"imageData"]) {
        [self.activityIndicator setHidden:YES];
        [self.activityIndicator stopAnimating];
        [self.imageThumbView setImage:[UIImage imageWithData:((PhotoViewData *)object).imageData]];
    }
}
@end
