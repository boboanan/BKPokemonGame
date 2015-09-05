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

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self setBackgroundImage:[UIImage imageNamed:@"circle_a"] forState:UIControlStateNormal];
    }
    return self;
    
}

+(instancetype)getBKPersonBtn
{
   CGRect rect = CGRectMake(0, 0, 40, 40);
    return [[self alloc] initWithFrame:rect];
}

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
        
        CGFloat duration = 0.5;
        if(fabs(touchPoint.x-self.x)>=fabs(touchPoint.y-self.y)){
            if(touchPoint.x < self.x&&self.canLeft){
                [UIView animateWithDuration:duration animations:^{
                    self.x -= MoveDistance;
                }];
            }
            if(touchPoint.x > self.x&&self.canRight){
                [UIView animateWithDuration:duration animations:^{
                    self.x += MoveDistance;
                }];
            }
            self.canMove = false;
        }else{
            if(touchPoint.y < self.y&&self.canUp){
                [UIView animateWithDuration:duration animations:^{
                    self.y -= MoveDistance;
                }];
            }
            if(touchPoint.y > self.y&&self.canDown){
                [UIView animateWithDuration:duration animations:^{
                    self.y += MoveDistance;
                }];
            }
            self.canMove = false;
        }
        
    }

}

@end
