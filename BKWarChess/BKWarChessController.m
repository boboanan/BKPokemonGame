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
#define MoveDistance self.map.width / 4

@interface BKWarChessController (){
    int mapScore[5][5];
}

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
    
    [self initMapScore];
    
    self.view.backgroundColor = [UIColor blueColor];
    [self setUpUI];
}

-(void)initMapScore
{
    for(int i = 0; i < 5; i++){
        for(int j = 0; j< 5; j++){
            mapScore[i][j] = 0;
        }
    }
}

-(void)setUpUI
{
    [self map];
    UIImageView *bg = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bg.image = [UIImage imageNamed:@"bg"];
    bg.userInteractionEnabled = YES;
    [self.view insertSubview:bg atIndex:0];
    
    UIButton *topBtn = [[UIButton alloc] init];
    topBtn.frame = CGRectMake(ContentDistance, ContentDistance * 3, self.view.width - 2 * ContentDistance, 50);
    topBtn.userInteractionEnabled = NO;
    [topBtn setBackgroundImage:[UIImage imageNamed:@"kuang"] forState:UIControlStateNormal];
    [topBtn setTitle:@"火箭队出击" forState:UIControlStateNormal];
    [self.view addSubview:topBtn];
    
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
    
    UILabel *portraitLabelA = [[UILabel alloc] init];
    portraitLabelA.x = CGRectGetMinX(portraitBtnA.frame);
    portraitLabelA.y = CGRectGetMaxY(portraitBtnA.frame) + ContentDistance;
    portraitLabelA.width = portraitBtnA.width;
    portraitLabelA.height = 40;
    portraitLabelA.text = @"火箭队";
    portraitLabelA.textAlignment = NSTextAlignmentCenter;
    portraitLabelA.textColor = [UIColor whiteColor];
    [self.view addSubview:portraitLabelA];
    
    UILabel *portraitLabelB = [[UILabel alloc] init];
    portraitLabelB.x = CGRectGetMinX(portraitBtnB.frame);
    portraitLabelB.y = CGRectGetMaxY(portraitBtnB.frame) + ContentDistance;
    portraitLabelB.width = portraitBtnB.width;
    portraitLabelB.height = 40;
    portraitLabelB.text = @"岩浆队";
    portraitLabelB.textAlignment = NSTextAlignmentCenter;
    portraitLabelB.textColor = [UIColor whiteColor];
    [self.view addSubview:portraitLabelB];
    
    //map上元素
    BKPersonBtn *megaBtnA = [BKPersonBtn getBKPersonBtn];
    megaBtnA.center = CGPointMake(CGRectGetMaxX(self.map.frame), CGRectGetMinY(self.map.frame));
    [megaBtnA setBackgroundImage:[UIImage imageNamed:@"mega"] forState:UIControlStateNormal];
    megaBtnA.userInteractionEnabled = NO;
    [self.view addSubview:megaBtnA];
    
    BKPersonBtn *megaBtnB = [BKPersonBtn getBKPersonBtn];
    megaBtnB.center = CGPointMake(CGRectGetMaxX(self.map.frame) - 2 * MoveDistance, CGRectGetMinY(self.map.frame) + 2 * MoveDistance);
    [megaBtnB setBackgroundImage:[UIImage imageNamed:@"mega"] forState:UIControlStateNormal];
    megaBtnB.userInteractionEnabled = NO;
    [self.view addSubview:megaBtnB];
    
    BKPersonBtn *megaBtnC = [BKPersonBtn getBKPersonBtn];
    megaBtnC.center = CGPointMake(CGRectGetMinX(self.map.frame), CGRectGetMaxY(self.map.frame));
    [megaBtnC setBackgroundImage:[UIImage imageNamed:@"mega"] forState:UIControlStateNormal];
    megaBtnC.userInteractionEnabled = NO;
    [self.view addSubview:megaBtnC];
    
    BKPersonBtn *spriteA = [BKPersonBtn getBKPersonBtn];
    spriteA.center = CGPointMake(CGRectGetMinX(self.map.frame) + MoveDistance, CGRectGetMinY(self.map.frame) + MoveDistance);
    [spriteA setBackgroundImage:[UIImage imageNamed:@"dragon"] forState:UIControlStateNormal];
    spriteA.width = 50;
    spriteA.height = 50;
    spriteA.userInteractionEnabled = NO;
    [spriteA setTitle:@"Lv.1" forState:UIControlStateNormal];
    [self.view addSubview:spriteA];
    
    BKPersonBtn *spriteB = [BKPersonBtn getBKPersonBtn];
    spriteB.center = CGPointMake(CGRectGetMaxX(self.map.frame) - MoveDistance, CGRectGetMaxY(self.map.frame) -  MoveDistance);
    [spriteB setBackgroundImage:[UIImage imageNamed:@"bikaqiu"] forState:UIControlStateNormal];
    spriteB.width = 50;
    spriteB.height = 50;
    spriteB.userInteractionEnabled = NO;
    [spriteB setTitle:@"Lv.1" forState:UIControlStateNormal];
    [self.view addSubview:spriteB];
    
    BKPersonBtn *spriteC = [BKPersonBtn getBKPersonBtn];
    spriteC.center = CGPointMake(CGRectGetMinX(self.map.frame) + MoveDistance, CGRectGetMaxY(self.map.frame) -  MoveDistance);
    [spriteC setBackgroundImage:[UIImage imageNamed:@"flag"] forState:UIControlStateNormal];
    spriteC.width = 50;
    spriteC.height = 50;
    spriteC.userInteractionEnabled = NO;
    [spriteC setTitle:@"Lv.2" forState:UIControlStateNormal];
    [self.view addSubview:spriteC];
    
    [self personBtnA];
    [self personBtnB];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
