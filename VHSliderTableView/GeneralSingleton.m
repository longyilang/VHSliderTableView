//
//  SiteSingle.m
//  HuaDongTableView
//
//  Created by 龙一郎 on 2019/12/13.
//  Copyright © 2019 fangliguo. All rights reserved.
//

#import "GeneralSingleton.h"

@implementation GeneralSingleton

+(GeneralSingleton *)default{
    static GeneralSingleton *singleton;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        singleton = [[GeneralSingleton alloc] init];
    });
    return singleton;
}

- (NSMutableArray *)weekCalendar{
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < 7; i++) {
        NSDate *currentDate = [NSDate date];
        int days = i;
        NSTimeInterval oneDay = 24 * 60 * 60;
        NSDate *appointDate = [currentDate initWithTimeIntervalSinceNow: oneDay * days];
        NSString *string = [self getTimeStringWithDate:appointDate];
        NSString *mdStr = [string substringFromIndex:5];
        NSString *disPlayStr = nil;
        if (i == 0) {
            disPlayStr = [NSString stringWithFormat:@"今天(%@)",mdStr];
        }else if (i == 1){
            disPlayStr = [NSString stringWithFormat:@"明天(%@)",mdStr];
        }else{
            NSString *weekStr = [self getWeekDay:string];
            disPlayStr = [NSString stringWithFormat:@"%@(%@)",weekStr,mdStr];
        }
        NSDictionary *dic = @{@"display":disPlayStr,
                              @"date":string
        };
        [array addObject:dic];
    }
    return  array;
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
