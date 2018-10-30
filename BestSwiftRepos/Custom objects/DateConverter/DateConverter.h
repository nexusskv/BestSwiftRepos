//
//  DateConverter.h
//  BestSwiftRepos
//
//  Created by Rost on 10/19/18.
//  Copyright © 2018 Rost Gress. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DateConverter : NSObject

+ (int64_t)getIntervalFromDateString:(NSString *)date;

@end

NS_ASSUME_NONNULL_END
