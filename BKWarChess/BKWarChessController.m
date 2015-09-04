//
//  BKWarChessController.m
//  BKWarChess
//
//  Created by 锄禾日当午 on 15/9/4.
//  Copyright (c) 2015年 B&K. All rights reserved.
//

#import "BKWarChessController.h"
#import "UIView+Extension.h"
#import "BKPersonBtn.h"

#define MoveDistance self.map.bounds.size.height/4
#define ContentDistance 10
@interface BKWarChessController ()

@property (weak, nonatomic) UIImageView *map;
@property (weak, nonatomic) BKPersonBtn *personBtn;

@property (weak, nonatomic) UIButton * portraitBtnA;

@end

@implementation BKWarChessController

-(UIImageView *)map
{
    if(_map == nil){
        CGRect rect = [UIScreen mainScreen].bounds;
        UIImageView *map = [[UIImageView alloc] init];
        map.frame = CGRectMake(0, 0, 225, 225);
        map.image = [UIImage imageNamed:@"map"];
        map.center = CGPointMake(rect.size.width / 2, rect.size.height / 2);
        [self.view addSubview:map];
        _map = map;
    }
    return _map;
}

-(BKPersonBtn *)personBtn
{
    if(_personBtn == nil){
        BKPersonBtn *btn = [BKPersonBtn getBKPersonBtn];
        btn.center = CGPointMake(CGRectGetMaxX(self.map.frame), CGRectGetMaxY(self.map.frame));
        [btn addTarget:self action:@selector(personMove) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        _personBtn = btn;
    }
    return _personBtn;
}

-(void)personMove
{
    self.personBtn.canMove = !self.personBtn.canMove;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
        if(self.personBtn.centerX >= CGRectGetMaxX(self.map.frame)){
            self.personBtn.canRight = NO;
        }else{
            self.personBtn.canRight = YES;
        }
        if(self.personBtn.centerX <= CGRectGetMinX(self.map.frame)){
            self.personBtn.canLeft = NO;
        }else{
            self.personBtn.canLeft = YES;
        }
        if(self.personBtn.centerY >= CGRectGetMaxY(self.map.frame)){
            self.personBtn.canDown = NO;
        }else{
            self.personBtn.canDown = YES;
        }
        if(self.personBtn.centerY <= CGRectGetMinY(self.map.frame)){
            self.personBtn.canUp = NO;
        }else{
            self.personBtn.canUp = YES;
        }
    
    if(self.personBtn.canMove){
        UITouch *touch = [touches anyObject];
        
        CGPoint touchPoint = [touch locationInView:self.view];
        //touchPoint.x ，touchPoint.y 就是触点的坐标。
        
        CGFloat duration = 0.5;
        if(fabs(touchPoint.x-self.personBtn.x)>=fabs(touchPoint.y-self.personBtn.y)){
            if(touchPoint.x < self.personBtn.x&&self.personBtn.canLeft){
                [UIView animateWithDuration:duration animations:^{
                    self.personBtn.x -= MoveDistance;
                }];
            }
            if(touchPoint.x > self.personBtn.x&&self.personBtn.canRight){
                [UIView animateWithDuration:duration animations:^{
                    self.personBtn.x += MoveDistance;
                }];
            }
            self.personBtn.canMove = false;
        }else{
            if(touchPoint.y < self.personBtn.y&&self.personBtn.canUp){
                [UIView animateWithDuration:duration animations:^{
                    self.personBtn.y -= MoveDistance;
                }];
            }
            if(touchPoint.y > self.personBtn.y&&self.personBtn.canDown){
                [UIView animateWithDuration:duration animations:^{
                    self.personBtn.y += MoveDistance;
                }];
            }
            self.personBtn.canMove = false;
        }
        
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    [self setUpUI];
}

-(void)setUpUI
{
    [self map];
    [self personBtn];
    UIImageView *bg = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bg.image = [UIImage imageNamed:@"bg"];
    bg.userInteractionEnabled = YES;
    [self.view insertSubview:bg atIndex:0];
    
    UIButton *portraitBtnA = [[UIButton alloc] init];
    portraitBtnA.frame = CGRectMake(ContentDistance, CGRectGetMaxY(self.map.frame) + ContentDistance * 3, 80, 80);
    [portraitBtnA setBackgroundImage:[UIImage imageNamed:@"person_a"] forState:UIControlStateNormal];
    portraitBtnA.userInteractionEnabled = NO;
    [self.view addSubview:portraitBtnA];
    
    UIButton *portraitBtnB = [[UIButton alloc] init];
    portraitBtnB.frame = CGRectMake(self.view.width - ContentDistance - 80, CGRectGetMaxY(self.map.frame) + ContentDistance * 3, 80, 80);
    [portraitBtnB setBackgroundImage:[UIImage imageNamed:@"person_b"] forState:UIControlStateNormal];
    portraitBtnB.userInteractionEnabled = NO;
    [self.view addSubview:portraitBtnB];
    
    UIButton *vsBtn = [[UIButton alloc] init];
    vsBtn.frame = CGRectMake(0, 0, 40, 40);
    vsBtn.center = CGPointMake(self.view.width / 2, portraitBtnA.centerY);
    [vsBtn setBackgroundImage:[UIImage imageNamed:@"vs"] forState:UIControlStateNormal];
    vsBtn.userInteractionEnabled = NO;
    [self.view addSubview:vsBtn];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
