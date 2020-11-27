
#import "SiteChooseViewController.h"

#import "SiteCollectionViewCell.h"

#import "SiteTableViewCell.h"

#import "SiteSingle.h"

#import "Define.h"

@interface SiteChooseViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) IBOutlet UITableView *articleTableView;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UICollectionView *titleCollectionView;
@property (nonatomic, strong) UIScrollView *weekScrollView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *dateArray;
@property (nonatomic, assign) float WIDTH;
@end

@implementation SiteChooseViewController

- (void)dealloc{
    NSLog(@"Release--->%@",[self class]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.WIDTH = [UIScreen mainScreen].bounds.size.width;
            
    _dataArray = [NSMutableArray array];
    
    [SiteSingle shareSingleton].viewArray = [NSMutableArray array];
    [SiteSingle shareSingleton].siteDic = [NSMutableDictionary dictionary];
    
    _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.WIDTH, 120)];
    _headView.backgroundColor = [UIColor clearColor];
    self.articleTableView.tableHeaderView = self.headView;
    [self.articleTableView registerNib:[UINib nibWithNibName:@"SiteTableViewCell" bundle:nil] forCellReuseIdentifier:@"reuse"];

    [self createWeekView];
    [self createCollectionView];
}

- (void)createWeekView{
    _dateArray = [NSMutableArray array];
    for (int i = 0; i < 7; i++) {
        NSDate *currentDate = [NSDate date];
        int days = i;
        NSTimeInterval oneDay = 24 * 60 * 60;
        NSDate *appointDate = [currentDate initWithTimeIntervalSinceNow: oneDay * days];
        NSString *string = [[SiteSingle shareSingleton]getTimeStringWithDate:appointDate];
        NSString *mdStr = [string substringFromIndex:5];
        NSString *disPlayStr = nil;
        if (i == 0) {
            disPlayStr = [NSString stringWithFormat:@"今天(%@)",mdStr];
        }else if (i == 1){
            disPlayStr = [NSString stringWithFormat:@"明天(%@)",mdStr];
        }else{
            NSString *weekStr = [[SiteSingle shareSingleton]getWeekDay:string];
            disPlayStr = [NSString stringWithFormat:@"%@(%@)",weekStr,mdStr];
        }
        NSDictionary *dic = @{@"display":disPlayStr,
                              @"date":string
        };
        [self.dateArray addObject:dic];
    }
    
    float width = self.WIDTH/3;
    NSInteger page;
    if (self.dateArray.count%3==0) {
        page = self.dateArray.count/3;
    }else{
        page = self.dateArray.count/3+1;
    }
    _weekScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.WIDTH, 70)];
    _weekScrollView.bounces = NO;
    _weekScrollView.pagingEnabled = YES;
    _weekScrollView.showsHorizontalScrollIndicator = NO;
    _weekScrollView.contentSize = CGSizeMake(self.WIDTH*page, 69);
    _weekScrollView.backgroundColor  = [UIColor clearColor];
    [self.headView addSubview:_weekScrollView];

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
        [btn addTarget:self action:@selector(actionChooseDate:) forControlEvents:UIControlEventTouchUpInside];
        [_weekScrollView addSubview:btn];
        if (i == self.timeIndex) {
            btn.selected = YES;
        }
    }
    
    UIView *splitLine = [[UIView alloc]initWithFrame:CGRectMake(0, 69, self.WIDTH, 1)];
    splitLine.backgroundColor = UIColorFromRGB(0xEEEEEE);
    [self.headView addSubview:splitLine];
    [self chooseDate:100+self.timeIndex];
}

- (void)createCollectionView{
    UIView *vline = [[UIView alloc]initWithFrame:CGRectMake(59, 70, 1, 50)];
    vline.backgroundColor = UIColorFromRGB(0xEEEEEE);
    [self.headView addSubview:vline];
    
    UICollectionViewFlowLayout *titleFlow = [[UICollectionViewFlowLayout alloc] init];
    titleFlow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    titleFlow.minimumLineSpacing = 0;
    titleFlow.minimumInteritemSpacing = 0;
    
    _titleCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(60, 70, self.WIDTH-60, 49) collectionViewLayout:titleFlow];
    _titleCollectionView.backgroundColor = [UIColor clearColor];
    _titleCollectionView.showsHorizontalScrollIndicator = NO;
    _titleCollectionView.delegate = self;
    _titleCollectionView.dataSource = self;
    [_titleCollectionView registerClass:[SiteCollectionViewCell class] forCellWithReuseIdentifier:@"titleReuse"];
    [self.headView addSubview:self.titleCollectionView];

    self.articleTableView.contentInsetAdjustmentBehavior = false ;
    
    [[SiteSingle shareSingleton].viewArray addObject:self.titleCollectionView];
}

