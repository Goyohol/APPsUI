//
//  GYHPlaneView.m
//  ShootAirPlanes
//
//  Created by goyohol on 15/5/18.
//  Copyright (c) 2015年 goyohol. All rights reserved.
//

#import "GYHPlaneView.h"
#import "GYHBulletView.h"   //包含子弹

@interface GYHPlaneView()
//创建一个数组，专门用来 ❤️❤️存储所有的子弹
@property (nonatomic,strong) NSMutableArray * bulletArray;

@end


@implementation GYHPlaneView

//懒加载 （实质：重写成员变量的get方法）使用的时候，才去加载
//用到懒加载,以后在使用成员变量的时候，必须通过点语法使用(不能使用带下划线的成员变量)
-(NSMutableArray *)bulletArray
{
    if (_bulletArray == nil)
    {
        _bulletArray = [[NSMutableArray alloc] init];
        // 在这儿写，创建的时候需要做的一些额外的事情(只在创建的时候，创建一次)
        
        //创建100个子弹
        for (int i = 0; i < 200; i++)
        {
            //创建 一个子弹对象
            GYHBulletView * bullet = [[GYHBulletView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
            //设置图片
            bullet.image = [UIImage imageNamed:@"zidan3.png"];
            
            //设置 初始化状态
            bullet.isOnScreen = NO;
            //设置 初始速度
            bullet.speed = 3;
            
            //设置子弹的tag值
            bullet.tag = Bullet_tag;
            
            //将子弹添加到数组
            [_bulletArray addObject:bullet];
        }
    }
    return _bulletArray;
}

//发射子弹
-(void)shootBullet:(UIView *)place
{
    //遍历子弹数组，找到(任何)一个不在屏幕上的子弹，发射出去
    for (GYHBulletView * bullet in self.bulletArray)
    {
        if (!bullet.isOnScreen) //子弹不(!)在屏幕上
        {
            //将子弹 显示在指定的位置
            bullet.center = CGPointMake(self.center.x+5, self.center.y - self.frame.size.height/2.0f-10);
            //放在屏幕上
            [place addSubview:bullet];
            
            //改变 子弹状态(在屏幕上)
            bullet.isOnScreen = YES;
            //设置子弹的tag值
            
            //拿到一个 就跳出
            break;
        }
    }
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        NSMutableArray * images = [[NSMutableArray alloc]init];
        for (int i = 1; i < 4; i ++)
        {
            UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"planeBaoza%d",i]];
            [images addObject:image];
        }
        self.animationImages = images;//播放的 动画数组
        self.animationRepeatCount = 1;  //播放次数
        self.animationDuration = 1.5f;  //播放时间
    }
    return self;
}

-(void)planeIsBooming   //播放动画
{
    [self startAnimating];
    [self performSelector:@selector(endBoom) withObject:nil afterDelay:1.5f];   //延时后
}
-(void)endBoom
{
    [self removeFromSuperview];     //移除
    self.isonscreen = NO;   //不再在界面上
}

@end
