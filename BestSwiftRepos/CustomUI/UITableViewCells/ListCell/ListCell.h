//
//  ListCell.h
//  BestSwiftRepos
//
//  Created by Rost on 10/17/18.
//  Copyright © 2018 Rost Gress. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Repository.h"

NS_ASSUME_NONNULL_BEGIN

@interface ListCell : UITableViewCell

- (void)setCellData:(Repository *)object;

@end

NS_ASSUME_NONNULL_END
