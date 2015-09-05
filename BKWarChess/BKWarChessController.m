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
#define NumOfMega 3
#define NumOfSprite 3


@interface BKWarChessController (){
    int mapScore[5][5];
}

@property (weak, nonatomic) UIImageView *map;

/**玩家A*/
@property (weak, nonatomic) BKPersonBtn *personBtnA;
/**玩家B*/
@property (weak, nonatomic) BKPersonBtn *personBtnB;

@property (weak, nonatomic) UIButton * portraitBtnA;

/**精灵数组*/
@property (strong, nonatomic)NSMutableArray *sprites;
/**mega石数组*/
@property (strong, nonatomic)NSMutableArray *megas;

/**portraitA队头像*/
@property (nonatomic, weak)UIButton *portraitA;
/**portraitB队头像*/
@property (nonatomic, weak)UIButton *portraitB;

/**回合轮到谁*/
@property (nonatomic)int turning;
@end

@implementation BKWarChessController
//mega石数组
-(NSMutableArray *)megas
{
    if(_megas == nil){
        _megas = [NSMutableArray array];
        for(int i = 0; i<NumOfMega; i++ ){
            BKPersonBtn *mega = [BKPersonBtn getMegaBtn];
            [self.view insertSubview:mega aboveSubview:self.map];
            [_megas addObject:mega];
        }
    }
    return _megas;
}

//小精灵数组
-(NSMutableArray *)sprites
{
    if(_sprites == nil){
        _sprites = [NSMutableArray array];
        for(int i = 0; i<NumOfSprite; i++ ){
            BKPersonBtn *sprite = [BKPersonBtn getRandomSprite];
             [self.view insertSubview:sprite aboveSubview:self.map];
            [_sprites addObject:sprite];
        }
    }
    return _sprites;
}

-(UIImageView *)map
{
    if(_map == nil){
        CGRect rect = [UIScreen mainScreen].bounds;
        UIImageView *map = [[UIImageView alloc] init];
        map.frame = CGRectMake(0, 0, 225, 225);
        map.image = [UIImage imageNamed:@"map"];
        map.center = CGPointMake(rect.size.width / 2, rect.size.height / 2);
        [self.view insertSubview:map atIndex:1];
        _map = map;
    }
    return _map;
}

-(BKPersonBtn *)personBtnA
{
    if(_personBtnA == nil){
        BKPersonBtn *btn = [BKPersonBtn getBKPersonBtnWithImageName:@"circle_a"];
         btn.center = CGPointMake(CGRectGetMinX(self.map.frame), CGRectGetMinY(self.map.frame));
        [btn addTarget:self action:@selector(personAMove:) forControlEvents:UIControlEventTouchUpInside];
        btn.category = 0;
        btn.i = 0;
        btn.j = 0;
        [self.view addSubview:btn];
        _personBtnA = btn;
    }
    return _personBtnA;
}

-(BKPersonBtn *)personBtnB
{
    if(_personBtnB == nil){
        BKPersonBtn *btn = [BKPersonBtn getBKPersonBtnWithImageName:@"circle_b"];
        btn.center = CGPointMake(CGRectGetMaxX(self.map.frame), CGRectGetMaxY(self.map.frame));
        [btn addTarget:self action:@selector(personBMove:) forControlEvents:UIControlEventTouchUpInside];
        btn.category = 1;
        btn.i = 4;
        btn.j = 4;
        [self.view addSubview:btn];
        _personBtnB = btn;
    }
    return _personBtnB;
}

//a的移动方法
-(void)personAMove:(BKPersonBtn *)sender
{
    if(self.turning % 2 == 1){
        sender.canMove = true;
    }
        CGFloat duration = 0.5;
        [UIView animateWithDuration:duration animations:^{
            self.portraitB.width =  1.1 * self.portraitB.width ;
            self.portraitB.height = 1.1 *self.portraitB.height;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:duration animations:^{
                self.portraitB.width =  self.portraitB.width / 1.1;
                self.portraitB.height = self.portraitB.height / 1.1;
            }];
        }];
}

