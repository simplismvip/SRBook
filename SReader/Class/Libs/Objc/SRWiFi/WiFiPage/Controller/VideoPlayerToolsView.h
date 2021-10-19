//
//  VideoPlayerToolsView.h
//  eBooks
//
//  Created by JunMing on 2020/3/4.
//  Copyright © 2020 赵俊明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol VideoPlayerToolsViewDelegate <NSObject>
-(void)playButtonWithStates:(BOOL)state;
@end

@interface VideoPlayerToolsView : UIView
@property (nonatomic, strong) UIButton *bCheck;//播放暂停按钮
@property (nonatomic, strong) UISlider *progressSr;//进度条
@property (nonatomic, strong) UIProgressView *bufferPV;//缓冲条
@property (nonatomic, strong) UILabel *lTime;//时间进度和总时长
@property (nonatomic, weak) id<VideoPlayerToolsViewDelegate> delegate;
- (void)playStates:(BOOL)status;
@end

NS_ASSUME_NONNULL_END
