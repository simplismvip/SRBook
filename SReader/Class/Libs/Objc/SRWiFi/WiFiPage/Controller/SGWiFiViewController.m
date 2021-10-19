//
//  SGWiFiViewController.m
//  SGWiFiUpload
//
//  Created by soulghost on 30/6/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import "SGWiFiViewController.h"
#import "HTTPServer.h"
#import "HYBIPHelper.h"
#import "SGWiFiUploadManager.h"
#import "AvKitController.h"
//#import <Zip/Zip.h>
// #import <SSZipArchive/SSZipArchive.h>
#import "VideoPlayerContainerView.h"
#import "SRWIFIViewCell.h"

@interface SGWiFiViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UILabel *alertLabel;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property(assign, nonatomic) BOOL isUpload;
@end

@implementation SGWiFiViewController
static NSString *ID = @"WiFi";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = [NSMutableArray array];
    self.title = @"Wi-Fi传书";
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray *items = @[@"1、Wi-Fi传书需要两个设备连接同一网络，请确保手机和另一台设备连接相同Wi-Fi。",
                       @"2、在另一台设备上打开地址输入栏，点击复制并在地址输入栏上输入IP地址：",
                       @"3、选择要上传的EPUB电子书文件（只支持EPUB格式文件上传，其他格式文件会自动过滤）。",
                       @"4、选择文件后点击提交按钮，等待EPUB电子书上传完成。",
                       @"5、在手机APP中查看并阅读上传完毕的EPUB电子书。"];
    for (NSString *title in items) {
        SRWIFIModel *model = [[SRWIFIModel alloc] init];
        model.title = title;
        [self.dataSource addObject:model];
    }
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
    [tableView registerClass:[SRWIFIViewCell class] forCellReuseIdentifier:ID];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.sectionHeaderHeight = 0;
    tableView.sectionFooterHeight = 0;
    tableView.separatorColor = tableView.backgroundColor;
    tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    SRWIFIView *imageView = [[SRWIFIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 150)];
    tableView.tableHeaderView = imageView;
    
    UILabel *alertLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.view addSubview:alertLabel];
    self.alertLabel = alertLabel;
    alertLabel.text = @"⚠️：传书过程中不要退出本页面！";
    alertLabel.textColor = [UIColor orangeColor];
    alertLabel.textAlignment = NSTextAlignmentCenter;
    alertLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:11];
    [self setupViews];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64);
    self.alertLabel.frame = CGRectMake(0, CGRectGetMaxY(self.tableView.frame), self.view.bounds.size.width, 34);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 开启返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

// fix bug: https://juejin.im/post/5e8f1239e51d4546cf777d3b
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 开启返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    
    SRWIFIModel *model = _dataSource[1];
    SGWiFiUploadManager *mgr = [SGWiFiUploadManager sharedManager];
    HTTPServer *server = mgr.httpServer;
    if (server.isRunning) {
        if ([HYBIPHelper deviceIPAdress] == nil) {
            model.ip_port = @"⚠️错误, 该设备没有链接Wi-Fi。";
            model.title = [NSString stringWithFormat:@"%@%@",model.title,model.ip_port];
        }else {
            model.ip_port = [NSString stringWithFormat:@"http://%@:%@",mgr.ip,@(mgr.port)];
            model.title = [NSString stringWithFormat:@"%@\n%@",model.title,model.ip_port];
        }
    } else {
        model.ip_port = @"⚠️错误, 服务器已经停止！";
        model.title = [NSString stringWithFormat:@"%@%@",model.title,model.ip_port];
    }
    [self.tableView reloadData];
}

- (void)setupViews {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nextback"] style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    UIButton *btnAction = [UIButton buttonWithType:(UIButtonTypeSystem)];
    btnAction.frame = CGRectMake(0, 0, 44, 44);
    [btnAction addTarget:self action:@selector(askAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [btnAction setImage:[UIImage imageNamed:@"help"] forState:(UIControlStateNormal)];
    [btnAction setTintColor:[UIColor blackColor]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnAction];
    self.navigationItem.rightBarButtonItem.customView = btnAction;
}

#pragma mark - UITableViewDataSource && UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SRWIFIViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {cell = [[SRWIFIViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID];}
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SRWIFIModel *model = self.dataSource[indexPath.row];
    return [model cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SRWIFIModel *model = self.dataSource[indexPath.row];
    if (model.ip_port && [model.ip_port hasPrefix:@"http"]) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"复制地址成功" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = model.ip_port;
        }];
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:nil];
        [alertVC addAction:cancle];
        [alertVC addAction:sure];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
}

- (void)dismiss {
    if (self.isUpload) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"请稍后..." message:@"正在上传文件" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil];
        [alertVC addAction:cancle];
        [self presentViewController:alertVC animated:YES completion:nil];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
        if (self.dismissBlock) { self.dismissBlock(); }
    }
}

- (void)startUpload:(NSString *)fileName {
    self.title = [NSString stringWithFormat:@"正在接收%@...",fileName];
    self.isUpload = YES;
    
    UIView *cusView = self.navigationItem.rightBarButtonItem.customView;
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
    [cusView addSubview:activityIndicator];
    activityIndicator.frame = cusView.bounds;
    activityIndicator.color = [UIColor redColor];
    activityIndicator.backgroundColor = [UIColor clearColor];
    activityIndicator.hidesWhenStopped = NO;
    [activityIndicator startAnimating];
}

- (void)stopUpload:(NSString *)fileName {
    self.title = [NSString stringWithFormat:@"%@接收完毕！",fileName];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.title = @"Wi-Fi传书📖";
        self.isUpload = NO;
        UIView *cusView = self.navigationItem.rightBarButtonItem.customView;
        for (UIView *subView in cusView.subviews) {
            if ([subView isKindOfClass:[UIActivityIndicatorView class]]) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)subView;
                        [activityIndicator stopAnimating];
                        [subView removeFromSuperview];
                    });
                });
            }
        }
    });
}

- (void)askAction:(UIButton *)sender {
    AvKitController *videoVC = [AvKitController new];
    videoVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:videoVC animated:YES completion:nil];
    videoVC.urlVideo = @"http://www.restcy.com/source/guide_01.mp4";
}

@end


