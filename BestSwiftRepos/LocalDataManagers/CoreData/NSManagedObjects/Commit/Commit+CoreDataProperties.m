//
//  Commit+CoreDataProperties.m
//  BestSwiftRepos
//
//  Created by Rost on 10/17/18.
//  Copyright © 2018 Rost Gress. All rights reserved.
//
//

#import "Commit+CoreDataProperties.h"

@implementation Commit (CoreDataProperties)

+ (NSFetchRequest<Commit *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Commit"];
}

@dynamic objectId;
@dynamic repoId;
@dynamic avatarUrl;
@dynamic authorTitle;
@dynamic commitTitle;
@dynamic commitHash;

@end
