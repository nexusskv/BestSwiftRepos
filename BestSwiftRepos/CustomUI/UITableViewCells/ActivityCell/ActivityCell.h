//
//  ActivityCell.h
//  BestSwiftRepos
//
//  Created by Rost on 10/17/18.
//  Copyright © 2018 Rost Gress. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Commit.h"

NS_ASSUME_NONNULL_BEGIN

@interface ActivityCell : UITableViewCell

- (void)setCellData:(Commit *)object;

@end

NS_ASSUME_NONNULL_END
