//
//  Repository+CoreDataProperties.h
//  BestSwiftRepos
//
//  Created by Rost on 10/17/18.
//  Copyright © 2018 Rost Gress. All rights reserved.
//
//

#import "Repository.h"


NS_ASSUME_NONNULL_BEGIN

@interface Repository (CoreDataProperties)

+ (NSFetchRequest<Repository *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *fullTitle;
@property (nonatomic) int64_t objectId;
@property (nonatomic) int64_t ownerId;
@property (nullable, nonatomic, copy) NSString *repoDetails;
@property (nullable, nonatomic, copy) NSString *repoTitle;
@property (nonatomic) int64_t starsCount;
@property (nullable, nonatomic, retain) Owner *ownerRelation;

@end

NS_ASSUME_NONNULL_END
