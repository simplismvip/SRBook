//
//  SRWIFIViewCell.m
//  SReader
//
//  Created by JunMing on 2020/6/12.
//  Copyright © 2020 JunMing. All rights reserved.
//

#import "SRWIFIViewCell.h"
@interface SRWIFIViewCell()
@property (nonatomic, weak) UILabel *textTitle;
@end
@implementation SRWIFIViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *textTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        textTitle.textAlignment = NSTextAlignmentLeft;
        textTitle.font = [UIFont fontWithName:@"Avenir-Light" size:15];
        textTitle.numberOfLines = 0;
        [self.contentView addSubview:textTitle];
        self.textTitle = textTitle;
    }
    return self;
}

- (void)setModel:(SRWIFIModel *)model {
    _model = model;
    if (model.ip_port) {
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:model.title];
        NSRange range = [model.title rangeOfString:model.ip_port];
        [text addAttribute:NSUnderlineStyleAttributeName value: [NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range];
        [text addAttributes:@{NSForegroundColorAttributeName:[UIColor orangeColor]} range:range];
        _textTitle.attributedText = text;
    }else {
        _textTitle.text = model.title;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat height = self.bounds.size.height;
    _textTitle.frame = CGRectMake(20, 0, self.bounds.size.width-40, height);
}
@end

#pragma SRWIFIModel
@implementation SRWIFIModel
- (CGFloat)cellHeight {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont fontWithName:@"Avenir-Light" size:15];
    CGSize maxSize = CGSizeMake(width - 40, MAXFLOAT);
    CGSize strSize = [self.title boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    return strSize.height + 20;
}
@end

#pragma SRWIFIView
@implementation SRWIFIView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        imageView.image = [UIImage imageNamed:@"wifi.png"];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:imageView];
        self.imageView = imageView;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(20, 10, self.bounds.size.width-40, self.bounds.size.height-20);
}

@end
