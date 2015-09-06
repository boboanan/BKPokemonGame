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
//            [UIApplication sharedApplication].keyWindow.rootViewController = [[BKWarChessController alloc] init];
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
    [notificationCenter addObserver:self selector:@selector(mediaPlayerPlaybackStateChange:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:self.moviePlayer.moviePlayer];
    [notificationCenter addObserver:self selector:@selector(mediaPlayerPlaybackFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer.moviePlayer];
    
}

-(void)mediaPlayerPlaybackStateChange:(NSNotification *)notification{
//    switch (self.moviePlayer.moviePlayer.playbackState) {
//        case MPMoviePlaybackStatePlaying:
//            NSLog(@"正在播放...");
//            break;
//        case MPMoviePlaybackStatePaused:
//            NSLog(@"暂停播放.");
//            break;
//        case MPMoviePlaybackStateStopped:
//            NSLog(@"停止播放.");
//            break;
//        default:
//            NSLog(@"播放状态:%li",self.moviePlayer.moviePlayer.playbackState);
//            break;
//    }
}

/**
 *  播放完成
 *
 *  @param notification 通知对象
 */
-(void)mediaPlayerPlaybackFinished:(NSNotification *)notification{
      [UIApplication sharedApplication].keyWindow.rootViewController = [[BKWarChessController alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
