
#import "SliderViewController.h"

#import "SliderTableViewCell.h"

#import "SliderHeadView.h"

#import "GeneralSingleton.h"

#import "Define.h"

@interface SliderViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) SliderHeadView *headView;
@property (nonatomic, strong) IBOutlet UITableView *articleTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation SliderViewController

- (void)dealloc{
    NSLog(@"Release--->%@",[self class]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    __weak typeof(self)weakSelf = self;

    _dataArray = [NSMutableArray array];
    
    [GeneralSingleton default].viewArray = [NSMutableArray array];
    
    _headView = [[SliderHeadView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 120)];
    _headView.action_handle = ^(NSString *date){
        if (weakSelf.dataArray.count == 0) {
            [weakSelf loadData:date];
        }
    };
    self.articleTableView.tableHeaderView = self.headView;
    self.articleTableView.contentInsetAdjustmentBehavior = false ;
    [self.articleTableView registerNib:[UINib nibWithNibName:@"SliderTableViewCell" bundle:nil] forCellReuseIdentifier:@"reuse"];
    
    NSString *string = [[GeneralSingleton default] getTimeStringWithDate:[NSDate date]];
    [self loadData:string];
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
    SliderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse forIndexPath:indexPath];

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

- (void)loadData:(NSString *)string{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"content" ofType:@"geojson"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data
                                           options:kNilOptions
                                             error:nil];
    NSMutableArray *contentArray = [NSMutableArray array];
    for (NSDictionary *dic in result[@"datalist"]) {
        if (![dic isEqual:[NSNull null]]) {
            [self.dataArray addObject:dic];
            [contentArray addObject:dic[@"configname"]];
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
    
    self.headView.contentArray = contentArray;
    [self.articleTableView reloadData];
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
