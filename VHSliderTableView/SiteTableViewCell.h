//
//  SiteTableViewCell.h
//  SmartCommunity
//
//  Created by 龙一郎 on 2020/3/6.
//  Copyright © 2020 龙一郎. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ActivityEnterBlock)(NSDictionary * _Nonnull);

NS_ASSUME_NONNULL_BEGIN

@interface SiteTableViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) ActivityEnterBlock activityEnterCompletion;
- (void)refreshUI:(NSMutableArray *)dataArray;

@end

NS_ASSUME_NONNULL_END
