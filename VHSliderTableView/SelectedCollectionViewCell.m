//
//  SelectedCollectionViewCell.m
//  HuaDongTableView
//
//  Created by 龙一郎 on 2019/12/15.
//  Copyright © 2019 fangliguo. All rights reserved.
//

#import "SelectedCollectionViewCell.h"

@interface SelectedCollectionViewCell ()
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) IBOutlet UILabel *siteLabel;
@end

@implementation SelectedCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UIView *view = [self viewWithTag:9998];
    view.layer.borderWidth = 1;
    view.layer.borderColor = [UIColor redColor].CGColor;
    view.layer.masksToBounds = YES;
    // Initialization code
}

@end
