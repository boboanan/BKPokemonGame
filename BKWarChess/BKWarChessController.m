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
#import <AVFoundation/AVFoundation.h>
#import "BKStartViewController.h"

#define ContentDistance 10
#define MoveDistance self.map.width / 4
#define NumOfMega 3
#define NumOfSprite 3


@interface BKWarChessController (){
    int mapScore[5][5];
}

@property(nonatomic,strong)AVAudioPlayer *player;

@property (weak, nonatomic) UIImageView *map;

/**玩家A*/
@property (weak, nonatomic) BKPersonBtn *personBtnA;
/**玩家B*/
@property (weak, nonatomic) BKPersonBtn *personBtnB;

@property (weak, nonatomic) UIButton * portraitBtnA;

/**顶部提示框*/
@property (nonatomic,weak)UIButton *topBtn;

/**音乐改变*/
@property (nonatomic, weak)UIButton *changMusic;

/**重新开始按钮*/
@property (nonatomic, weak)UIButton *reStartBtn;

/**A队名*/
@property (nonatomic, weak)UILabel *portraitLabelA;
/**B队名*/
@property (nonatomic, weak)UILabel *portraitLabelB;

/**精灵数组*/
@property (strong, nonatomic)NSMutableArray *sprites;
/**mega石数组*/
@property (strong, nonatomic)NSMutableArray *megas;

/**portraitA队头像*/
@property (nonatomic, weak)UIButton *portraitA;
/**portraitB队头像*/
@property (nonatomic, weak)UIButton *portraitB;

/**A获得小精灵*/
@property (nonatomic, weak)UILabel *getSpriteLabelA;
/**B获得小精灵*/
@property (nonatomic, weak)UILabel *getSpriteLabelB;

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
        btn.tag = 0;
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
        btn.tag = 1;
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
        self.portraitA.width =  1.1 * self.portraitA.width ;
        self.portraitA.height = 1.1 *self.portraitA.height;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:duration animations:^{
            self.portraitA.width =  self.portraitA.width / 1.1;
            self.portraitA.height = self.portraitA.height / 1.1;
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
        self.portraitB.width =  1.1 * self.portraitB.width ;
        self.portraitB.height = 1.1 *self.portraitB.height;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:duration animations:^{
            self.portraitB.width =  self.portraitB.width / 1.1;
            self.portraitB.height = self.portraitB.height / 1.1;
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
        self.personBtnA.isMoved = NO;
        self.personBtnB.isMoved = NO;
        if(self.turning % 2 == 1){
                [self.personBtnA btnMoveMethodWithFrame:self.map.frame TouchPoint:touchPoint];
            if(mapScore[self.personBtnA.i][self.personBtnA.j] == 2&&self.personBtnA.isMoved){
                [self performSelector:@selector(playAnimation:) withObject:self.personBtnA afterDelay:0.5];
            }
            self.getSpriteLabelA.text = [self judgeWithBtn:self.personBtnA];
            [self judgeVictoryWithBtn:self.personBtnA];
        }else if(self.turning % 2 == 0){
                [self.personBtnB btnMoveMethodWithFrame:self.map.frame TouchPoint:touchPoint];
    
            if(mapScore[self.personBtnB.i][self.personBtnB.j] == 2&&self.personBtnB.isMoved){
                [self performSelector:@selector(playAnimation:) withObject:self.personBtnB afterDelay:0.5];
            }
            self.getSpriteLabelB.text = [self judgeWithBtn:self.personBtnB];
            [self judgeVictoryWithBtn:self.personBtnB];
        }
        if(self.personBtnA.isMoved || self.personBtnB.isMoved){
            self.turning++;
        }
    }

    self.personBtnA.canMove = false;
    self.personBtnA.canMove = false;
    [self performSelector:@selector(updateTopBtn) withObject:nil afterDelay:0.5];
#warning ceshi
    NSLog(@"火箭队i－%d-j-%d－－岩浆队队i－%d-j-%d",self.personBtnA.i,self.personBtnA.j,self.personBtnB.i,self.personBtnB.j);
}

