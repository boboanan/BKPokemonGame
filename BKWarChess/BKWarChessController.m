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
@end

@implementation BKWarChessController
//mega石数组
-(NSMutableArray *)megas
{
    if(_megas == nil){
        _megas = [NSMutableArray array];
        for(int i = 0; i<NumOfMega; i++ ){
            BKPersonBtn *mega = [BKPersonBtn getMegaBtn];
            [self.view addSubview:mega];
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
            [self.view addSubview:sprite];
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
        [self.view addSubview:map];
        _map = map;
    }
    return _map;
}

-(BKPersonBtn *)personBtnA
{
    if(_personBtnA == nil){
        BKPersonBtn *btn = [BKPersonBtn getBKPersonBtnWithImageName:@"circle_a"];
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
        BKPersonBtn *btn = [BKPersonBtn getBKPersonBtnWithImageName:@"circle_b"];
        btn.center = CGPointMake(CGRectGetMinX(self.map.frame), CGRectGetMinY(self.map.frame));
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
    [self updateMap];

}


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
//    BKPersonBtn *megaBtnA = [BKPersonBtn getMegaBtn];
//    megaBtnA.center = CGPointMake(CGRectGetMaxX(self.map.frame), CGRectGetMinY(self.map.frame));
//    [self.view addSubview:megaBtnA];
//    
//    BKPersonBtn *megaBtnB = [BKPersonBtn getMegaBtn];
//    megaBtnB.center = CGPointMake(CGRectGetMaxX(self.map.frame) - 2 * MoveDistance, CGRectGetMinY(self.map.frame) + 2 * MoveDistance);
//    [self.view addSubview:megaBtnB];
//    
//    BKPersonBtn *megaBtnC = [BKPersonBtn getMegaBtn];
//    megaBtnC.center = CGPointMake(CGRectGetMinX(self.map.frame), CGRectGetMaxY(self.map.frame));
//    [self.view addSubview:megaBtnC];
    
//    BKPersonBtn *spriteA = [BKPersonBtn getSpriteBtnWithImageName:@"dragon"];
//    spriteA.center = CGPointMake(CGRectGetMinX(self.map.frame) + MoveDistance, CGRectGetMinY(self.map.frame) + MoveDistance);
//    [spriteA setTitle:@"Lv.1" forState:UIControlStateNormal];
//    [self.view addSubview:spriteA];
//    
//    BKPersonBtn *spriteB = [BKPersonBtn getSpriteBtnWithImageName:@"bikaqiu"];
//    spriteB.center = CGPointMake(CGRectGetMaxX(self.map.frame) - MoveDistance, CGRectGetMaxY(self.map.frame) -  MoveDistance);
//    [spriteB setTitle:@"Lv.1" forState:UIControlStateNormal];
//    [self.view addSubview:spriteB];
//    
//    BKPersonBtn *spriteC = [BKPersonBtn getSpriteBtnWithImageName:@"flag"];
//    spriteC.center = CGPointMake(CGRectGetMinX(self.map.frame) + MoveDistance, CGRectGetMaxY(self.map.frame) -  MoveDistance);
//    [spriteC setTitle:@"Lv.2" forState:UIControlStateNormal];
//    [self.view addSubview:spriteC];
    
//        BKPersonBtn *spriteA = [BKPersonBtn getRandomSprite];
//        spriteA.center = CGPointMake(CGRectGetMinX(self.map.frame) + MoveDistance, CGRectGetMinY(self.map.frame) + MoveDistance);
//        [spriteA setTitle:@"Lv.1" forState:UIControlStateNormal];
//        [self.view addSubview:spriteA];
//    
//        BKPersonBtn *spriteB = [BKPersonBtn getRandomSprite];
//        spriteB.center = CGPointMake(CGRectGetMaxX(self.map.frame) - MoveDistance, CGRectGetMaxY(self.map.frame) -  MoveDistance);
//        [spriteB setTitle:@"Lv.1" forState:UIControlStateNormal];
//        [self.view addSubview:spriteB];
//    
//        BKPersonBtn *spriteC = [BKPersonBtn getRandomSprite];
//        spriteC.center = CGPointMake(CGRectGetMinX(self.map.frame) + MoveDistance, CGRectGetMaxY(self.map.frame) -  MoveDistance);
//        [spriteC setTitle:@"Lv.2" forState:UIControlStateNormal];
//        [self.view addSubview:spriteC];

    
    [self personBtnA];
    [self personBtnB];
    

}

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
