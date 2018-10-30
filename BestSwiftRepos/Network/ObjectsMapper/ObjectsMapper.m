//
//  ObjectsMapper.m
//  BestSwiftRepos
//
//  Created by Rost on 10/19/18.
//  Copyright © 2018 Rost Gress. All rights reserved.
//

#import "ObjectsMapper.h"

@implementation ObjectsMapper

#pragma mark - mappedKeysForObject:andValue:
+ (NSArray *)mappedKeysForObject:(NSString *)object andValue:(NSString *)value {
    if ([object isEqualToString:@"Repository"]) {
        return @[ @{@"receivedKey" : @"id",                 @"storeKey" : @"objectId"},
                  @{@"receivedKey" : @"name",               @"storeKey" : @"repoTitle"},
                  @{@"receivedKey" : @"full_name",          @"storeKey" : @"fullTitle"},
                  @{@"receivedKey" : @"stargazers_count",   @"storeKey" : @"starsCount"},
                  @{@"receivedKey" : @"description",        @"storeKey" : @"repoDetails"},
                  @{@"receivedKey" : @"owner.id",           @"storeKey" : @"ownerId"}];
    } else if ([object isEqualToString:@"Owner"]) {
        return @[ @{@"receivedKey" : @"ownerId",            @"storeKey" : @"objectId"},
                  @{@"receivedKey" : @"logoUrl",            @"storeKey" : @"logoUrl"},
                  @{@"receivedKey" : @"ownerTitle",         @"storeKey" : @"ownerTitle"}];
    }
    else if ([object isEqualToString:@"Commit"]) {
        return @[ @{@"receivedKey" : @"commit.author.date",     @"storeKey" : @"objectId"},
                  @{@"receivedKey" : @"sha",                    @"storeKey" : @"commitHash"},
                  @{@"receivedKey" : @"author.avatar_url",      @"storeKey" : @"avatarUrl"},
                  @{@"receivedKey" : @"commit.author.name",     @"storeKey" : @"authorTitle"},
                  @{@"receivedKey" : @"commit.message",         @"storeKey" : @"commitTitle"},
                  @{@"storeRepo"   : value,                     @"storeKey" : @"repoId"}];
    } else {
        return @[];
    }
}
#pragma mark -

@end
