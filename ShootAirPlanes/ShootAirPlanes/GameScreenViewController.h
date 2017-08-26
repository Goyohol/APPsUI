//
//  GameScreenViewController.h
//  ShootAirPlanes
//
//  Created by RainHeroic Kung on 2017/8/25.
//  Copyright © 2017年 RainHeroic Kung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameScreenViewController : UIViewController

//想要的功能(代码块)发送指定内容
@property (nonatomic,copy)void (^sendDate)(NSString * jifen,BOOL isGameOver);

@end
