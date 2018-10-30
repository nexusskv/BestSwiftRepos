//
//  ApiConnector.h
//  BestSwiftRepos
//
//  Created by Rost on 10/17/18.
//  Copyright © 2018 Rost Gress. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

typedef void (^ApiConnectorCallback)(id);

@interface ApiConnector : NSObject

@property (nonatomic, copy) ApiConnectorCallback callbackBlock;

+ (instancetype)shared;

- (instancetype)initWithCallback:(ApiConnectorCallback)block;
- (void)loadRepositories:(NSUInteger)page;
- (void)loadCommitsForRepo:(NSString *)repo;
- (NSString *)appendAuthToLink:(NSString *)link;
@end

NS_ASSUME_NONNULL_END
