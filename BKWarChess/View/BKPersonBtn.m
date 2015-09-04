//
//  BKPersonBtn.m
//  BKWarChess
//
//  Created by 锄禾日当午 on 15/9/4.
//  Copyright (c) 2015年 B&K. All rights reserved.
//

#import "BKPersonBtn.h"

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

@end
