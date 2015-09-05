//
//  BKPersonBtn.m
//  BKWarChess
//
//  Created by 锄禾日当午 on 15/9/4.
//  Copyright (c) 2015年 B&K. All rights reserved.
//

#import "BKPersonBtn.h"
#import "UIView+Extension.h"

@implementation BKPersonBtn

/**人物--1*/
+(instancetype)getBKPersonBtnWithImageName:(NSString *)image
{
    CGRect rect = CGRectMake(0, 0, 40, 40);
    BKPersonBtn *btn = [[self alloc] initWithFrame:rect];
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    btn.category = 1;
    return btn;
}

/**小精灵--2*/
+(instancetype)getSpriteBtnWithImageName:(NSString *)image
{
    CGRect rect = CGRectMake(0, 0, 50, 50);
    BKPersonBtn *btn = [[self alloc] initWithFrame:rect];
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    btn.userInteractionEnabled = NO;
    btn.category = 2;
    return btn;
}

/**小精灵--2*/
+(instancetype)getRandomSprite
{
    NSArray *spriteArray = @[@"bikaqiu",@"dragon",@"flag"];
    NSArray *spriteLevel = @[@"Lv.1",@"Lv.2",@"Lv.1"];
    int random = arc4random_uniform(spriteArray.count);
    CGRect rect = CGRectMake(0, 0, 50, 50);
    BKPersonBtn *btn = [[self alloc] initWithFrame:rect];
    [btn setBackgroundImage:[UIImage imageNamed:spriteArray[random]] forState:UIControlStateNormal];
    [btn setTitle:spriteLevel[random] forState:UIControlStateNormal];
    btn.userInteractionEnabled = NO;
    btn.category = 2;
    return btn;
}


/**进化石--3*/
+(instancetype)getMegaBtn
{
    CGRect rect = CGRectMake(0, 0, 40, 40);
    BKPersonBtn *btn = [[self alloc] initWithFrame:rect];
    [btn setBackgroundImage:[UIImage imageNamed:@"mega"] forState:UIControlStateNormal];
    btn.userInteractionEnabled = NO;
    btn.category = 3;
    return btn;
}

//判断移动并执行移动
-(void)btnMoveMethodWithFrame:(CGRect)frame TouchPoint:(CGPoint)touchPoint
{
    CGFloat MoveDistance = frame.size.width / 4;
    if(self.centerX >= CGRectGetMaxX(frame)){
        self.canRight = NO;
    }else{
        self.canRight = YES;
    }
    if(self.centerX <= CGRectGetMinX(frame)){
        self.canLeft = NO;
    }else{
        self.canLeft = YES;
    }
    if(self.centerY >= CGRectGetMaxY(frame)){
        self.canDown = NO;
    }else{
        self.canDown = YES;
    }
    if(self.centerY <= CGRectGetMinY(frame)){
        self.canUp = NO;
    }else{
        self.canUp = YES;
    }
    
    if(self.canMove){
        self.isMoved = NO;
        CGFloat duration = 0.5;
        if(fabs(touchPoint.x-self.x)>=fabs(touchPoint.y-self.y)){
            if(touchPoint.x < self.x&&self.canLeft){
                [UIView animateWithDuration:duration animations:^{
                    self.x -= MoveDistance;
                    self.i--;
                    self.isMoved = YES;
                    self.canMove = false;
                }];
            }
            if(touchPoint.x > self.x&&self.canRight){
                [UIView animateWithDuration:duration animations:^{
                    self.x += MoveDistance;
                    self.i++;
                    self.isMoved = YES;
                    self.canMove = false;
                }];
            }
            
        }else{
            if(touchPoint.y < self.y&&self.canUp){
                [UIView animateWithDuration:duration animations:^{
                    self.y -= MoveDistance;
                    self.j--;
                    self.isMoved = YES;
                    self.canMove = false;
                }];
            }
            if(touchPoint.y > self.y&&self.canDown){
                [UIView animateWithDuration:duration animations:^{
                    self.y += MoveDistance;
                    self.j++;
                    self.isMoved = YES;
                    self.canMove = false;
                }];
            }
        }
        
    }

}

@end
