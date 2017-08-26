//
//  ViewController.m
//  ShootAirPlanes
//
//  Created by goyohol on 15/5/18.
//  Copyright (c) 2015年 goyohol. All rights reserved.
//



#import "ViewController.h"

#import "MBProgressHUD.h"

#import "RankListViewController.h"
#import "GameScreenViewController.h"


#import "GYHPlaneView.h"    //包含飞机
#import "GYHBulletView.h"   //包含子弹

#define screenW [UIScreen mainScreen].bounds.size.width  //屏宽
#define screenH [UIScreen mainScreen].bounds.size.height //屏高

@interface ViewController () <UIAlertViewDelegate>
{
    //玩家图片
    GYHPlaneView * _player;
    
    //游戏结束图片
    UIImageView * _gameOver_ImgV;
    //积分Label
    UILabel * _jifenLabel;
    
    
    int _indexWhereAdd; //插入的位置
}


@property (weak, nonatomic) IBOutlet UIButton *startGameBtn;
@property (weak, nonatomic) IBOutlet UIImageView *bgImgV;



@property (weak, nonatomic) IBOutlet UILabel *gameTitleLB;
@property (nonatomic,assign) BOOL isNotFirstTimeStartGame;



@property (nonatomic,assign) BOOL isGameOver;
@property (nonatomic,strong) NSString * jifenStr;
@property (nonatomic,strong) NSString * nameStr;

@end




@implementation ViewController
-(BOOL)prefersStatusBarHidden {
    return YES;// 返回YES表示隐藏，返回NO表示显示
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.gameTitleLB.adjustsFontSizeToFitWidth = YES;
    
    if (_isGameOver == YES) {
        _jifenLabel.hidden = NO;
        self.gameTitleLB.hidden = YES;
        _player.hidden = YES;
    } else {
        _jifenLabel.hidden = YES;
        self.gameTitleLB.hidden = NO;
        _player.hidden = NO;
    }
    
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    _jifenStr = @"";
    _isGameOver = NO;
    
    _gameOver_ImgV.image = nil;
    
    
    _isNotFirstTimeStartGame = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self allViewsSetting];
}

