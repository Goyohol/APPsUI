//
//  GYHBulletView.h
//  ShootAirPlanes
//
//  Created by goyohol on 15/5/18.
//  Copyright (c) 2015年 goyohol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYHBulletView : UIImageView

//子弹 是否在屏幕上
@property (nonatomic,assign) BOOL isOnScreen;

//子弹速度
@property (nonatomic,assign) int speed;

@end