//判断显示和自己战况
-(NSString *)judgeWithBtn:(BKPersonBtn *)btn
{
    //此处为方便写死了，为了通用，可以便利得到信息
    if((btn.i == 4&&btn.j == 0)||(btn.i == 0&&btn.j == 4)||(btn.i == 2&&btn.j == 2)){//mega石
        btn.isGotMega = true;
    }else if(btn.i == 1&&btn.j == 1){
        btn.level = [self.sprites[0] currentTitle];
    }else if(btn.i == 1&&btn.j == 3){
        btn.level = [self.sprites[1] currentTitle];
    }else if(btn.i == 3&&btn.j == 3){
        btn.level = [self.sprites[2] currentTitle];
    }
    [btn gotAttack];
    NSString *situation = nil;
    if(btn.level){
        if(btn.isGotMega){
            situation = [NSString stringWithFormat:@"获得%@，有mega石",btn.level];
        }else{
            situation = [NSString stringWithFormat:@"获得%@，没有mega石",btn.level];
        }
    }else{
        situation = @"没有获得小精灵";
    }
    return situation;
}

//判断胜利
-(void)judgeVictoryWithBtn:(BKPersonBtn *)btn
{
    if(btn.category == 0&&btn.i == 4&&btn.j == 4){
//        UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
//        view.backgroundColor = [UIColor blackColor];
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
//        label.text = @"火箭队获胜";
//        label.textColor = [UIColor whiteColor];
//        label.textAlignment = NSTextAlignmentCenter;
//        label.center = CGPointMake(self.view.width/2, self.view.height/2);
//        [view addSubview:label];
//        [self.view addSubview:view];
//        view.alpha = 0;
//        [UIView animateWithDuration:3 animations:^{
//            view.alpha = 1;
//        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:2 animations:^{
//                view.alpha = 0;
//            } completion:^(BOOL finished) {
//
//            }];
//        }];
        [self victoryUIWithString:@"火箭队获胜"];
#warning ceshi
         NSLog(@"火箭队队获胜");
//        [self restart];
    }else if (btn.category == 1&&btn.i == 0&&btn.j == 0){
//        UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
//        view.backgroundColor = [UIColor blackColor];
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
//        label.text = @"岩浆队队获胜";
//        label.textColor = [UIColor whiteColor];
//        label.textAlignment = NSTextAlignmentCenter;
//        label.center = CGPointMake(self.view.width/2, self.view.height/2);
//        [view addSubview:label];
//        [self.view addSubview:view];
//        view.alpha = 0;
//        [UIView animateWithDuration:3 animations:^{
//            view.alpha = 1;
//        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:2 animations:^{
//                view.alpha = 0;
//            } completion:^(BOOL finished) {
//                
//            }];
//        }];
        [self victoryUIWithString:@"岩浆队获胜"];
#warning ceshi
        NSLog(@"岩浆队队获胜");
//        [self restart];
    }
    if(self.personBtnA.i == self.personBtnB.i&&self.personBtnA.j == self.personBtnB.j){
        if(self.personBtnA.attack > self.personBtnB.attack){
           [self victoryUIWithString:@"火箭队获胜"];
        }else if(self.personBtnA.attack > self.personBtnB.attack){
           [self victoryUIWithString:@"岩浆队获胜"];
        }else{
           [self victoryUIWithString:@"平局"];
        }
//        [self restart];
    }
   
}

-(void)victoryUIWithString:(NSString *)vicName
{
    UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
    view.backgroundColor = [UIColor blackColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
    label.text = vicName;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.center = CGPointMake(self.view.width/2, self.view.height/2);
    [view addSubview:label];
    [self.view addSubview:view];
    view.alpha = 0;
    [UIView animateWithDuration:3 animations:^{
        view.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:2 animations:^{
            view.alpha = 0;
        } completion:^(BOOL finished) {
            
        }];
    }];
}

