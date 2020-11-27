//
//  SiteSingle.h
//  HuaDongTableView
//
//  Created by 龙一郎 on 2019/12/13.
//  Copyright © 2019 fangliguo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SiteSingle : NSObject

@property (nonatomic, strong) NSMutableArray *viewArray;
@property (nonatomic, strong) NSMutableDictionary *siteDic;
@property (nonatomic, strong) NSString *sellerNameStr;
@property (nonatomic, strong) NSString *siteNameStr;

+(SiteSingle *)shareSingleton;

- (NSString *)getTimeStringWithDate:(NSDate *)date;

- (NSString*)getWeekDay:(NSString*)currentStr;

@end

NS_ASSUME_NONNULL_END
