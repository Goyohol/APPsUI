//
//  GameScreenViewController.m
//  ShootAirPlanes
//
//  Created by RainHeroic Kung on 2017/8/25.
//  Copyright © 2017年 RainHeroic Kung. All rights reserved.
//

#import "GameScreenViewController.h"



#import "GYHPlaneView.h"    //包含飞机
#import "GYHBulletView.h"   //包含子弹
#import "GYHEnemyView.h"    //包含敌机

#define screenW [UIScreen mainScreen].bounds.size.width //屏宽
#define screenH [UIScreen mainScreen].bounds.size.height    //屏高

#define Enemy_tag 200   //敌机的tag值
#define Enemy2_tag 300  //敌机2的tag
#define EnemyBoss_tag 400   //boss的tag
#define _player_tag 1000     //我方飞机的tag值


@interface GameScreenViewController ()
{
    //创建 玩家对象(全局)
    GYHPlaneView * _player;
    // 创建 定时器
    NSTimer * _timer;
    //积分器
    NSInteger count;
}
//敌机数组
@property (nonatomic,strong) NSMutableArray * enemyPlaneArray;
@property (nonatomic,strong) NSMutableArray * enemyPlaneArray2;
@property (nonatomic,strong) NSMutableArray * enemyPlaneArrayBoss;

@end



@implementation GameScreenViewController

