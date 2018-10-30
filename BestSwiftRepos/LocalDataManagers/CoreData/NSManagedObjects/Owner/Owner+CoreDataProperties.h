//
//  Owner+CoreDataProperties.h
//  
//
//  Created by Rost on 10/20/18.
//
//

#import "Owner.h"


NS_ASSUME_NONNULL_BEGIN

@interface Owner (CoreDataProperties)

+ (NSFetchRequest<Owner *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *logoUrl;
@property (nonatomic) int64_t objectId;
@property (nullable, nonatomic, copy) NSString *ownerTitle;
@property (nullable, nonatomic, retain) Repository *repoRelation;

@end

NS_ASSUME_NONNULL_END
