//
//  BaseViewController.h
//  BestSwiftRepos
//
//  Created by Rost on 10/17/18.
//  Copyright © 2018 Rost Gress. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *dataTable;
@property (strong, nonatomic) NSArray *dataArray;

- (void)showAlertMessage:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
