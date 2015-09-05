//
//  BKPersonBtn.h
//  BKWarChess
//
//  Created by 锄禾日当午 on 15/9/4.
//  Copyright (c) 2015年 B&K. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BKPersonBtn : UIButton

@property (nonatomic)BOOL canMove;

@property (nonatomic)BOOL canUp;
@property (nonatomic)BOOL canDown;
@property (nonatomic)BOOL canLeft;
@property (nonatomic)BOOL canRight;

+(instancetype)getBKPersonBtn;
-(void)btnMoveMethodWithFrame:(CGRect)frame TouchPoint:(CGPoint)touchPoint;
@end
