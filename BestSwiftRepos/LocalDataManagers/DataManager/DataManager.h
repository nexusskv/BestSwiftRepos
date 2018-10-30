//
//  DataManager.h
//  BestSwiftRepos
//
//  Created by Rost on 10/17/18.
//  Copyright © 2018 Rost Gress. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DataManager : NSObject

+ (instancetype)shared;

- (void)getRepositoriesByPage:(NSInteger)page;
- (void)getCommitsForRepo:(NSString *)repo;

@end

NS_ASSUME_NONNULL_END