//b的移动方法
-(void)personBMove:(BKPersonBtn *)sender
{

    if(self.turning % 2 == 0){
        sender.canMove = true;
    }
        CGFloat duration = 0.5;
        [UIView animateWithDuration:duration animations:^{
            self.portraitA.width =  1.1 * self.portraitA.width ;
            self.portraitA.height = 1.1 *self.portraitA.height;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:duration animations:^{
                self.portraitA.width =  self.portraitA.width / 1.1;
                self.portraitA.height = self.portraitA.height / 1.1;
            }];
        }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //只有按钮被激活才会判断是否移动
    if(self.personBtnA.canMove || self.personBtnB.canMove){
        UITouch *touch = [touches anyObject];
        
        CGPoint touchPoint = [touch locationInView:self.view];
        //touchPoint.x ，touchPoint.y 就是触点的坐标。
        if(self.turning % 2 == 1){
            [self.personBtnA btnMoveMethodWithFrame:self.map.frame TouchPoint:touchPoint];
            if(mapScore[self.personBtnA.i][self.personBtnA.j] == 2){
                [self performSelector:@selector(playAnimation) withObject:nil afterDelay:0.5];
            }
        }else if(self.turning % 2 == 0){
            [self.personBtnB btnMoveMethodWithFrame:self.map.frame TouchPoint:touchPoint];
        }
        if(self.personBtnA.isMoved || self.personBtnB.isMoved){
            self.turning++;
        }
    }

    self.personBtnA.canMove = false;
    self.personBtnA.canMove = false;
}


//播放动画
-(void)playAnimation
{
    CGFloat dis = self.view.height / 3;
    UIImageView *gifImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, dis, self.view.width, dis)];
    NSArray *gifArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"pikaqiuA"],
                         [UIImage imageNamed:@"pikaqiuB"],
                         nil];
    gifImageView.animationImages = gifArray; //动画图片数组
    gifImageView.animationDuration = 1; //执行一次完整动画所需的时长
    gifImageView.animationRepeatCount = 2;  //动画重复次数
    [gifImageView startAnimating];
    [self.view addSubview:gifImageView];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initMapScore];
    
    self.view.backgroundColor = [UIColor blueColor];
    self.turning = 1;
    
    [self setUpUI];

}

//初始化地图
-(void)initMapScore
{
    for(int i = 0; i < 5; i++){
        for(int j = 0; j< 5; j++){
            mapScore[i][j] = 0;
        }
    }
    mapScore[4][0] = 3;
    mapScore[0][4] = 3;
    mapScore[2][2] = 3;
    
    mapScore[1][1] = 2;
    mapScore[1][3] = 2;
    mapScore[3][3] = 2;
    [self updateMap];
}

//设置其他UI
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
    self.portraitA = portraitBtnA;
    
    UIButton *portraitBtnB = [[UIButton alloc] init];
    portraitBtnB.frame = CGRectMake(self.view.width - ContentDistance - 80, CGRectGetMaxY(self.map.frame) + ContentDistance * 3, 80, 80);
    [portraitBtnB setBackgroundImage:[UIImage imageNamed:@"person_b"] forState:UIControlStateNormal];
    portraitBtnB.userInteractionEnabled = NO;
    [self.view addSubview:portraitBtnB];
    self.portraitB = portraitBtnB;
    
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

    
    [self personBtnA];
    [self personBtnB];
    

}

//更新地图上跟种类分布
-(void)updateMap
{
    int numMega = 0;
    int numSprite = 0;
        for(int i = 0; i < 5; i++){
            for(int j = 0; j< 5; j++){
                switch (mapScore[i][j]) {
                    case 2:{
                        BKPersonBtn *btn = self.sprites[numSprite];
                        btn.center = CGPointMake(CGRectGetMinX(self.map.frame) + i *MoveDistance, CGRectGetMinY(self.map.frame) + j* MoveDistance);
                        numSprite++;
                        break;
                    }
                    case 3:
                    {
                        BKPersonBtn *btn = self.megas[numMega];
                        btn.center = CGPointMake(CGRectGetMinX(self.map.frame) + i *MoveDistance, CGRectGetMinY(self.map.frame) + j* MoveDistance);
                        numMega++;
                    }
                        break;
                        
                    default:
                        break;
                }
            }
        }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
