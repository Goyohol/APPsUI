//
//  RankListViewController.m
//  ShootAirPlanes
//
//  Created by RainHeroic Kung on 2017/8/26.
//  Copyright © 2017年 RainHeroic Kung. All rights reserved.
//

#import "RankListViewController.h"


#define screenW [UIScreen mainScreen].bounds.size.width  //屏宽
#define screenH [UIScreen mainScreen].bounds.size.height //屏高


@interface RankListViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UIButton * returnBtn;

@property (nonatomic,strong) UITableView * rankListTabV;
@property (nonatomic,strong) NSMutableArray * dataArray;

@end

@implementation RankListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    
    [self getAllDatas];
    
    [self setAllViews];
}
-(void)setAllViews {
    self.returnBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, screenW, 100)];
    self.returnBtn.backgroundColor = [UIColor colorWithRed:0.7 green:0.3 blue:0.8 alpha:0.35];
    [self.view addSubview:self.returnBtn];
    [self.returnBtn setTitle:@"返回" forState:UIControlStateNormal];
    [self.returnBtn addTarget:self action:@selector(returnBack) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel * titleLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, screenW, 50)];
    titleLB.text = @"玩家排行榜";
    titleLB.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLB];
    
    
    self.rankListTabV = [[UITableView alloc] initWithFrame:CGRectMake(0, 150, screenW, screenH-150) style:UITableViewStylePlain];
    self.rankListTabV.dataSource = self;
    self.rankListTabV.delegate = self;
    [self.view addSubview:self.rankListTabV];
}
-(void)returnBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75.f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    NSDictionary * dic = self.dataArray[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"NO.%ld %@",indexPath.row+1,dic[@"name"] ];
    cell.textLabel.font = [UIFont systemFontOfSize:25.f];
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"分数:%@",dic[@"score"] ];
    
    
    return cell;
}


-(void)getAllDatas {
    _dataArray = @[].mutableCopy;
    
    NSArray *sandboxpath= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //获取完整路径
    NSString *documentsDirectory = [sandboxpath objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"RankList.plist"];
    NSArray * plistDataArray = [[NSArray alloc] initWithContentsOfFile:plistPath];
    for (NSDictionary * dict in plistDataArray) {
        [_dataArray addObject:dict];
    }
    
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
