//
// Copyright © 2019 Alexander Rogachev. All rights reserved.
//

#import "TTUSPhotoTableViewCell.h"
#import "TTUSImageDownloader.h"
#import "AppDelegate.h"

@interface TTUSPhotoTableViewCell()
@property(nonatomic, strong) TTUSImageDownloader *imageLoader;
@end

@implementation TTUSPhotoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        self.imageLoader = [[TTUSImageDownloader alloc] initWithCahce:[appDelegate getURLCache]];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)loadImageWithUrl:(NSString *)url {
    __weak TTUSPhotoTableViewCell *weakSelf = self;
    [self.imageLoader loadImageWith:url
                            success:^(NSData * data) {
                                __strong TTUSPhotoTableViewCell *strongSelf = weakSelf;
                                strongSelf.imageThumbView.image = [UIImage imageWithData:data];
                            }
                            failure:^(NSError * error) {
                                __strong TTUSPhotoTableViewCell *strongSelf = weakSelf;
                                strongSelf.imageThumbView.image = nil; //TODO add placeholder
                                NSLog(@"TTUSPhotoTableViewCell::loadImageWithUrl %@", error);
                            }
     ];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.imageThumbView setImage:nil];
    [self.descriptionLabel setText:nil];
    [self.descriptionContainerView setAlpha:0.0f];
    [self.imageLoader cancel];
}

@end
