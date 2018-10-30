//
//  DataFetcher.h
//  BestSwiftRepos
//
//  Created by Rost on 10/18/18.
//  Copyright © 2018 Rost Gress. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^DataFetcherCallback)(id);


@interface DataFetcher : NSObject

+ (instancetype)shared;

- (id)fetchByEntity:(NSString *)title andPredicate:(NSString *)predicate;
- (void)fetchByEntity:(NSString *)title withPredicate:(NSString *)predicate andCallback:(DataFetcherCallback)block;
- (void)saveObjects:(NSArray *)objects forEntity:(NSString *)entity;
- (void)saveObjects:(NSArray *)objects forEntity:(NSString *)entity withAddition:(NSString *)addition;
- (void)saveValues:(id)values forEntity:(NSString *)entity byKeys:(NSArray *)keys;
- (id)createEntityByClass:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
