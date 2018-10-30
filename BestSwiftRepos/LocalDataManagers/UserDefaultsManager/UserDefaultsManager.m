//
//  UserDefaultsManager.m
//  BestSwiftRepos
//
//  Created by Rost on 10/18/18.
//  Copyright © 2018 Rost Gress. All rights reserved.
//

#import "UserDefaultsManager.h"

@implementation UserDefaultsManager


#pragma mark - Shared instance
+ (instancetype)shared {
    static dispatch_once_t once;
    static id sharedInstance;
    
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}
#pragma mark -


#pragma mark - Repositories total setter / getter
- (void)saveTotalRepositories:(NSInteger)total {
    [[NSUserDefaults standardUserDefaults] setInteger:total forKey:@"totalRepositories"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSInteger)getTotalRepositories {
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"totalRepositories"];
}
#pragma mark -

@end
