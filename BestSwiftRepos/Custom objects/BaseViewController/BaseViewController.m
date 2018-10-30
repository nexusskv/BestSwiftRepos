//
//  BaseViewController.m
//  BestSwiftRepos
//
//  Created by Rost on 10/17/18.
//  Copyright © 2018 Rost Gress. All rights reserved.
//

#import "BaseViewController.h"


@interface BaseViewController ()

@end


@implementation BaseViewController

#pragma mark - showAlertMessage:
- (void)showAlertMessage:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Message."
                                                                             message:message
                                                                    preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action) {}];
    
    [alertController addAction:defaultAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark -

@end
