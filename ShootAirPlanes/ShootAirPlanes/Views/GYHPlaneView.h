//
//  GYHPlaneView.h
//  ShootAirPlanes
//
//  Created by goyohol on 15/5/18.
//  Copyright (c) 2015年 goyohol. All rights reserved.
//

#import <UIKit/UIKit.h>

//玩家 移动方向的枚举
typedef enum :NSUInteger{
    Left = 1,
    Right,
} PlayerDirection;

//子弹的tag值
#define Bullet_tag 100

@interface GYHPlaneView : UIImageView

//是否在屏幕上(在：还活着   ；  不在：挂了)
@property (nonatomic,assign) BOOL isonscreen;

//是否 (状态)移动
@property (nonatomic,assign) BOOL ismoving;

//移动速度
@property (nonatomic,assign) int speed;

//移动方向
@property (nonatomic,assign) PlayerDirection direction;

//生命值
@property (nonatomic,assign) int livecount;

//发射子弹 方法
-(void)shootBullet:(UIView *)place; //子弹发射的 场地(为UIView 提供 发射场地)
//飞机爆炸
-(void)planeIsBooming;

@end
