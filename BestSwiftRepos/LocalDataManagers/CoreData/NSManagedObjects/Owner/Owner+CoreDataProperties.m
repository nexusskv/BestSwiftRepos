//
//  Owner+CoreDataProperties.m
//  
//
//  Created by Rost on 10/20/18.
//
//

#import "Owner+CoreDataProperties.h"


@implementation Owner (CoreDataProperties)

+ (NSFetchRequest<Owner *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"Owner"];
}

@dynamic logoUrl;
@dynamic objectId;
@dynamic ownerTitle;
@dynamic repoRelation;

@end