#pragma mark - 懒加载
-(NSMutableArray *)enemyPlaneArray
{
    if (_enemyPlaneArray == nil)
    {
        _enemyPlaneArray = [[NSMutableArray alloc]init];
        //创建10个敌机
        for (int i = 0; i < 10; i++)
        {
            //创建敌机对象
            GYHEnemyView * enemyPlane = [[GYHEnemyView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
            //设置 图片
            enemyPlane.image = [UIImage imageNamed:@"diji"];
            //设置 状态
            enemyPlane.isOnScreen = NO;
            enemyPlane.speed = 2;
            enemyPlane.liveCount = 1;
            //设置tag值
            enemyPlane.tag = Enemy_tag;
            
            //添加敌机对象到到数组中
            [_enemyPlaneArray addObject:enemyPlane];
        }
        //创建5个 另一类型的敌机
        //        for (int i = 0; i < 5; i++)
        //        {
        //            GYHEnemyView * enemyPlane = [[GYHEnemyView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
        //            enemyPlane.image = [UIImage imageNamed:@"diji2"];
        //            enemyPlane.isOnScreen = NO;
        //            enemyPlane.speed = 1;
        //            enemyPlane.tag = Enemy2_tag;
        //
        //            [_enemyPlaneArray addObject:enemyPlane];
        //        }
    }
    return _enemyPlaneArray;
}
-(NSMutableArray *)enemyPlaneArray2 //2号战机
{
    if (_enemyPlaneArray2 == nil)
    {
        _enemyPlaneArray2 = [[NSMutableArray alloc]init];
        //创建5个 另一类型的敌机
        for (int i = 0; i < 10; i++)
        {
            GYHEnemyView * enemyPlane = [[GYHEnemyView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
            enemyPlane.image = [UIImage imageNamed:@"diji2"];
            enemyPlane.isOnScreen = NO;
            enemyPlane.speed = 1.2;
            enemyPlane.tag = Enemy2_tag;
            enemyPlane.liveCount = 2;
            
            [_enemyPlaneArray2 addObject:enemyPlane];
        }
    }
    return _enemyPlaneArray2;
}
-(NSMutableArray *)enemyPlaneArrayBoss      //BOSS战机
{
    if (_enemyPlaneArrayBoss == nil)
    {
        _enemyPlaneArrayBoss = [[NSMutableArray alloc]init];
        //创建1个 Boss敌机
        for (int i = 0; i < 1; i++)
        {
            GYHEnemyView * enemyPlane = [[GYHEnemyView alloc]initWithFrame:CGRectMake(0, 0, 140, 140)];
            enemyPlane.image = [UIImage imageNamed:@"dafeiji1"];
            enemyPlane.isOnScreen = NO;
            enemyPlane.speed = 0.5;
            enemyPlane.tag = EnemyBoss_tag;
            enemyPlane.liveCount = 20;
            
            [_enemyPlaneArrayBoss addObject:enemyPlane];
        }
    }
    return _enemyPlaneArrayBoss;
}



#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1.创建界面
    [self creatUI];
    
    //2.启动定时器
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(gameLoop) userInfo:nil repeats:YES];
    
}
#pragma mark - 创建界面
-(void)creatUI
{
    //===============背景图============
    UIImageView * background = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    NSMutableArray * backgroudArr = [[NSMutableArray alloc]init];
    for (int i = 1; i < 3; i++)
    {
        UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"bg_0%d.jpg",i]];
        [backgroudArr addObject:image];
    }
    [background setAnimationImages:backgroudArr];//数组画面添加到背景view
    [background setAnimationDuration:5];    //播放时间
    [background setAnimationRepeatCount:0];  //播放次数
    [background startAnimating];    //启动 播放画面
    
    [self.view addSubview:background];
    //=================显示生命值=================
    //显示生命值
    UILabel * liveLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 80, 80, 40)];
    liveLabel.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.2];
    [liveLabel setTextAlignment:NSTextAlignmentCenter];
    [liveLabel setText:[NSMutableString stringWithFormat: @"生命:3"]];
    liveLabel.tag = 1;  //设置tag值
    [self.view addSubview:liveLabel];
    [self.view bringSubviewToFront:liveLabel];
    
    
    //==================创建玩家(飞机)=================
    //创建对象，并实例化
    _player = [[GYHPlaneView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    _player.center = CGPointMake(screenW/2.0f, screenH - 100);
    //设置图片
    _player.image = [UIImage imageNamed:@"feiji.png"];
    //设置初始状态
    _player.ismoving = NO;  //不可移动
    _player.isonscreen = YES;   //是在屏上
    //设置初始速度
    _player.speed = 3.5;
    //初始生命值
    _player.livecount = 3;
    _player.tag = _player_tag;
    //展示在界面上
    [self.view addSubview:_player];
    
    //=================创建一个大的 BOSS敌机===============
    //    sleep(2);
    //    GYHEnemyView * bossPlane = [[GYHEnemyView alloc]initWithFrame:CGRectMake((screenW-150)/2.0f, 20, 150, 150)];
    //    bossPlane.image = [UIImage imageNamed:@"dafeiji1"];
    //    bossPlane.tag = EnemyBoss_tag;
    //    [self.view addSubview:bossPlane];
    
    //====================积分器(label)======================
    count = 0;
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 150, 20)];
    label.backgroundColor = [UIColor colorWithRed:1 green:0 blue:1 alpha:0.2];
    [label setTextAlignment:NSTextAlignmentCenter];
    label.text = @"积分:0";
    [self.view addSubview:label];
    [self.view bringSubviewToFront:label];
    label.tag = 10;
    
    
    //===============按钮(左 右)===============
    //创建对象              左按钮
    UIButton * leftbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, screenH-100, 100, 100)];
    //    leftbutton.center = CGPointMake(screenW/4.0f, screenH-100);
    [leftbutton setImage:[UIImage imageNamed:@"button_left"] forState:UIControlStateNormal];
    //按下 事件
    [leftbutton addTarget:self action:@selector(planeStartMove:) forControlEvents:UIControlEventTouchDown];
    //弹起 事件
    [leftbutton addTarget:self action:@selector(planeEndMove:) forControlEvents:UIControlEventTouchUpInside];
    //显示在界面上
    [self.view addSubview:leftbutton];
    [self.view bringSubviewToFront:leftbutton];
    //设置tag值
    leftbutton.tag = Left;
    
    //创建对象              右按钮
    UIButton * rightbutton = [[UIButton alloc]initWithFrame:CGRectMake(screenW-100, screenH-100, 100, 100)];
    [rightbutton setImage:[UIImage imageNamed:@"button_right"] forState:UIControlStateNormal];
    [rightbutton addTarget:self action:@selector(planeStartMove:) forControlEvents:UIControlEventTouchDown];
    [rightbutton addTarget:self action:@selector(planeEndMove:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightbutton];
    [self.view bringSubviewToFront:rightbutton];
    //设置tag值
    rightbutton.tag = Right;
    
    //创建对象          暂停
    UIButton * stopbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 40, 40, 40)];
    [stopbutton setImage:[UIImage imageNamed:@"zanting"] forState:UIControlStateNormal];
    [stopbutton addTarget:self action:@selector(stopall:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stopbutton];
    [self.view bringSubviewToFront:stopbutton];
    
    //创建对象          开始
    UIButton * startbutton = [[UIButton alloc]initWithFrame:CGRectMake(40, 40, 40, 40)];
    startbutton.backgroundColor = [UIColor colorWithRed:0.5f green:0.2f blue:0.3f alpha:0.3f];
    [startbutton setImage:[UIImage imageNamed:@"jixu"] forState:UIControlStateNormal];
    [startbutton addTarget:self action:@selector(startall:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startbutton];
    [self.view bringSubviewToFront:startbutton];
    
    
    
    //创建对象              退出
    UIButton * quitbutton = [[UIButton alloc]initWithFrame:CGRectMake(screenW-50, 20, 50, 30)];
    quitbutton.backgroundColor = [UIColor colorWithRed:0 green:1 blue:1 alpha:0.3];
    [quitbutton setTitle:@"退出" forState:UIControlStateNormal];
    [quitbutton addTarget:self action:@selector(quitGame:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:quitbutton];
    
//    //创建对象              重来
//    UIButton * restartbutton = [[UIButton alloc]initWithFrame:CGRectMake(screenW-50, 20, 50, 30)];
//    restartbutton.backgroundColor = [UIColor colorWithRed:0 green:1 blue:1 alpha:0.3];
//    [restartbutton setTitle:@"重来" forState:UIControlStateNormal];
//    [restartbutton addTarget:self action:@selector(restartall:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:restartbutton];
}

#pragma mark - 点击按钮
//开始移动
-(void)planeStartMove:(UIButton *)button
{
    //让 玩家(飞机)移动
    _player.ismoving = YES;
    //设置  移动方向❤️❤️❤️
    _player.direction = button.tag;
}
//停止移动
-(void)planeEndMove:(UIButton *)button
{
    //让 玩家(飞机)不移动
    _player.ismoving = NO;
}
//暂停
-(void)stopall:(UIButton *)button
{
    [_timer setFireDate:[NSDate distantFuture]];
}
//开始
-(void)startall:(UIButton *)button
{
    //    GYHPlaneView * view = (GYHPlaneView *)[self.view viewWithTag:_player_tag];  //自定制
    if (_player.isonscreen)    //在活着状态才可以  暂停后继续❤️❤️
    {
        [_timer setFireDate:[NSDate distantPast]];
    }
}
//重来
-(void)restartall:(UIButton *)button
{
    [self viewDidLoad]; //重来之后，积分器不起作用
    //    [self creatUI];
    //    [_timer setFireDate:[NSDate distantPast]];
}
//退出游戏
-(void)quitGame:(UIButton *)button {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - gameLoop
-(void)gameLoop
{
    static long time = 0;
    time ++;
    
    //1.让玩家移动
    [self playerMove];
    //2.发射子弹    (定时器❤️的 计时值)
    if (time%10 == 0)   //每过20X0.01秒发射一次
    {
        [_player shootBullet:self.view];
    }
    
    //3.让子弹飞
    [self bulletFly];
    
    //4.敌机出现
    
    if (time % 100 == 0)    //每过100X0.01秒 出现一艘敌机
    {
        time = 0;   //避免内存浪费 计时清零？？？？？❤️❤️
        [self creatEnemy];
    }
    //5.敌机前进(进攻)
    [self enemyAttack];
    
}

#pragma mark - 敌机进攻
-(void)enemyAttack
{
    NSArray * subViews = [self.view subviews];
    for (UIView * subView in subViews)
    {
        
        //拿到敌机
        if (subView.tag == Enemy_tag||subView.tag == Enemy2_tag||subView.tag == EnemyBoss_tag)
        {
            GYHEnemyView * enemyPlane = (GYHEnemyView *)subView;
            //改变y坐标
            CGRect enemyRect = enemyPlane.frame;
            enemyRect.origin.y += enemyPlane.speed;
            
            //更新位置
            enemyPlane.frame = enemyRect;
            
            //判断飞机 是否和子弹 相撞
            //a.遍历所有子弹
            for (UIView * subView2 in subViews)
            {
                if (subView2.tag == Bullet_tag) //取所有子弹
                {
                    GYHBulletView * bullet = (GYHBulletView *)subView2;
                    //b.判断子弹与敌机 是否有交集
                    if (CGRectIntersectsRect(enemyPlane.frame, bullet.frame))   //打中敌机
                    {
                        
                        [bullet removeFromSuperview];//子弹消失
                        bullet.isOnScreen = NO;
                        enemyPlane.liveCount --;
                        //                        NSLog(@"%d",enemyPlane.liveCount);
                        if (enemyPlane.liveCount == 0)
                        {
                            [enemyPlane booming]; //爆炸效果
                            
                            if (enemyPlane.tag == Enemy_tag)
                            {
                                count +=1;//得到相应积分
                            }
                            else if (enemyPlane.tag == Enemy2_tag)
                            {
                                count +=5;
                            }
                            else if (enemyPlane.tag == EnemyBoss_tag)
                            {
                                count += 20;
                                //                                enemyPlane.liveCount = 20;
                            }
                            UILabel * label1 = (UILabel *)[self.view viewWithTag:10];
                            label1.text = [NSString stringWithFormat:@"积分:%ld",count];//打印积分
                            [self.view bringSubviewToFront:label1];
                            
                            break;//找到一个打死的敌机(打死一次)，就行了
                        }
                    }
                }
                
                //敌机 撞到我方飞机
                if (subView2.tag == _player_tag)
                {
                    //  GYHPlaneView * player = (GYHPlaneView *)subView2;
                    //            player.livecount = 3;
                    CGRect rect1 = enemyPlane.frame;
                    rect1.size.width = enemyPlane.frame.size.width;
                    rect1.size.height = enemyPlane.frame.size.height;
                    //rect1.size.width = enemyPlane.frame.size.width/1.6f;//❤️视觉效果(延迟相碰的时间)
                    //rect1.size.height = enemyPlane.frame.size.height/2.0f;
                    CGRect rect2 = _player.frame;
                    rect2.size.width = _player.frame.size.width;
                    rect2.size.height = _player.frame.size.height;
                    //rect2.size.width = _player.frame.size.width;
                    //rect2.size.height = _player.frame.size.height/2.0f;
                    
                    if (CGRectIntersectsRect(rect1,rect2)) //有交集
                    {
                        _player.livecount --;
                        if (_player.livecount!=0)
                        {   //生命值减1，不是0
                            [enemyPlane removeFromSuperview];
                            enemyPlane.isOnScreen = NO;
                            UILabel * labellive = [self.view viewWithTag:1];
                            labellive.text = [NSMutableString stringWithFormat:@"生命:%d",_player.livecount];
                            
                        }
                        // NSLog(@"%d",_player.livecount);
                        [enemyPlane booming];//敌机 爆炸
                        
                        if (_player.livecount == 0)
                        {   //生命值减为0
                            [_player planeIsBooming];//自己飞机爆炸效果
                            UILabel * labellive = [self.view viewWithTag:1];
                            labellive.text = [NSMutableString stringWithFormat:@"生命:0"];
                            //关闭定时器
                            [_timer setFireDate:[NSDate distantFuture]];
                            //从屏幕删除所有的子视图
                            for (UIView * allview in subViews)
                            {
                                if (allview.tag == Bullet_tag||allview.tag == Enemy_tag||allview.tag == Enemy2_tag||allview.tag == EnemyBoss_tag)
                                {
                                    [allview removeFromSuperview];
                                }
                            }
                            _player.isonscreen = 0; //飞机不在屏幕上
                            //打印 gameover
                            [self gameover];
                        }
                    }
                }
            }
            
            
            //判断是否飞出屏幕
            if (enemyRect.origin.y > screenH)
            {
                [enemyPlane removeFromSuperview];
                enemyPlane.isOnScreen = NO;
            }
        }
    }
    
}

#pragma mark - gameover
-(void)gameover
{
    UILabel * label_jifen = (UILabel *)[self.view viewWithTag:10];
    NSString * jifenStr = [label_jifen.text componentsSeparatedByString:@":"][1];
    __weak typeof(self) weakSelf = self; //在block里面 使用的话 weak修饰self
    [self dismissViewControllerAnimated:YES completion:^{
        weakSelf.sendDate(jifenStr,YES);
    }];
}


#pragma mark - 敌机出现
-(void)creatEnemy
{
    //在敌机数组中，找到一个 不在屏幕上的敌机，显示在屏幕上
    for (GYHEnemyView * enemyPlane in self.enemyPlaneArray)
    {
        if (!enemyPlane.isOnScreen) //不在屏幕上
        {
            //x:0 ~ 屏宽-敌机宽度
            //改变 坐标
            enemyPlane.frame = CGRectMake(arc4random()%(int)(screenW-enemyPlane.frame.size.width), 0, enemyPlane.frame.size.width, enemyPlane.frame.size.height);
            
            [self.view addSubview:enemyPlane];  //显示在屏幕上
            enemyPlane.isOnScreen = YES;    //改变状态 （变为在屏上）
            enemyPlane.liveCount = 1;  //创建飞机对象时就带入生命值❤️❤️
            break;
        }
    }
    for (GYHEnemyView * enemyPlane in self.enemyPlaneArray2)
    {
        
        if (!enemyPlane.isOnScreen) //不在屏幕上
        {
            //x:0 ~ 屏宽-敌机宽度
            //改变 坐标
            enemyPlane.frame = CGRectMake(arc4random()%(int)(screenW-enemyPlane.frame.size.width), 0, enemyPlane.frame.size.width, enemyPlane.frame.size.height);
            [self.view addSubview:enemyPlane];  //显示在屏幕上
            enemyPlane.isOnScreen = YES;    //改变状态 （变为在屏上）
            enemyPlane.liveCount =3;//创建飞机对象时就带入生命值❤️❤️
            break;  //找到一个敌机  ，就可以退出
        }
    }
    for (GYHEnemyView * enemyPlane in self.enemyPlaneArrayBoss)
    {
        
        if (!enemyPlane.isOnScreen) //(只有❤️一架❤️)没有在屏幕上
        {
            //x:0 ~ 屏宽-敌机宽度
            //改变 坐标
            enemyPlane.frame = CGRectMake(arc4random()%(int)(screenW-enemyPlane.frame.size.width), 0, enemyPlane.frame.size.width, enemyPlane.frame.size.height);
            [self.view addSubview:enemyPlane];  //显示在屏幕上
            enemyPlane.isOnScreen = YES;    //改变状态 （变为在屏上）
            enemyPlane.liveCount = 20;//创建飞机对象时就带入生命值❤️❤️
            break;  //找到一个敌机  ，就可以退出
        }
    }
    
}
#pragma mark - 让子弹飞
-(void)bulletFly
{
    //拿到屏幕上 所有的子弹
    NSArray * subViews = [self.view subviews];
    for (UIView * subview in subViews)
    {
        if (subview.tag == Bullet_tag)
        {
            //拿到子弹
            GYHBulletView * bullet = (GYHBulletView *)subview;
            //改变子弹的y坐标
            CGRect rect = bullet.frame;
            rect.origin.y -= bullet.speed;
            //刷新坐标
            bullet.frame = rect;
            
            //判断子弹是否 飞出屏幕
            if (rect.origin.y - rect.size.height < 0)
            {
                //从屏幕上 将子弹移除    （❤️ ❔从内存中删除）
                [bullet removeFromSuperview];
                bullet.isOnScreen = NO;
            }
        }
    }
}

#pragma mark - 玩家移动
-(void)playerMove
{
    //判断玩家是否能移动
    if (_player.ismoving)
    {
        CGRect rect = _player.frame;
        //向左移动
        if (_player.direction == Left)
        {
            rect.origin.x -= _player.speed;
        }
        else    //向右移动
        {
            rect.origin.x += _player.speed;
        }
        //边界判断
        if (!(rect.origin.x <=0 || rect.origin.x + rect.size.width >= screenW)) //判断   在 ❤️没有(!)超出边界❤️ 的时候
        {
            //位置更新
            _player.frame = rect;
        }
        
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
