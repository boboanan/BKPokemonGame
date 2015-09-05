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

#define ContentDistance 10
@interface BKWarChessController ()

@property (weak, nonatomic) UIImageView *map;

/**玩家A*/
@property (weak, nonatomic) BKPersonBtn *personBtnA;
/**玩家B*/
@property (weak, nonatomic) BKPersonBtn *personBtnB;

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

-(BKPersonBtn *)personBtnA
{
    if(_personBtnA == nil){
        BKPersonBtn *btn = [BKPersonBtn getBKPersonBtn];
        btn.center = CGPointMake(CGRectGetMaxX(self.map.frame), CGRectGetMaxY(self.map.frame));
        [btn addTarget:self action:@selector(personMove:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        _personBtnA = btn;
    }
    return _personBtnA;
}

-(BKPersonBtn *)personBtnB
{
    if(_personBtnB == nil){
        BKPersonBtn *btn = [BKPersonBtn getBKPersonBtn];
        btn.center = CGPointMake(CGRectGetMinX(self.map.frame), CGRectGetMinY(self.map.frame));
        [btn setBackgroundImage:[UIImage imageNamed:@"circle_b"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(personMove:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        _personBtnB = btn;
    }
    return _personBtnB;
}


-(void)personMove:(BKPersonBtn *)sender
{
    sender.canMove = !sender.canMove;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    CGPoint touchPoint = [touch locationInView:self.view];
    //touchPoint.x ，touchPoint.y 就是触点的坐标。
    [self.personBtnA btnMoveMethodWithFrame:self.map.frame TouchPoint:touchPoint];
    [self.personBtnB btnMoveMethodWithFrame:self.map.frame TouchPoint:touchPoint];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    [self setUpUI];
}

-(void)setUpUI
{
    [self map];
    [self personBtnA];
    [self personBtnB];
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
