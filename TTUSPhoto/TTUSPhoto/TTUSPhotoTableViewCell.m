//
// Copyright © 2019 Alexander Rogachev. All rights reserved.
//

#import "TTUSPhotoTableViewCell.h"
#import "TTUSImageDownloader.h"
#import "AppDelegate.h"
#import "Image.h"
#import "URLs.h"

@interface TTUSPhotoTableViewCell()
@property(nonatomic, strong) TTUSImageDownloader *imageLoader;
@property (strong, nonatomic) IBOutlet UIImageView *imageThumbView;
@property (strong, nonatomic) IBOutlet UIView *descriptionContainerView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, strong) NSLayoutConstraint *aspectConstrain;
@end

@implementation TTUSPhotoTableViewCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        self.imageLoader = [[TTUSImageDownloader alloc] initWithCahce:[appDelegate getURLCache]];
    }
    return self;
}

- (void)updateData:(Image *)image {
    [self loadImageWithUrl:image.urls.thumb];
    NSString *descr = image.descr;
    NSString *altDescr = image.altDescr;
    if (descr) {
        [self.descriptionLabel setText:descr];
        [self.descriptionContainerView setHidden:NO];
    } else if (altDescr) {
        [self.descriptionLabel setText:altDescr];
        [self.descriptionContainerView setHidden:NO];
    } else {
        [self.descriptionContainerView setHidden:YES];
    }
}

- (void)loadImageWithUrl:(NSString *)url {
    [self.imageLoader loadImageWith:url
                            success:^(NSData * data) {
                                UIImage *image = [UIImage imageWithData:data];
                                CGFloat aspect = image.size.width / image.size.height;
                                NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.imageThumbView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.imageThumbView attribute:NSLayoutAttributeHeight multiplier:aspect constant:0.0];
                                constraint.priority = 999;
                                if (self.aspectConstrain) {
                                    [NSLayoutConstraint deactivateConstraints:@[self.aspectConstrain]];
                                }
                                self.aspectConstrain = constraint;
                                [NSLayoutConstraint activateConstraints:@[self.aspectConstrain]];
                                self.imageThumbView.image = image;
                                [self.activityIndicator setHidden:YES];
                                [self.activityIndicator stopAnimating];
                            }
                            failure:^(NSError * error) {
                                self.imageThumbView.image = nil; //TODO add placeholder
                                [self.activityIndicator setHidden:YES];
                                [self.activityIndicator stopAnimating];
                                NSLog(@"TTUSPhotoTableViewCell::loadImageWithUrl %@", error);
                            }
     ];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.imageLoader cancel];
    if (self.aspectConstrain) {
        [NSLayoutConstraint deactivateConstraints:@[self.aspectConstrain]];
    }
    [self.imageThumbView setImage:nil];
    [self.descriptionLabel setText:nil];
    [self.descriptionContainerView setHidden:YES];
    [self.activityIndicator setHidden:NO];
    [self.activityIndicator startAnimating];
}
@end
