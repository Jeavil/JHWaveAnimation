//
//  JHWaveView.m
//  JHWaveAnimation
//
//  Created by Jeavil_Tang on 2017/1/17.
//  Copyright © 2017年 Jeavil. All rights reserved.
//

#import "JHWaveView.h"

#define rgba(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define ScreenW  CGRectGetWidth(self.bounds)
#define ScreenH  CGRectGetHeight(self.bounds)

@interface JHWaveView ()

@property (nonatomic,strong) CADisplayLink *displayLink;

@property (nonatomic,strong) CAShapeLayer *firstWaveLayer;
@property (nonatomic,strong) CAShapeLayer *secondeWaveLayer;
@property (nonatomic,strong) CAShapeLayer *firstRevelsalWaveLayer;
@property (nonatomic,strong) CAShapeLayer *secondRevelsalWaveLayer;

@property (nonatomic,strong) UIView *topView;
@property (nonatomic,strong) UIView *bottomView;

@end

@implementation JHWaveView {
    CGFloat _waveAmplitude;      //振幅
    CGFloat _waveCycle;          //周期
    CGFloat _waveSpeed;          //第一条波纹速度
    CGFloat _waveSpeed2;         //第二条波纹速度
    CGFloat _waveHeight;         //波纹高度
    CGFloat _waveWidth;          //波纹宽度
    CGFloat _wavePointY;
    CGFloat _waveOffsetX;       //X轴位移
    UIColor *_waveColor;        //波纹颜色
}

- (void)setUpConfigParams {
    
    _topView = [UIView new];
    _topView.frame = CGRectMake(0, 0, ScreenW, ScreenH / 2);
    _topView.backgroundColor = [UIColor clearColor];
    [self addSubview:_topView];
    _bottomView = [UIView new];
    _bottomView.frame = CGRectMake(0, CGRectGetMaxY(_topView.bounds), ScreenW, ScreenH / 2);
    _bottomView.backgroundColor = [UIColor clearColor];
    [self addSubview:_bottomView];
    _waveWidth = ScreenW;
    _waveHeight = self.topView.frame.size.height;
    _waveColor = rgba(255, 255, 255,0.6);
    _waveSpeed = 0.2 / M_PI;
    _waveSpeed2 = 0.25 / M_PI;
    _waveOffsetX = 0;
    _wavePointY = _waveHeight / 2;
    _waveAmplitude = 10;
    _waveCycle =  1.5 * M_PI / _waveWidth;
}

- (void)startWaveAnimation {
    
    [self.topView.layer addSublayer:self.firstWaveLayer];
    [self.topView.layer addSublayer:self.secondeWaveLayer];
    [self.bottomView.layer addSublayer:self.firstRevelsalWaveLayer];
    [self.bottomView.layer addSublayer:self.secondRevelsalWaveLayer];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];

}

- (void)stopWaveAnimation {
    
    [self.displayLink invalidate];
    self.displayLink = nil;
    self.firstWaveLayer.path = nil;
    self.secondeWaveLayer.path = nil;
    self.firstRevelsalWaveLayer.path = nil;
    self.secondRevelsalWaveLayer.path = nil;
}

- (void)changeCurrentWavePosition {
    _waveOffsetX += _waveSpeed;
    [self setFirstWaveLayerPath];
    [self setSecondWaveLayerPath];
    [self setFirstReveralWaveLayerPath];
    [self setSecondReveralWaveLayerPath];
}


- (void)setFirstReveralWaveLayerPath
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat y =  CGRectGetMaxY(self.bottomView.bounds);
    [path moveToPoint:CGPointMake(0, y)];
    for (float x = 0.0f; x <= _waveWidth; x +=5) {
        y = _waveAmplitude * sin(_waveCycle * x + _waveOffsetX + 10) + _wavePointY - 5;
        [path addLineToPoint:CGPointMake(x, y)];
    }
    
    [path addLineToPoint:CGPointMake(_waveWidth, 0)];
    [path addLineToPoint:CGPointMake(0, 0)];
    
    [path closePath];
    
    _firstRevelsalWaveLayer.path = path.CGPath;
}

- (void)setSecondReveralWaveLayerPath
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat y =  CGRectGetMaxY(self.bottomView.bounds);
    [path moveToPoint:CGPointMake(0, y)];
    for (float x = 0.0f; x <= _waveWidth; x += 5) {
        y = (_waveAmplitude -2) * sin(_waveCycle * x + _waveOffsetX ) + _wavePointY ;
        [path addLineToPoint:CGPointMake(x, y)];
    }
    [path addLineToPoint:CGPointMake(_waveWidth, 0)];
    [path addLineToPoint:CGPointMake(0, 0)];
    [path closePath];
    
    _secondRevelsalWaveLayer.path = path.CGPath;
}


- (void)setFirstWaveLayerPath
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat y = _wavePointY;
    [path moveToPoint:CGPointMake(0, y)];
    for (float x = 0.0f; x <= _waveWidth; x +=5) {
        y = _waveAmplitude * sin(_waveCycle * x + _waveOffsetX - 10) + _wavePointY + 5;
        [path addLineToPoint:CGPointMake(x, y)];
    }
    
    [path addLineToPoint:CGPointMake(_waveWidth, self.topView.frame.size.height)];
    [path addLineToPoint:CGPointMake(0, self.topView.frame.size.height)];
    [path closePath];
    
    _firstWaveLayer.path = path.CGPath;
}

- (void)setSecondWaveLayerPath
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat y = _wavePointY;
    [path moveToPoint:CGPointMake(0, y)];
    for (float x = 0.0f; x <= _waveWidth; x += 5) {
        y = (_waveAmplitude -2) * sin(_waveCycle * x + _waveOffsetX ) + _wavePointY ;
        [path addLineToPoint:CGPointMake(x, y)];
    }
    [path addLineToPoint:CGPointMake(_waveWidth, self.topView.frame.size.height)];
    [path addLineToPoint:CGPointMake(0, self.topView.frame.size.height)];
    [path closePath];
    
    _secondeWaveLayer.path = path.CGPath;
}

#pragma mark Get
- (CAShapeLayer *)firstWaveLayer
{
    if (!_firstWaveLayer) {
        _firstWaveLayer = [CAShapeLayer layer];
        _firstWaveLayer.fillColor = [_waveColor CGColor];
    }
    return _firstWaveLayer;
}

- (CAShapeLayer *)secondeWaveLayer
{
    if (!_secondeWaveLayer) {
        _secondeWaveLayer = [CAShapeLayer layer];
        _secondeWaveLayer.fillColor = [_waveColor CGColor];
    }
    return _secondeWaveLayer;
}

- (CAShapeLayer *)firstRevelsalWaveLayer
{
    if (!_firstRevelsalWaveLayer) {
        _firstRevelsalWaveLayer = [CAShapeLayer layer];
        _firstRevelsalWaveLayer.fillColor = [_waveColor CGColor];
    }
    return _firstRevelsalWaveLayer;
}

- (CAShapeLayer *)secondRevelsalWaveLayer
{
    if (!_secondRevelsalWaveLayer) {
        _secondRevelsalWaveLayer = [CAShapeLayer layer];
        _secondRevelsalWaveLayer.fillColor = [_waveColor CGColor];
    }
    return _secondRevelsalWaveLayer;
}

- (CADisplayLink *)displayLink
{
    if (!_displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(changeCurrentWavePosition)];
    }
    return _displayLink;
}


@end
