//
//  VideoPlayerToolsView.m
//  eBooks
//
//  Created by JunMing on 2020/3/4.
//  Copyright © 2020 赵俊明. All rights reserved.
//

#import "VideoPlayerToolsView.h"

@implementation VideoPlayerToolsView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self createUI];//创建UI
    }
    return self;
}

#pragma mark - 创建UI
-(void)createUI{
    [self addSubview:self.bCheck];//开始暂停按钮
    [self addSubview:self.bufferPV];//缓冲条
    [self addSubview:self.progressSr];//创建进度条
    [self addSubview:self.lTime];//视频时间
}

#pragma mark - 视频时间
-(UILabel *)lTime{
    
    if (!_lTime) {
        _lTime = [UILabel new];
        _lTime.frame = CGRectMake(CGRectGetMaxX(_progressSr.frame) + 20, 0, self.frame.size.width - CGRectGetWidth(_progressSr.frame) - 40 - CGRectGetWidth(_bCheck.frame), self.frame.size.height);
        _lTime.text = @"00:00/00:00";
        _lTime.textColor = [UIColor whiteColor];
        _lTime.textAlignment = NSTextAlignmentCenter;
        _lTime.font = [UIFont systemFontOfSize:12];
        _lTime.adjustsFontSizeToFitWidth = YES;
    }
    return _lTime;
}

#pragma mark - 创建进度条
-(UISlider *)progressSr{
    
    if (!_progressSr) {
        _progressSr = [UISlider new];
        _progressSr.frame = CGRectMake(CGRectGetMinX(_bufferPV.frame) - 2, CGRectGetMidY(_bufferPV.frame) - 10, CGRectGetWidth(_bufferPV.frame) - 4, 20);
        _progressSr.maximumTrackTintColor = [UIColor clearColor];
        _progressSr.minimumTrackTintColor = [UIColor whiteColor];
        [_progressSr setThumbImage:[UIImage imageNamed:@"point"] forState:0];
    }
    return _progressSr;
}

#pragma mark - 缓冲条
-(UIProgressView *)bufferPV{
    if (!_bufferPV) {
        _bufferPV = [UIProgressView new];
        _bufferPV.frame = CGRectMake(CGRectGetMaxX(_bCheck.frame) + 20, CGRectGetMidY(_bCheck.frame) - 2, 200, 4);
        _bufferPV.trackTintColor = [UIColor grayColor];
        _bufferPV.progressTintColor = [UIColor cyanColor];
    }
    return _bufferPV;
    
}

#pragma mark - 开始暂停按钮
-(UIButton *)bCheck{
    if (!_bCheck) {
        _bCheck = [UIButton new];
        _bCheck.frame = CGRectMake(0, 0, self.frame.size.height, self.frame.size.height);
        [_bCheck setImage:[UIImage imageNamed:@"video_pause"] forState:0];
        [_bCheck addTarget:self action:@selector(btnCheckSelect:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bCheck;
    
}

- (void)btnCheckSelect:(UIButton *)sender{
    sender.selected = !sender.isSelected;
    if (sender.selected) {
        [_bCheck setImage:[UIImage imageNamed:@"video_player"] forState:0];
    }else{
        [_bCheck setImage:[UIImage imageNamed:@"video_pause"] forState:0];
    }
    
    if ([_delegate respondsToSelector:@selector(playButtonWithStates:)]) {
        [_delegate playButtonWithStates:sender.selected];
    }
}

- (void)playStates:(BOOL)status {
    if (status) {
        [_bCheck setImage:[UIImage imageNamed:@"video_pause"] forState:0];
    }else{
        [_bCheck setImage:[UIImage imageNamed:@"video_player"] forState:0];
    }
}

@end
