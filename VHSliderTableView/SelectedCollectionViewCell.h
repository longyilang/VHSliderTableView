//
//  SelectedCollectionViewCell.h
//  HuaDongTableView
//
//  Created by 龙一郎 on 2019/12/15.
//  Copyright © 2019 fangliguo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SelectedCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) IBOutlet UILabel *timeLb;
@property (nonatomic, strong) IBOutlet UILabel *siteLb;

@end

NS_ASSUME_NONNULL_END
