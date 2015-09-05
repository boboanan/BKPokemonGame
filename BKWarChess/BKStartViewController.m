//
//  BKStartViewController.m
//  BKWarChess
//
//  Created by 锄禾日当午 on 15/9/5.
//  Copyright (c) 2015年 B&K. All rights reserved.
//

#import "BKStartViewController.h"
#import "BKWarChessController.h"

@interface BKStartViewController ()

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
            [UIApplication sharedApplication].keyWindow.rootViewController = [[BKWarChessController alloc] init];
        }];
    }];
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
