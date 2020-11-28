//
//  SiteSingle.h
//  HuaDongTableView
//
//  Created by 龙一郎 on 2019/12/13.
//  Copyright © 2019 fangliguo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GeneralSingleton : NSObject

@property (nonatomic, strong) NSMutableArray *viewArray;

+(GeneralSingleton *)default;

- (NSMutableArray *)weekCalendar;

- (NSString *)getTimeStringWithDate:(NSDate *)date;

- (NSString*)getWeekDay:(NSString*)currentStr;

@end

NS_ASSUME_NONNULL_END
