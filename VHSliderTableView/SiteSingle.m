//
//  SiteSingle.m
//  HuaDongTableView
//
//  Created by 龙一郎 on 2019/12/13.
//  Copyright © 2019 fangliguo. All rights reserved.
//

#import "SiteSingle.h"

@implementation SiteSingle
+(SiteSingle *)shareSingleton{
    static SiteSingle *singleton;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        singleton = [[SiteSingle alloc] init];
    });
    return singleton;
}

- (NSString *)getTimeStringWithDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}

- (NSString*)getWeekDay:(NSString*)currentStr{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate*date =[dateFormat dateFromString:currentStr];
    NSArray*weekdays = [NSArray arrayWithObjects: [NSNull null],@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",nil];
    NSCalendar*calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone*timeZone = [[NSTimeZone alloc]initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];

    NSCalendarUnit calendarUnit =NSCalendarUnitWeekday;
    NSDateComponents*theComponents = [calendar components:calendarUnit fromDate:date];

    return[weekdays objectAtIndex:theComponents.weekday];
}

@end
