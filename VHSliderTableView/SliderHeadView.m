//
//  SliderHeadView.m
//  VHSliderTableView
//
//  Created by 龙一郎 on 2020/11/28.
//

#import "SliderHeadView.h"

#import "SliderCollectionViewCell.h"

#import "GeneralSingleton.h"

#import "Define.h"

@interface SliderHeadView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray *dateArray;
@property (nonatomic, strong) UIScrollView *calendarScrollView;
@property (nonatomic, strong) UICollectionView *ctCollectionView;


@end

@implementation SliderHeadView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self showCalendar];
        [self showContent];
    }
    return self;
}

- (void)setContentArray:(NSMutableArray *)contentArray{
    _contentArray = contentArray;
    [self.ctCollectionView reloadData];
}

- (void)showCalendar{
    NSArray *array = [[GeneralSingleton default]weekCalendar];
    _dateArray = [NSMutableArray arrayWithArray:array];
    
    float width = WIDTH/3;
    NSInteger page;
    if (self.dateArray.count%3==0) {
        page = self.dateArray.count/3;
    }else{
        page = self.dateArray.count/3+1;
    }
    _calendarScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 70)];
    _calendarScrollView.bounces = NO;
    _calendarScrollView.pagingEnabled = YES;
    _calendarScrollView.showsHorizontalScrollIndicator = NO;
    _calendarScrollView.contentSize = CGSizeMake(WIDTH*page, 69);
    _calendarScrollView.backgroundColor  = [UIColor clearColor];
    [self addSubview:_calendarScrollView];

    for (int i = 0; i < self.dateArray.count; i++) {
        NSDictionary *dic = self.dateArray[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor clearColor];
        btn.frame = CGRectMake(width*i, 5, width, 60);
        btn.tag = 100+i;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn setTitle:dic[@"display"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(actionForcalendar:) forControlEvents:UIControlEventTouchUpInside];
        [_calendarScrollView addSubview:btn];
        if (i == 0) {
            btn.selected = YES;
        }
    }
    
    UIView *splitLine = [[UIView alloc]initWithFrame:CGRectMake(0, 69, WIDTH, 1)];
    splitLine.backgroundColor = UIColorFromRGB(0xEEEEEE);
    [self addSubview:splitLine];
}

- (void)showContent{
    UIView *vline = [[UIView alloc]initWithFrame:CGRectMake(59, 70, 1, 50)];
    vline.backgroundColor = UIColorFromRGB(0xEEEEEE);
    [self addSubview:vline];
    
    UICollectionViewFlowLayout *titleFlow = [[UICollectionViewFlowLayout alloc] init];
    titleFlow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    titleFlow.minimumLineSpacing = 0;
    titleFlow.minimumInteritemSpacing = 0;
    
    _ctCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(60, 70, WIDTH-60, 49) collectionViewLayout:titleFlow];
    _ctCollectionView.backgroundColor = [UIColor clearColor];
    _ctCollectionView.showsHorizontalScrollIndicator = NO;
    _ctCollectionView.delegate = self;
    _ctCollectionView.dataSource = self;
    [_ctCollectionView registerClass:[SliderCollectionViewCell class] forCellWithReuseIdentifier:@"titleReuse"];
    [self addSubview:self.ctCollectionView];
    
    [[GeneralSingleton default].viewArray addObject:self.ctCollectionView];
}

- (void)actionForcalendar:(UIButton *)btn{
    if (btn.selected) {
        return;
    }else{
        btn.selected = YES;
    }
    for (id obj in self.calendarScrollView.subviews) {
        if ([obj isKindOfClass:[UIButton class]] && ![obj isEqual:btn]) {
            UIButton *button = obj;
            button.selected = NO;
        }
    }
    float width = WIDTH/3;
    NSInteger tag = btn.tag-100;
    NSInteger rank = tag/3;
    NSInteger page = self.calendarScrollView.contentOffset.x/WIDTH;
    float lineX = page*WIDTH + rank*width +2;
    UIView *line = [self.calendarScrollView viewWithTag:9999];
    [UIView animateWithDuration:0.1 animations:^{
        line.frame = CGRectMake(lineX, 66, width-1, 3);
    }];
    [self.calendarScrollView setContentOffset:CGPointMake(rank*WIDTH, 0) animated:NO];
    self.action_handle(self.dateArray[tag][@"date"]);
}

#pragma mark UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return (CGSize){80,40};
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return (CGSize){0,0};
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark UICollectionViewDelegate,UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.contentArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SliderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"titleReuse" forIndexPath:indexPath];
    cell.titleLabel.text = self.contentArray[indexPath.row];
    return  cell;
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.ctCollectionView) {
        for (UICollectionView *view in [GeneralSingleton default].viewArray) {
            view.contentOffset = scrollView.contentOffset;
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
