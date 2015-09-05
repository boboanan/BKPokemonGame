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


/**位置*/
@property (nonatomic) NSUInteger i;
@property (nonatomic) NSUInteger j;

/**按钮类型*/
//0-a队,1-b队,2-精灵,3-mega石
@property(nonatomic)int category;

/**人物*/
+(instancetype)getBKPersonBtnWithImageName:(NSString *)image;
/**小精灵*/
+(instancetype)getSpriteBtnWithImageName:(NSString *)image;
+(instancetype)getRandomSprite;
/**进化石*/
+(instancetype)getMegaBtn;


-(void)btnMoveMethodWithFrame:(CGRect)frame TouchPoint:(CGPoint)touchPoint;
@end
