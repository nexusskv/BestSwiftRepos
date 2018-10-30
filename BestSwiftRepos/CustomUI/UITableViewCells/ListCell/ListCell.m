//
//  ListCell.m
//  BestSwiftRepos
//
//  Created by Rost on 10/17/18.
//  Copyright © 2018 Rost Gress. All rights reserved.
//

#import "ListCell.h"
#import "UIImageView+AFNetworking.h"
#import "Owner.h"
#import "ApiConnector.h"


@interface ListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *repoTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ownerTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailsLabel;
@end


@implementation ListCell

#pragma mark - setCellData:
- (void)setCellData:(Repository *)object {

    NSString *logoUrl = object.ownerRelation.logoUrl;
    if ((logoUrl) && (![logoUrl isEqual:[NSNull null]])) {
        logoUrl = [[ApiConnector shared] appendAuthToLink:logoUrl];
        
        __weak UIImageView *weakImageView = self.logoImageView;
        
        NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:logoUrl]];
        
        [weakImageView setImageWithURLRequest:imageRequest
                             placeholderImage:[UIImage imageNamed:@"noImagePlaceholder"]
                                      success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
          UIImageView *strongImageView = weakImageView;
          if (!strongImageView) return;
          
          [UIView transitionWithView:strongImageView
                            duration:0.3
                             options:UIViewAnimationOptionTransitionCrossDissolve
                          animations:^{
                              strongImageView.image = image;
                          }
                          completion:NULL];
                                      } failure:NULL];
    }
    
    NSString *repoTitle = object.repoTitle;
    if (repoTitle) {
        self.repoTitleLabel.text = repoTitle;
    }
    
    NSString *ownerTitle = object.ownerRelation.ownerTitle;
    if (ownerTitle) {
        self.ownerTitleLabel.text = ownerTitle;
    }
    
    NSString *repoDetails = object.repoDetails;
    if (repoDetails) {
        self.detailsLabel.text = repoDetails;
    }
}
#pragma mark - 

@end
