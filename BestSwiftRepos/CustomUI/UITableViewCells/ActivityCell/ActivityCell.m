//
//  ActivityCell.m
//  BestSwiftRepos
//
//  Created by Rost on 10/17/18.
//  Copyright © 2018 Rost Gress. All rights reserved.
//

#import "ActivityCell.h"
#import "UIImageView+AFNetworking.h"
#import "ApiConnector.h"


@interface ActivityCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *hashCommitLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameCommitLabel;
@end


@implementation ActivityCell

#pragma mark - setCellData:
- (void)setCellData:(Commit *)object {
    
    if (object) {
        NSString *avatarUrl = object.avatarUrl;
        if ((avatarUrl) && (![avatarUrl isEqual:[NSNull null]])) {
            avatarUrl = [[ApiConnector shared] appendAuthToLink:avatarUrl];
            
            __weak UIImageView *weakImageView = self.avatarImageView;
            
            NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:avatarUrl]];
            
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
        
        NSString *authorTitle = object.authorTitle;
        if (authorTitle) {
            self.authorLabel.text = authorTitle;
        }
        
        NSString *commitHash = object.commitHash;
        if (commitHash) {
            self.hashCommitLabel.text = commitHash;
        }
        
        NSString *commitTitle = object.commitTitle;
        if (commitTitle) {
            self.nameCommitLabel.text = commitTitle;
        }
    }
}
#pragma mark -

@end
