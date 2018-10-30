//
//  DataManager.m
//  BestSwiftRepos
//
//  Created by Rost on 10/17/18.
//  Copyright © 2018 Rost Gress. All rights reserved.
//

#import "DataManager.h"
#import "ApiConnector.h"
#import "AFNetworking.h"
#import "UserDefaultsManager.h"
#import "DataFetcher.h"


@implementation DataManager

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


#pragma mark - getRepositoriesByPage:
- (void)getRepositoriesByPage:(NSInteger)page {
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {

        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            case AFNetworkReachabilityStatusNotReachable: {
                [self getLocalRepositories];
            }
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi: {
                NSInteger pageNum = 0;
                if (page > 0) {
                    pageNum = page;          // Load Repos by page
                } else {
                    NSArray *allLocalRepos = [[DataFetcher shared] fetchByEntity:@"Repository" andPredicate:@"objectId > '0'"];
                    
                    if (allLocalRepos > 0) {
                        pageNum = allLocalRepos.count / 20;     // Calc current page by repos per page
                        pageNum += 1;                           // Iterate page to next for download
                    }
                }

                ApiConnector *apiConnector = [[ApiConnector alloc] initWithCallback:^(id result) {
                    if ([result isKindOfClass:[NSString class]]) {
                        [self sendAlertMessage:result byEntity:@"Repository"];
                    } else if ([result isKindOfClass:[NSArray class]]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSArray *reposArray = result;
                            if (reposArray) {
                                [[DataFetcher shared] saveObjects:reposArray forEntity:@"Repository"];

                                [self getLocalRepositories];
                            }
                        });
                    }
                }];

                [apiConnector loadRepositories:pageNum];
            }
                break;
                
            default:
                break;
        }
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}
#pragma mark -


#pragma mark - getLocalRepositories
- (void)getLocalRepositories {
    [[DataFetcher shared] fetchByEntity:@"Repository" withPredicate:@"objectId > '0'" andCallback:^(id result) {
        if ([result isKindOfClass:[NSString class]]) {
            [self sendAlertMessage:result byEntity:@"Repository"];
        } else if ([result isKindOfClass:[NSArray class]]) {
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSSortDescriptor *starsSort = [[NSSortDescriptor alloc] initWithKey:@"starsCount" ascending:NO];
                
                NSArray *sortDescriptors = @[starsSort];
                NSArray *sortedArray = [result sortedArrayUsingDescriptors:sortDescriptors];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self sendReposResult:sortedArray];
                });
            });
        }
    }];
}
#pragma mark -


#pragma mark - getCommitsForRepo:
- (void)getCommitsForRepo:(NSString *)repo {
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            case AFNetworkReachabilityStatusNotReachable: {
                [self getLocalCommitsForRepo:repo];
            }
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi: {
                
                ApiConnector *apiConnector = [[ApiConnector alloc] initWithCallback:^(id result) {
                    if ([result isKindOfClass:[NSString class]]) {
                        [self sendAlertMessage:result byEntity:@"Commit"];
                    } else if ([result isKindOfClass:[NSArray class]]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (result) {
                                [[DataFetcher shared] saveObjects:result forEntity:@"Commit" withAddition:repo];
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [self getLocalCommitsForRepo:repo];
                                });
                            }
                        });
                    }
                }];
                
                [apiConnector loadCommitsForRepo:repo];
            }
                break;
                
            default:
                break;
        }
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}
#pragma mark -


#pragma mark - getLocalCommits
- (void)getLocalCommitsForRepo:(NSString *)repo {
    NSString *predString = [NSString stringWithFormat:@"objectId > '0' AND repoId == '%@'", repo];
    [[DataFetcher shared] fetchByEntity:@"Commit" withPredicate:predString andCallback:^(id result) {
        if ([result isKindOfClass:[NSString class]]) {
            [self sendAlertMessage:result byEntity:@"Commit"];
        } else if ([result isKindOfClass:[NSArray class]]) {
            [self sendCommitsResult:result];
        }
    }];
}
#pragma mark -


#pragma mark - Notifications methods
- (void)sendAlertMessage:(NSString *)message byEntity:(NSString *)entity {
    NSString *notifName = [NSString stringWithFormat:@"show%@Alert", entity];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notifName
                                                        object:self
                                                      userInfo:@{@"alert": message}];
}

- (void)sendReposResult:(NSArray *)result {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reposResult"
                                                        object:self
                                                      userInfo:@{@"result": result}];
}

- (void)sendCommitsResult:(NSArray *)result {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"commitsResult"
                                                        object:self
                                                      userInfo:@{@"result": result}];
}
#pragma mark -

@end
