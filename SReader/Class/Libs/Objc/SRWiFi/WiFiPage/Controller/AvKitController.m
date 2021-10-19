//
//  AvKitController.m
//  eBooks
//
//  Created by JunMing on 2020/3/4.
//  Copyright © 2020 赵俊明. All rights reserved.
//

#import "AvKitController.h"
#import "VideoPlayerContainerView.h"
//#import <YYKit/YYKit.h>
#import <UMMobClick/MobClick.h>

@interface AvKitController ()
@property(weak, nonatomic) VideoPlayerContainerView *vpcView;
@end

@implementation AvKitController

- (void)viewDidLoad {
    [super viewDidLoad];
    [MobClick event:@"set_wifiChuanShu_guide"];
//    self.view.backgroundColor = [UIColor colorWithHexString:@"#383838"];
    CGFloat w = self.view.bounds.size.width;
    CGFloat h = self.view.bounds.size.height-88;
    VideoPlayerContainerView *vpcView = [[VideoPlayerContainerView alloc]initWithFrame:CGRectMake(0, 44, w, h)];
    vpcView.center = self.view.center;
    vpcView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:vpcView];
    self.vpcView = vpcView;
    
    __weak __typeof(&*self)weakSelf = self;
    vpcView.playfinish = ^(BOOL finish) {
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    
    UIButton *btnAction = [UIButton buttonWithType:(UIButtonTypeSystem)];
    btnAction.frame = CGRectMake(10, 44, 44, 44);
    [btnAction addTarget:self action:@selector(closeAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [btnAction setImage:[UIImage imageNamed:@"navbar_close_icon_black"] forState:(UIControlStateNormal)];
    [btnAction setTintColor:[UIColor whiteColor]];
    [self.view addSubview:btnAction];
}

- (void)setUrlVideo:(NSString *)urlVideo {
    _vpcView.urlVideo = urlVideo;
}

- (void)closeAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
