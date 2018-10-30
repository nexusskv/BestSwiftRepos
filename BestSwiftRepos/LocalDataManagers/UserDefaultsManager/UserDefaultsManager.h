//
//  UserDefaultsManager.h
//  BestSwiftRepos
//
//  Created by Rost on 10/18/18.
//  Copyright © 2018 Rost Gress. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserDefaultsManager : NSObject

+ (instancetype)shared;

- (void)saveTotalRepositories:(NSInteger)total;
- (NSInteger)getTotalRepositories;

@end

NS_ASSUME_NONNULL_END
