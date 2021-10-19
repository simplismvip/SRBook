//
//  VideoPlayerContainerView.h
//  eBooks
//
//  Created by JunMing on 2020/3/4.
//  Copyright © 2020 赵俊明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^playFinish)(BOOL finish);
@interface VideoPlayerContainerView : UIView
@property (nonatomic, strong) NSString *urlVideo;
@property(copy, nonatomic) playFinish playfinish;


-(void)dealloc;
@end

NS_ASSUME_NONNULL_END
