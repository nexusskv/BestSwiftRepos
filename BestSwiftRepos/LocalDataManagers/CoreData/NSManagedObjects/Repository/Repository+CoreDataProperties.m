//
//  Repository+CoreDataProperties.m
//  BestSwiftRepos
//
//  Created by Rost on 10/17/18.
//  Copyright © 2018 Rost Gress. All rights reserved.
//
//

#import "Repository+CoreDataProperties.h"

@implementation Repository (CoreDataProperties)

+ (NSFetchRequest<Repository *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"Repository"];
}

@dynamic fullTitle;
@dynamic objectId;
@dynamic ownerId;
@dynamic repoDetails;
@dynamic repoTitle;
@dynamic starsCount;
@dynamic ownerRelation;

@end
