//
//  DataFetcher.m
//  BestSwiftRepos
//
//  Created by Rost on 10/18/18.
//  Copyright © 2018 Rost Gress. All rights reserved.
//

#import "DataFetcher.h"
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ApiConnector.h"
#import "DateConverter.h"
#import "ObjectsMapper.h"


@implementation DataFetcher

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


#pragma mark - managedObjectContext
- (NSManagedObjectContext *)managedObjectContext {
    return ((AppDelegate *)[UIApplication sharedApplication].delegate).persistentContainer.viewContext;
}
#pragma mark -


#pragma mark - fetchByEntity:andPredicate:
- (id)fetchByEntity:(NSString *)title andPredicate:(NSString *)predicate {
    NSArray *valuesArray          = nil;
    NSError *fetchError           = nil;
    
    NSFetchRequest *newRequest = [self requestForEntity:title andPredicate:predicate];
    
    valuesArray = [self.managedObjectContext executeFetchRequest:newRequest error:&fetchError];
    
    if (fetchError) {
        NSLog(@"Fetch values as dictionary error -> %@ ", fetchError.description);
        return fetchError.description;
    } else if ([valuesArray count] > 0) {
        return valuesArray;
    }
    
    return nil;
}
#pragma mark -


#pragma mark - fetchByEntity:withPredicate:andCallback:
- (void)fetchByEntity:(NSString *)title withPredicate:(NSString *)predicate andCallback:(DataFetcherCallback)block {
    NSError *fetchError           = nil;
    __block id fetchedValues      = nil;
    
    NSFetchRequest *newRequest = [self requestForEntity:title andPredicate:predicate];
    
    NSAsynchronousFetchRequest *asyncFR =
    [[NSAsynchronousFetchRequest alloc] initWithFetchRequest:newRequest
                                             completionBlock:^(NSAsynchronousFetchResult *result) {
                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                     if ([result.finalResult count] > 0) {
                                                         fetchedValues = result.finalResult;
                                                         
                                                         block(fetchedValues);
                                                     } else if (fetchError) {
                                                         block(fetchError);
                                                     } else {
                                                         block(fetchedValues);
                                                     }
                                                 });
                                             }];
    
    [self.managedObjectContext executeRequest:asyncFR error:&fetchError];
}
#pragma mark -


