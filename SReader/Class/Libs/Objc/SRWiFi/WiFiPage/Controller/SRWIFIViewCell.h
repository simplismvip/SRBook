//
//  SRWIFIViewCell.h
//  SReader
//
//  Created by JunMing on 2020/6/12.
//  Copyright © 2020 JunMing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface SRWIFIModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *ip_port;
- (CGFloat)cellHeight;
@end

@interface SRWIFIViewCell : UITableViewCell
@property (nonatomic, strong) SRWIFIModel *model;
@end

@interface SRWIFIView : UIView
@property (nonatomic, strong) UIImageView *imageView;
@end


NS_ASSUME_NONNULL_END
