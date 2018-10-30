//
//  Commit+CoreDataProperties.h
//  BestSwiftRepos
//
//  Created by Rost on 10/17/18.
//  Copyright © 2018 Rost Gress. All rights reserved.
//
//

#import "Commit.h"


NS_ASSUME_NONNULL_BEGIN

@interface Commit (CoreDataProperties)

+ (NSFetchRequest<Commit *> *)fetchRequest;

@property (nonatomic) int64_t objectId;
@property (nullable, nonatomic, copy) NSString *repoId;
@property (nullable, nonatomic, copy) NSString *avatarUrl;
@property (nullable, nonatomic, copy) NSString *authorTitle;
@property (nullable, nonatomic, copy) NSString *commitTitle;
@property (nullable, nonatomic, copy) NSString *commitHash;

@end

NS_ASSUME_NONNULL_END
