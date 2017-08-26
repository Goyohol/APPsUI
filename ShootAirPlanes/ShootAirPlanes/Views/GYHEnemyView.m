//
//  GYHEnemyView.m
//  ShootAirPlanes
//
//  Created by goyohol on 15/5/18.
//  Copyright (c) 2015年 goyohol. All rights reserved.
//

#import "GYHEnemyView.h"

@implementation GYHEnemyView

//重写init的方法
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        NSMutableArray * images = [[NSMutableArray alloc]init];
        for (int i = 1; i < 4; i++)
        {
            UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"baoza1_%d",i]];
            [images addObject:image];
        }
        //给每个敌机创建 对应的 爆炸动画图片组
        self.animationImages = images;
        self.animationRepeatCount = 1;
        self.animationDuration = 0.5f;
    }
    return self;
}

//创建敌机时，添加爆炸 方法
-(void)booming
{
    [self startAnimating];
    //先爆炸，后消失
    //延时 想要时间 后，调用选择器中的方法
    //参数1：消息(时间到了之后，需要调用的方法)
    //参数2：参数
    //参数3：延时时间   单位：秒
    [self performSelector:@selector(endBooming) withObject:nil afterDelay:0.4];
    
}

-(void)endBooming
{
    [self removeFromSuperview];
    self.isOnScreen = NO;//敌机不在屏幕上了
}

@end