//更新顶部提示内容
-(void)updateTopBtn
{
    NSString *team = self.turning%2 ? self.portraitLabelA.text:self.portraitLabelB.text;
    NSString *title = [NSString stringWithFormat:@"第%d步:%@出击",self.turning,team];
    [self.topBtn setTitle:title forState:UIControlStateNormal];
}

//播放动画
-(void)playAnimation:(BKPersonBtn *)btn
{
    UIView *view  = [[UIView alloc] initWithFrame:self.view.bounds];
    view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [self.view addSubview:view];

    [UIView animateWithDuration:3 animations:^{
         view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    } completion:^(BOOL finished) {
        
    }];
    if(btn.tag == 0){
        CGFloat dis = self.view.height / 3;
        UIImageView *gifImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, dis, self.view.width, dis)];
        //    NSArray *gifArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"pikaqiuA"],
        //                         [UIImage imageNamed:@"pikaqiuB"],
        //                         nil];
        NSMutableArray *gifArray = [NSMutableArray array];
        for(int i=1; i<18;i++){
            NSString *name = [NSString stringWithFormat:@"penhuolong%d",i];
            [gifArray addObject:[UIImage imageNamed:name]];
        }
        gifImageView.animationImages = gifArray; //动画图片数组
        gifImageView.animationDuration = 2.5; //执行一次完整动画所需的时长
        gifImageView.animationRepeatCount = 1;  //动画重复次数
        [gifImageView startAnimating];
        [self.view addSubview:gifImageView];
    }else{
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
    [UIView animateWithDuration:3 animations:^{
        view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initMapScore];
    
    self.view.backgroundColor = [UIColor blueColor];
    self.turning = 1;
    
    [self setUpUI];
    
    [self startOrStopMusic];
}

//初始化地图
-(void)initMapScore
{
    for(int i = 0; i < 5; i++){
        for(int j = 0; j< 5; j++){
            mapScore[i][j] = 0;
        }
    }
    //mega
    mapScore[4][0] = 3;
    mapScore[0][4] = 3;
    mapScore[2][2] = 3;
    
    //sprites
    mapScore[1][1] = 2;
    mapScore[1][3] = 2;
    mapScore[3][3] = 2;
    [self updateMap];
}

//设置其他UI
-(void)setUpUI
{
    [self map];
    
    UIButton *homeBtnA = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    homeBtnA.backgroundColor = [UIColor redColor];
    homeBtnA.layer.cornerRadius = 20;
    homeBtnA.userInteractionEnabled = NO;
    [homeBtnA setTitle:@"H" forState:UIControlStateNormal];
    homeBtnA.center = CGPointMake(CGRectGetMinX(self.map.frame), CGRectGetMinY(self.map.frame));
    [self.view addSubview:homeBtnA];
    
    UIButton *homeBtnB = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    homeBtnB.backgroundColor = [UIColor blueColor];
    homeBtnB.layer.cornerRadius = 20;
    homeBtnB.userInteractionEnabled = NO;
    [homeBtnB setTitle:@"H" forState:UIControlStateNormal];
    homeBtnB.center = CGPointMake(CGRectGetMaxX(self.map.frame), CGRectGetMaxY(self.map.frame));
    [self.view addSubview:homeBtnB];
    
    
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
    self.topBtn = topBtn;
    
    UIButton *stopMusic = [[UIButton alloc] init];
    stopMusic.frame = CGRectMake(ContentDistance, ContentDistance + CGRectGetMaxY(self.topBtn.frame), (self.view.width - 2 * ContentDistance)/2 - ContentDistance/2, 30);
    [stopMusic setBackgroundImage:[UIImage imageNamed:@"kuang"] forState:UIControlStateNormal];
    [stopMusic setTitle:@"停止音乐" forState:UIControlStateNormal];
    [stopMusic addTarget:self action:@selector(startOrStopMusic) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stopMusic];
    self.changMusic =stopMusic;
    
    UIButton *reStart = [[UIButton alloc] init];
    reStart.frame = CGRectMake(CGRectGetMaxX(self.changMusic.frame) + ContentDistance, ContentDistance + CGRectGetMaxY(self.topBtn.frame), (self.view.width - 2 * ContentDistance)/2 - ContentDistance/2, 30);
    [reStart setBackgroundImage:[UIImage imageNamed:@"kuang"] forState:UIControlStateNormal];
    [reStart setTitle:@"重新开始" forState:UIControlStateNormal];
    [reStart addTarget:self action:@selector(restart) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reStart];
    self.reStartBtn =reStart;
    
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
    self.portraitLabelA = portraitLabelA;
    
    
    UILabel *getSpriteLabelA = [[UILabel alloc] init];
    getSpriteLabelA.x = CGRectGetMinX(portraitBtnA.frame);
    getSpriteLabelA.y = CGRectGetMaxY(portraitLabelA.frame);
    getSpriteLabelA.width = portraitBtnA.width +4 *ContentDistance;
    getSpriteLabelA.height = ContentDistance;
    getSpriteLabelA.text = @"获得0支小精灵";
    getSpriteLabelA.font = [UIFont systemFontOfSize:10];
    getSpriteLabelA.textAlignment = NSTextAlignmentCenter;
    getSpriteLabelA.textColor = [UIColor whiteColor];
    [self.view addSubview:getSpriteLabelA];
    self.getSpriteLabelA = getSpriteLabelA;
    
    UILabel *portraitLabelB = [[UILabel alloc] init];
    portraitLabelB.x = CGRectGetMinX(portraitBtnB.frame);
    portraitLabelB.y = CGRectGetMaxY(portraitBtnB.frame) + ContentDistance;
    portraitLabelB.width = portraitBtnB.width;
    portraitLabelB.height = 40;
    portraitLabelB.text = @"岩浆队";
    portraitLabelB.textAlignment = NSTextAlignmentCenter;
    portraitLabelB.textColor = [UIColor whiteColor];
    [self.view addSubview:portraitLabelB];
    self.portraitLabelB = portraitLabelB;
    
    UILabel *getSpriteLabelB = [[UILabel alloc] init];
    getSpriteLabelB.x = CGRectGetMinX(portraitBtnB.frame)- 4*ContentDistance;
    getSpriteLabelB.y = CGRectGetMaxY(portraitLabelB.frame);
    getSpriteLabelB.width = portraitBtnB.width + 4*ContentDistance;
    getSpriteLabelB.height = ContentDistance;
    getSpriteLabelB.text = @"获得0支小精灵";
    getSpriteLabelB.font = [UIFont systemFontOfSize:10];
    getSpriteLabelB.textAlignment = NSTextAlignmentCenter;
    getSpriteLabelB.textColor = [UIColor whiteColor];
    [self.view addSubview:getSpriteLabelB];
    self.getSpriteLabelB = getSpriteLabelB;
    
    [self personBtnA];
    [self personBtnB];
    
    [self updateTopBtn];
}

-(void)restart
{
    [UIApplication sharedApplication].keyWindow.rootViewController = [[BKStartViewController alloc] init];
}

-(void)startOrStopMusic
{
    if(self.player == nil){
        //1.音频文件的url路径
        NSURL *url=[[NSBundle mainBundle]URLForResource:@"middleMusic.MP3" withExtension:Nil];
        
        //2.创建播放器（注意：一个AVAudioPlayer只能播放一个url）
        self.player=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:Nil];
        
        //3.缓冲
        [self.player prepareToPlay];
        [self.player play];
         [self.changMusic setTitle:@"停止音乐" forState:UIControlStateNormal];
    }else{
        [self.player stop];
        self.player = nil;
        [self.changMusic setTitle:@"开始音乐" forState:UIControlStateNormal];
    }
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