-(void)allViewsSetting {
    self.startGameBtn.layer.masksToBounds = YES;
    self.startGameBtn.layer.cornerRadius = CGRectGetHeight(self.startGameBtn.frame)/2.f;
    
    
    
    NSMutableArray * backgroudArr = [[NSMutableArray alloc]init];
    for (int i = 1; i < 3; i++) {
        UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"bg_0%d.jpg",i]];
        [backgroudArr addObject:image];
    }
    
    [self.bgImgV setAnimationImages:backgroudArr];//数组画面添加到背景view
    [self.bgImgV setAnimationDuration:3];    //播放时间
    [self.bgImgV setAnimationRepeatCount:0];  //播放次数
    [self.bgImgV startAnimating];    //启动 播放画面

    
    
    //创建对象，并实例化
    _player = [[GYHPlaneView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    _player.center = CGPointMake(screenW/2.0f, screenH - 200);
    //设置图片
    _player.image = [UIImage imageNamed:@"feiji.png"];
    //设置初始状态
    _player.ismoving = NO;  //不可移动
    _player.isonscreen = YES;   //是在屏上
    [self.view addSubview:_player];
    
    
    
    UIButton * ranklistBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, screenW/3.f, 50)];
    ranklistBtn.center = CGPointMake(screenW/2.f, 80);
    [self.view addSubview:ranklistBtn];
    [ranklistBtn setTitle:@"查看排行榜" forState:UIControlStateNormal];
    [ranklistBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [ranklistBtn addTarget:self action:@selector(clickToSeeRankList) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)clickToSeeRankList {
    RankListViewController * rankListVC = [[RankListViewController alloc] init];
    [self presentViewController:rankListVC animated:YES completion:^{ }];
    
}



-(void)gameOver {
    //打印gameover
    UIImage * image = [UIImage imageNamed:@"over.gif"];
    _gameOver_ImgV = [[UIImageView alloc] initWithImage:image];
    _gameOver_ImgV.center = CGPointMake(screenW/2.0f, screenH/2.0f);
    [self.view addSubview:_gameOver_ImgV];
    
    
    _jifenLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    [self.view addSubview:_jifenLabel];
    _jifenLabel.backgroundColor = [UIColor colorWithRed:1 green:0 blue:1 alpha:0.2];
    _jifenLabel.textAlignment = NSTextAlignmentCenter;
    _jifenLabel.text = [NSString stringWithFormat:@"所得的分数:%@",_jifenStr];
    
    
    
    //积分进行排行
    [self refrenshRankList];
}
-(void)refrenshRankList {
    _jifenStr = _jifenStr?_jifenStr:@"0";
    
    NSArray *sandboxpath= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //获取完整路径
    NSString *documentsDirectory = [sandboxpath objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"RankList.plist"];
   
    BOOL hasTheRightPlist = NO;  //文档路径下 是否含有plist文件
    
    NSFileManager * fileManger = [NSFileManager defaultManager];
    NSArray * dirArray = [fileManger contentsOfDirectoryAtPath:documentsDirectory error:nil];
    for (NSString * str in dirArray) { //遍历文件夹
        if ([str isEqualToString:@"RankList.plist"]) {
            hasTheRightPlist = YES;
        }
    }
    
    if (hasTheRightPlist == YES) {
        NSArray * plistArray = [[NSArray alloc] initWithContentsOfFile:plistPath];

        for (int i = 0; i < plistArray.count; i++) {
            NSDictionary * dict = plistArray[i];
            
            NSLog(@"%ld  %ld",[_jifenStr integerValue],[dict[@"score"] integerValue]);
            //比较 历史积分、当前积分  进行排行
            if([_jifenStr integerValue] > [dict[@"score"] integerValue] ) {//大于 插入
                
                UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:@"提交分数" message:@"恭喜进入排行榜" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
                [alertV setAlertViewStyle:UIAlertViewStylePlainTextInput];
                UITextField * textName = [alertV textFieldAtIndex:0];
                textName.placeholder = @"请输入名字";
                textName.clearButtonMode = UITextFieldViewModeWhileEditing;
                [alertV show];
                alertV.tag = 0;
                
                _indexWhereAdd = i;
                
    
                break;
            } else { //小于
                if (i == plistArray.count-1 && plistArray.count < 10) { //最后一位时
                    
                    UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:@"提交分数" message:@"恭喜进入排行榜" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
                    [alertV setAlertViewStyle:UIAlertViewStylePlainTextInput];
                    UITextField * textName = [alertV textFieldAtIndex:0];
                    textName.placeholder = @"请输入名字";
                    textName.clearButtonMode = UITextFieldViewModeWhileEditing;
                    [alertV show];
                    alertV.tag = 1;
                    
                    _indexWhereAdd = i;
                    
                    
                    break;
                }
                
            }
        }
    } else {
        
        UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:@"提交分数" message:@"恭喜进入排行榜" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
        [alertV setAlertViewStyle:UIAlertViewStylePlainTextInput];
        UITextField * textName = [alertV textFieldAtIndex:0];
        textName.placeholder = @"请输入名字";
        textName.clearButtonMode = UITextFieldViewModeWhileEditing;
        [alertV show];
        alertV.tag = 2;
        
        
        //文件夹下，不存在plist文件  直接添加，比对要创建plist文件
        
    }
    
}
#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    UITextField * textName = [alertView textFieldAtIndex:0];
    _nameStr = textName.text;
    
    
    if (buttonIndex == 0 && _nameStr.length > 0) { //确认按钮
        
        NSArray *sandboxpath= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //获取完整路径
        NSString *documentsDirectory = [sandboxpath objectAtIndex:0];
        NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"RankList.plist"];
        
        NSArray * plistArray = [[NSArray alloc] initWithContentsOfFile:plistPath];
        
        
        NSMutableArray * addToPlistArr; //存储的数组
        if (plistArray) {
            addToPlistArr = plistArray.mutableCopy;
        } else { //plist数组 不存在
            addToPlistArr = @[].mutableCopy;
        }
        NSDictionary * addDict = @{
                                   @"score":_jifenStr,
                                   @"name":_nameStr
                                   };
        switch (alertView.tag) {
            case 0:{
                [addToPlistArr insertObject:addDict atIndex:_indexWhereAdd];
                if (addToPlistArr.count > 10) { //超过10位，移除最后一位
                    [addToPlistArr removeObjectAtIndex:(addToPlistArr.count-1)];
                }
                
                if ([addToPlistArr writeToFile:plistPath atomically:YES]) {
                    NSLog(@"将数组保存为属性列表文件成功！！");
                }else{
                    NSLog(@"将数组保存为属性列表文件不成功");
                }
            }break;
            case 1:{
                [addToPlistArr addObject:addDict];
                
                if ([addToPlistArr writeToFile:plistPath atomically:YES]) {
                    NSLog(@"将数组保存为属性列表文件成功！！");
                }else{
                    NSLog(@"将数组保存为属性列表文件不成功");
                }
            }break;
            case 2:{ //文件夹下，不存在plist文件  直接添加，必定要先创建plist文件
                [addToPlistArr addObject:addDict];
                
                if ([addToPlistArr writeToFile:plistPath atomically:YES]) {
                    NSLog(@"将数组保存为属性列表文件成功！！");
                    return;
                }else{
                    NSLog(@"将数组保存为属性列表文件不成功");
                }
            }break;
            default:
                break;
        }
        
    } else {
        //只显示文字
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"选择默默无闻，分数不保存";
        hud.margin = 10.f;
        hud.offset = CGPointMake(0, -60.f);
        hud.removeFromSuperViewOnHide = YES;
        [hud hideAnimated:YES afterDelay:1.5f];
        
    }
    //    NSLog(@"%ld",buttonIndex);
}
-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    
}





- (IBAction)clickToStartGame:(id)sender {
    GameScreenViewController * gameScreenVC = [[GameScreenViewController alloc] init];
    gameScreenVC.sendDate = ^(NSString * jifen,BOOL isGameOver) {
        
        _jifenStr = jifen;
        _isGameOver = isGameOver;
        
        if (_isGameOver == YES) {
            [self gameOver];
            _player.hidden = YES;
            self.gameTitleLB.hidden = YES;
        } else {
            _player.hidden = NO;
        }
    };
    
    
    [self presentViewController:gameScreenVC animated:YES completion:^{ }];
    
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
