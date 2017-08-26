//
//  GYHEnemyView.h
//  ShootAirPlanes
//
//  Created by goyohol on 15/5/18.
//  Copyright (c) 2015年 goyohol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYHEnemyView : UIImageView

//是否在屏幕上
@property (nonatomic,assign) BOOL isOnScreen;
//移动速度
@property (nonatomic,assign) CGFloat speed;

//生命值
@property (nonatomic,assign) int liveCount;


//爆炸
-(void)booming;

@end
