//
//  DateConverter.m
//  BestSwiftRepos
//
//  Created by Rost on 10/19/18.
//  Copyright © 2018 Rost Gress. All rights reserved.
//

#import "DateConverter.h"

@implementation DateConverter

#pragma mark - getIntervalFromDateString:
+ (int64_t)getIntervalFromDateString:(NSString *)date {
    NSDate *resultDate = nil;
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    // 2018-10-16T11:36:37Z
    [outputFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    resultDate = [outputFormatter dateFromString:date];
    NSTimeInterval timeInSeconds = [resultDate timeIntervalSince1970];

    return timeInSeconds;
}
#pragma mark -

@end
