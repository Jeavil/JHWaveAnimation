//
//  ViewController.m
//  JHWaveAnimation
//
//  Created by Jeavil_Tang on 2017/1/17.
//  Copyright © 2017年 Jeavil. All rights reserved.
//

#import "ViewController.h"
#import "JHWaveView.h"

@interface ViewController ()
@property (nonatomic, strong) JHWaveView *waveView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createContainerView];
}


- (void)createContainerView {
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMidY(self.view.bounds) - 50, CGRectGetWidth(self.view.bounds), 100)];
    view.backgroundColor = [UIColor lightGrayColor];
    if(!_waveView){
        self.waveView = [[JHWaveView alloc] initWithFrame:view.bounds];
    }
    self.waveView.backgroundColor = [UIColor clearColor];
    [self.waveView setUpConfigParams];
    [self.waveView startWaveAnimation];
    [view addSubview:self.waveView];
    [self.view addSubview:view];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
