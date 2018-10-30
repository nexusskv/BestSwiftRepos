//
//  ApiConnector.m
//  BestSwiftRepos
//
//  Created by Rost on 10/17/18.
//  Copyright © 2018 Rost Gress. All rights reserved.
//

#import "ApiConnector.h"
#import "AFNetworking.h"
#import "ObjectsMapper.h"
#import "UserDefaultsManager.h"


NSString *apiUrl        = @"https://api.github.com";
NSString *path          = @"search/repositories?q=language:swift&sort=full_name&order=asc&page";
NSString *pageObjects   = @"per_page=20";
NSString *reposPath     = @"repos";
NSString *commitPath    = @"commits";
NSString *clientPath    = @"client_id";
NSString *secretPath    = @"client_secret";


@implementation ApiConnector


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


#pragma mark - initWithCallback:
- (instancetype)initWithCallback:(ApiConnectorCallback)block {
    if (self = [super init])
        self.callbackBlock = block;
    
    return self;
}
#pragma mark -


#pragma mark - loadRepositories
- (void)loadRepositories:(NSUInteger)page {
    AFURLSessionManager *sessionManager = [self createSessionManager];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@=%lu&%@", apiUrl, path, (unsigned long)page, pageObjects];

    NSURLRequest *repoRequest = [self createRequestByLink:urlString];
    
    NSURLSessionDataTask *dataTask = [sessionManager dataTaskWithRequest:repoRequest
                                                       completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            self.callbackBlock(error.localizedDescription);
        } else {
            int64_t totalRepos = [responseObject[@"total_count"] longLongValue];
            if (totalRepos > 0) {
                [[UserDefaultsManager shared] saveTotalRepositories:totalRepos]; // Save for download sentinel
            }
            
            NSArray *reposArray = responseObject[@"items"];
            
            if (reposArray.count > 0) {
                NSMutableArray *fullReposArray = [NSMutableArray array];
                
                for (NSDictionary *repo in reposArray) {
                    NSString *ownerLink = [repo valueForKeyPath:@"owner.url"];
                    
                    [self loadOwnerValuesByLink:ownerLink andValues:repo withCompletion:^(id result) {
                        if ([result isKindOfClass:[NSDictionary class]]) {
                            [fullReposArray addObject:result];
                        }
                        
                        if (fullReposArray.count == reposArray.count) {
                            self.callbackBlock(fullReposArray);
                        }
                    }];
                }
            }
        }
    }];
    
    [dataTask resume];
}
#pragma mark -


#pragma mark - loadOwnerValuesByLink:withCompletion:
- (void)loadOwnerValuesByLink:(NSString *)link andValues:(NSDictionary *)values withCompletion:(ApiConnectorCallback)block {
    NSURLRequest *ownerRequest = [self createRequestByLink:link];

    [self loadOwnerData:ownerRequest withCompletion:^(id result) {
        NSError *error = nil;
        NSDictionary *jsonData = nil;
        if ([result isKindOfClass:[NSData class]]) {
            jsonData = [NSJSONSerialization JSONObjectWithData:(NSData *)result options:NSJSONReadingMutableContainers error:&error];
            
            NSMutableDictionary *repoValues = [NSMutableDictionary dictionaryWithDictionary:values];
            if ([jsonData isKindOfClass:[NSDictionary class]]) {
                NSDictionary *resultValues = (NSDictionary *)jsonData;
                
                NSNumber *idNum = resultValues[@"id"];
                if (idNum) {
                    repoValues[@"ownerId"]    = idNum;
                }
                
                NSString *nameString = resultValues[@"name"];
                if ((nameString) && (![nameString isEqual:[NSNull null]])) {
                    repoValues[@"ownerTitle"] = nameString;
                }
                
                NSString *logoString = resultValues[@"avatar_url"];
                if ((logoString) && (![logoString isEqual:[NSNull null]])) {
                    repoValues[@"logoUrl"]    = logoString;
                }
                
                block(repoValues);
            }
        } else {
            block(jsonData);
        }
    }];

}
#pragma mark -


#pragma mark - loadCommitsForRepo:
- (void)loadCommitsForRepo:(NSString *)repo {
    AFURLSessionManager *sessionManager = [self createSessionManager];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@/%@", apiUrl, reposPath, repo, commitPath];
    
    NSURLRequest *repoRequest = [self createRequestByLink:urlString];
    
    NSURLSessionDataTask *dataTask = [sessionManager dataTaskWithRequest:repoRequest
                                                       completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
       if (error) {
           self.callbackBlock(error.localizedDescription);
       } else {
           self.callbackBlock(responseObject);
       }
    }];
    
    [dataTask resume];
}
#pragma mark -


#pragma mark - createSessionManager
- (AFURLSessionManager *)createSessionManager {
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:sessionConfig];
    
    return sessionManager;
}
#pragma mark -


#pragma mark - createRequestByLink:
- (NSURLRequest *)createRequestByLink:(NSString *)link {
    
    link = [self appendAuthToLink:link];

    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:link]];
    [urlRequest setHTTPMethod:@"GET"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    return urlRequest;
}
#pragma mark -


#pragma mark - loadOwnerData:withCompletion:
- (void)loadOwnerData:(NSURLRequest *)request withCompletion:(ApiConnectorCallback)block {
    __block NSData *data = nil;

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *taskData, NSURLResponse *response, NSError *error) {
        data = taskData;
        if (!data) {
            NSLog(@"%@", error);
        } else {
            block(data);
        }
    }];
    
    [dataTask resume];
}
#pragma mark -


#pragma mark - appendAuthToLink:
- (NSString *)appendAuthToLink:(NSString *)link {
    return [NSString stringWithFormat:@"%@?%@=%@&%@=%@", link, clientPath, [self githubClientId], secretPath, [self getSecretId]];
}
#pragma mark -


#pragma mark - GitHub Auth
- (NSString *)githubClientId {
    return @"b4993cd636b4f168c841";
}

- (NSString *)getSecretId {
    return @"bda4f4fd8c4918d83c9b59c63540ec99f99bc4bb";
}
#pragma mark -

@end