#pragma mark UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.dataArray.count > 0) {
        NSArray *arr = self.dataArray[0][@"config"];
        return arr.count;
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataArray.count > 0) {
        return 1;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuse = @"reuse";
    SiteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse forIndexPath:indexPath];

    NSDictionary *dic = self.dataArray[0][@"config"][indexPath.section];
    NSMutableArray *configArray = [NSMutableArray array];
    for (NSDictionary *dic in self.dataArray) {
        [configArray addObject:dic[@"config"]];
    }
    NSMutableArray *resultArray = [NSMutableArray array];
    for (NSArray *array in configArray){
        [resultArray addObject:array[indexPath.section]];
    }
    cell.titleLabel.text = dic[@"validStartTimeStr"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.separatorInset = UIEdgeInsetsZero;
    [cell refreshUI:resultArray];
    return cell;
}

#pragma mark UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.titleCollectionView) {
        return (CGSize){80,40};
    }else{
        float width = (self.WIDTH-25)/4;
        return (CGSize){width,90};
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (collectionView == self.titleCollectionView) {
        return (CGSize){0,0};
    }else{
        return (CGSize){5,0};
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark UICollectionViewDelegate,UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SiteCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"titleReuse" forIndexPath:indexPath];
    NSDictionary *dic = self.dataArray[indexPath.row];
    cell.titleLabel.text = dic[@"configname"];
    return  cell;
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.titleCollectionView) {
        for (UICollectionView *view in [SiteSingle shareSingleton].viewArray) {
            view.contentOffset = scrollView.contentOffset;
        }
    }
}

#pragma mark Action

- (void)actionChooseDate:(UIButton *)btn{
    if (btn.selected) {
        return;
    }else{
        btn.selected = YES;
    }
    for (id obj in self.weekScrollView.subviews) {
        if ([obj isKindOfClass:[UIButton class]] && ![obj isEqual:btn]) {
            UIButton *button = obj;
            button.selected = NO;
        }
    }
    if (self.dataArray.count == 0) {
        [self chooseDate:btn.tag];
    }
}

- (void)chooseDate:(NSInteger)tag{
    float width = self.WIDTH/3;
    NSInteger rank = (tag-100)/3;
    NSInteger page = self.weekScrollView.contentOffset.x/self.WIDTH;
    float lineX = page*self.WIDTH + rank*width +2;
    UIView *line = [self.weekScrollView viewWithTag:9999];
    [UIView animateWithDuration:0.1 animations:^{
        line.frame = CGRectMake(lineX, 66, width-1, 3);
    }];
    [self.weekScrollView setContentOffset:CGPointMake(rank*self.WIDTH, 0) animated:NO];
    [self loadDataWithDate:self.dateArray[tag-100][@"date"]];
    [[SiteSingle shareSingleton].siteDic removeAllObjects];
}

- (void)loadDataWithDate:(NSString *)string{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"content" ofType:@"geojson"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data
                                           options:kNilOptions
                                             error:nil];
    for (NSDictionary *dic in result[@"datalist"]) {
        if (![dic isEqual:[NSNull null]]) {
            [self.dataArray addObject:dic];
        }
    }
    
    
    NSInteger count = 0;
    for (int i = 0; i < self.dataArray.count; i ++) {
        NSInteger value = [self.dataArray[i][@"config"]count];
        if (count < value) {
            count = value;
        }
    }
    
    for (int i = 0; i < self.dataArray.count; i ++) {
        NSInteger number = [self.dataArray[i][@"config"]count];
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.dataArray[i]];
        NSMutableArray *array = [NSMutableArray arrayWithArray:dic[@"config"]];
        if (number < count) {
            for (int j = 0; j < count - number; j++) {
                NSDictionary *dic = @{};
                [array addObject:dic];
            }
            [dic setValue:array forKey:@"config"];
            [self.dataArray replaceObjectAtIndex:i withObject:dic];
        }
    }
    [self.articleTableView reloadData];
    [self.titleCollectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