#pragma mark - requestForEntity:andPredicate:
- (NSFetchRequest *)requestForEntity:(NSString *)entity andPredicate:(NSString *)predicate {
    NSEntityDescription *fetchEntity = [NSEntityDescription entityForName:entity
                                                   inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *newRequest          = [[NSFetchRequest alloc] init];
    newRequest.entity                   = fetchEntity;
    newRequest.returnsDistinctResults   = YES;
    newRequest.includesPropertyValues   = YES;
    
    if (predicate) {
        [newRequest setPredicate:[NSPredicate predicateWithFormat:predicate]];
    }
    
    return newRequest;
}
#pragma mark -


#pragma mark - saveObjects:forEntity:
- (void)saveObjects:(NSArray *)objects forEntity:(NSString *)entity {
    NSArray *keysArray = [ObjectsMapper mappedKeysForObject:entity andValue:@""];
    
    for (NSDictionary *objectValues in objects) {
        [self saveValues:objectValues forEntity:entity byKeys:keysArray];
    }
}
#pragma mark -


#pragma mark - saveObjects:forEntity:withAddition:
- (void)saveObjects:(NSArray *)objects forEntity:(NSString *)entity withAddition:(NSString *)addition {
    NSArray *keysArray = [ObjectsMapper mappedKeysForObject:entity andValue:addition];
    
    for (NSDictionary *objectValues in objects) {
        [self saveValues:objectValues forEntity:entity byKeys:keysArray];
    }
}
#pragma mark -


#pragma mark - saveValues:forEntity:byKeys:
- (void)saveValues:(id)values forEntity:(NSString *)entity byKeys:(NSArray *)keys {
    id newObject = nil;
    
    NSString *fetchPredicate = [NSString stringWithFormat:@"objectId == '%@'", values[@"id"]];
    NSArray *existsCheckArray = [self fetchByEntity:entity andPredicate:fetchPredicate];
    
    if ([existsCheckArray count] > 0) {
        newObject = [existsCheckArray lastObject];
    } else {
        newObject = [self createEntityByClass:entity];
    }

    if (newObject) {
        for (NSDictionary *keyValues in keys) {
            if ([entity isEqualToString:@"Repository"]) {
                id objectValue = values[keyValues[@"receivedKey"]];
                
                if ([keyValues[@"receivedKey"] isEqualToString:@"owner.id"]) {
                    NSString *ownerEntity = @"Owner";
                    id ownerObject = nil;
                    
                    objectValue = [values valueForKeyPath:keyValues[@"receivedKey"]];
                    
                    NSString *ownerPredicate  = [NSString stringWithFormat:@"objectId == '%@'", objectValue];
                    NSArray *ownerExistsArray = [self fetchByEntity:ownerEntity andPredicate:ownerPredicate];
                    if ([ownerExistsArray count] > 0) {
                        ownerObject = [ownerExistsArray lastObject];
                    } else {
                        ownerObject = [self createEntityByClass:ownerEntity];
                    }
                    
                    NSArray *ownerKeysArray = [ObjectsMapper mappedKeysForObject:ownerEntity andValue:@""];
                    for (NSDictionary *ownerValues in ownerKeysArray) {
                        id ownerValue = values[ownerValues[@"receivedKey"]];
                        
                        if (ownerValue) {
                            [ownerObject setValue:ownerValue forKey:ownerValues[@"storeKey"]];
                        }
                    }
                    
                    if (ownerObject) {
                        [newObject setValue:ownerObject forKey:@"ownerRelation"];
                    } else {
                        NSLog(@"Owner values did not downloaded.");
                    }
                }
                                
                if ((objectValue) && (objectValue != NULL) && (objectValue != [NSNull null])) {
                    [newObject setValue:objectValue forKey:keyValues[@"storeKey"]];
                } else {
                    [newObject setValue:@"Empty value received" forKey:keyValues[@"storeKey"]];
                }
            } else if ([entity isEqualToString:@"Commit"]) {
                id objectValue = nil;
                if ([keyValues[@"storeKey"] isEqualToString:@"objectId"]) {
                    NSString *commitDateString = [values valueForKeyPath:keyValues[@"receivedKey"]];
                    
                    int64_t commitId = [DateConverter getIntervalFromDateString:commitDateString];
                    objectValue      = @(commitId);
                } else if ([keyValues[@"storeKey"] isEqualToString:@"repoId"]) {
                    objectValue = keyValues[@"storeRepo"];
                } else if ([keyValues[@"storeKey"] isEqualToString:@"commitHash"]) {
                    objectValue = values[keyValues[@"receivedKey"]];
                } else {
                    objectValue = [values valueForKeyPath:keyValues[@"receivedKey"]];
                }

                if ((objectValue) && (objectValue != NULL) && (objectValue != [NSNull null])) {
                    [newObject setValue:objectValue forKey:keyValues[@"storeKey"]];
                } else {
                    [newObject setValue:@"Empty value received" forKey:keyValues[@"storeKey"]];
                }
            }
        }
        
        [(AppDelegate *)[UIApplication sharedApplication].delegate saveContext];
    }
}
#pragma mark -


#pragma mark - createEntityByClass:
- (id)createEntityByClass:(NSString *)title {
    NSEntityDescription *saveEntity = [NSEntityDescription entityForName:title
                                                  inManagedObjectContext:self.managedObjectContext];
    
    id newObject = [[NSClassFromString(title) alloc] initWithEntity:saveEntity
                                     insertIntoManagedObjectContext:self.managedObjectContext];
    
    return newObject;
}
#pragma mark -

@end
