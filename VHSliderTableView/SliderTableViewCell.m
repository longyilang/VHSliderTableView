//
//  SiteTableViewCell.m
//  SmartCommunity
//
//  Created by 龙一郎 on 2020/3/6.
//  Copyright © 2020 龙一郎. All rights reserved.
//

#import "SliderTableViewCell.h"

#import "SliderCollectionViewCell.h"

#import "GeneralSingleton.h"

#import "Define.h"

@interface SliderTableViewCell ()
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UICollectionView *priceCollectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation SliderTableViewCell

- (void)dealloc {
    //NSLog(@"Release--->ArticleTableViewCell");
}

- (void)createView{
    self.titleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.titleLabel];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    
    self.line = [[UIView alloc] init];
    self.line.backgroundColor = UIColorFromRGB(0xEEEEEE);
    [self.contentView addSubview:self.line];
    
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    flow.itemSize = CGSizeMake(80, 40);
    flow.minimumLineSpacing = 0;
    flow.minimumInteritemSpacing = 0;
    flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.priceCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flow];
    [self.contentView addSubview:self.priceCollectionView];
    [self.priceCollectionView registerClass:[SliderCollectionViewCell class] forCellWithReuseIdentifier:@"cellReuse"];
    self.priceCollectionView.backgroundColor = [UIColor whiteColor];
    self.priceCollectionView.bounces = NO;
    self.priceCollectionView.showsHorizontalScrollIndicator = NO;
    self.priceCollectionView.delegate = self;
    self.priceCollectionView.dataSource = self;
    [[GeneralSingleton default].viewArray addObject:self.priceCollectionView];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(5, 0, 50, self.contentView.frame.size.height);
    self.line.frame = CGRectMake(59, 0, 1, self.contentView.frame.size.height);
    self.priceCollectionView.frame = CGRectMake(60, 0, self.contentView.frame.size.width-60, self.contentView.frame.size.height);
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SliderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellReuse" forIndexPath:indexPath];
    NSDictionary *dic = self.dataArray[indexPath.row];
    if (dic.allKeys.count == 0) {
        cell.titleLabel.text = nil;
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    }
    
    int amount = [dic[@"amount"] intValue];
    if (amount <= 0) {
        cell.titleLabel.text = @"已售";
        cell.titleLabel.textColor = UIColorFromRGB(0x9C9C9C);
        cell.backgroundColor = UIColorFromRGB(0xEEEEEE);
    }else{
        cell.titleLabel.text = [NSString stringWithFormat:@"¥ %@",dic[@"configPriceYuan"]];
        cell.backgroundColor = [UIColor whiteColor];
//        NSString *keyStr = dic[@"id"];
        //NSString *valueStr = [[SiteSingle shareSingleton].siteDic valueForKey:keyStr];
//        if ([valueStr isEqualToString:@"1"]) {
//            cell.backgroundColor = UIColorFromRGB(0xEE605A);
//            cell.titleLabel.textColor = [UIColor whiteColor];
//        }else{
//            cell.backgroundColor = [UIColor whiteColor];
//            cell.titleLabel.textColor = [UIColor blackColor];
//        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.dataArray[indexPath.row];
    if (dic.allKeys.count == 0) {
        return;
    }
    int amount = [dic[@"amount"] intValue];
    if (amount <= 0) {
        return;
    }else{
//        NSString *keyStr = dic[@"id"];
//        NSString *valueStr = [[SiteSingle shareSingleton].siteDic valueForKey:keyStr];
//        
//        SiteCollectionViewCell *cell = (SiteCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//        
//        if ([valueStr isEqualToString:@"1"]) {
//            [[SiteSingle shareSingleton].siteDic setValue:@"0" forKey:keyStr];
//            cell.backgroundColor = [UIColor whiteColor];
//            cell.titleLabel.textColor = [UIColor blackColor];
//        }else{
//            [[SiteSingle shareSingleton].siteDic setValue:@"1" forKey:keyStr];
//            cell.backgroundColor = UIColorFromRGB(0xEE605A);
//            cell.titleLabel.textColor = [UIColor whiteColor];
//        }
//        if (self.activityEnterCompletion) {
//            self.activityEnterCompletion(dic);
//        }
    }
}

- (void)refreshUI:(NSMutableArray *)array{
    self.dataArray = [NSMutableArray array];
    self.dataArray = array;
    [self.priceCollectionView reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.priceCollectionView) {
        for (UICollectionView *view in [GeneralSingleton default].viewArray) {
            view.contentOffset = scrollView.contentOffset;
        }
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self createView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
