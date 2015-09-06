//
//  BKStartViewController.m
//  BKWarChess
//
//  Created by 锄禾日当午 on 15/9/5.
//  Copyright (c) 2015年 B&K. All rights reserved.
//

#import "BKStartViewController.h"
#import "BKWarChessController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface BKStartViewController ()
@property (nonatomic,strong) MPMoviePlayerViewController *moviePlayer;//视频播放控制器
@end

@implementation BKStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image = [UIImage imageNamed:@"start"];
    [self.view addSubview:imageView];
    imageView.alpha = 0;
    [UIView animateWithDuration:3 animations:^{
        imageView.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:2 animations:^{
            imageView.alpha = 0;
        } completion:^(BOOL finished) {
            [self playMovie];
        }];
    }];

}

-(void)playMovie
{
    NSURL *url=[[NSBundle mainBundle]URLForResource:@"headAnimation.mov" withExtension:Nil];
    self.moviePlayer=[[MPMoviePlayerViewController alloc]initWithContentURL:url];
    [self addNotification];
    [self presentMoviePlayerViewControllerAnimated:self.moviePlayer];
}

-(void)addNotification{
    NSNotificationCenter *notificationCenter=[NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(mediaPlayerPlaybackFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer.moviePlayer];
    
}


/**播放完成*/
-(void)mediaPlayerPlaybackFinished:(NSNotification *)notification{
    UIView *view= [[UIView alloc] initWithFrame:self.view.bounds];
    view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:view];
    view.alpha = 0;
    [UIView animateWithDuration:3 animations:^{
        view.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:3 animations:^{
            view.alpha = 0;
        } completion:^(BOOL finished) {
            [UIApplication sharedApplication].keyWindow.rootViewController = [[BKWarChessController alloc] init];
        }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
