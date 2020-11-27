//
//  SiteCollectionViewCell.m
//  HuaDongTableView
//
//  Created by 龙一郎 on 2019/12/13.
//  Copyright © 2019 fangliguo. All rights reserved.
//

#import "SiteCollectionViewCell.h"

@implementation SiteCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}
- (void)createView{
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
    [self.contentView addSubview:self.titleLabel];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.backgroundColor = [UIColor clearColor];
}
@end
