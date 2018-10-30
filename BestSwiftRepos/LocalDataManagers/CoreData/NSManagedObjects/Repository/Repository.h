//
//  Repository.h
//  BestSwiftRepos
//
//  Created by Rost on 10/17/18.
//  Copyright © 2018 Rost Gress. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Owner;

NS_ASSUME_NONNULL_BEGIN

@interface Repository : NSManagedObject

@end

NS_ASSUME_NONNULL_END

#import "Repository+CoreDataProperties.h"
