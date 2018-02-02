//
//  YSKJ_OrderListTabCell.m
//  YSKJ_MATCH
//
//  Created by YSKJ on 18/1/10.
//  Copyright © 2018年 com.yskj. All rights reserved.
//

#import "YSKJ_OrderListTabCell1.h"

#define UIColorFromHex(s)  [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1]

@implementation YSKJ_OrderListTabCell1

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIButton *headImageBtn = [[UIButton alloc] initWithFrame:CGRectMake(32, 28, 80, 80)];
        _head = headImageBtn;
        [self addSubview:headImageBtn];
        
        UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(132, 15, 242, 24)];
        _nameLab = nameLab;
        nameLab.textColor = UIColorFromHex(0x333333);
        nameLab.font = [UIFont systemFontOfSize:16];
        [self addSubview:nameLab];
        
        UILabel *pinpai = [[UILabel alloc] initWithFrame:CGRectMake(132, 48, 200, 17)];
        pinpai.font = [UIFont systemFontOfSize:16];
        pinpai.textColor = UIColorFromHex(0x666666);
        _pinpaiLab = pinpai;
        [self addSubview:pinpai];
    
        UILabel *pinlei = [[UILabel alloc] initWithFrame:CGRectMake(132, 73, 200, 17)];
        pinlei.font = [UIFont systemFontOfSize:16];
        _pinleiLab = pinlei;
        pinlei.textColor = UIColorFromHex(0x666666);
        [self addSubview:pinlei];
        
        UILabel *space = [[UILabel alloc] initWithFrame:CGRectMake(405, 48, 200, 17)];
        space.font = [UIFont systemFontOfSize:16];
        space.textColor = UIColorFromHex(0x666666);
        _spaceLab = space;
        [self addSubview:space];
        
        UILabel *style = [[UILabel alloc] initWithFrame:CGRectMake(405, 73, 200, 17)];
        style.font = [UIFont systemFontOfSize:16];
        style.textColor = UIColorFromHex(0x666666);
        _styleLab = style;
        [self addSubview:style];
        
        UILabel *beizhu = [[UILabel alloc] initWithFrame:CGRectMake(132, 98, [UIScreen mainScreen].bounds.size.width - 150, 17)];
        beizhu.font = [UIFont systemFontOfSize:16];
        beizhu.textColor = UIColorFromHex(0x666666);
        _beizhuLab = beizhu;
        [self addSubview:beizhu];
        
        UILabel *money = [[UILabel alloc] initWithFrame:CGRectMake(707-32, 45, 100, 20)];
        money.font = [UIFont systemFontOfSize:16];
        money.textColor = UIColorFromHex(0x333333);
        _priceeLab = money;
        [self addSubview:money];
        
        UILabel *num = [[UILabel alloc] initWithFrame:CGRectMake(824-32, 45, 30, 20)];
        num.textAlignment = NSTextAlignmentCenter;
        num.font = [UIFont systemFontOfSize:16];
        _numLab = num;
        num.textColor = UIColorFromHex(0x333333);
        [self addSubview:num];
        
        UILabel *totailPrice = [[UILabel alloc] initWithFrame:CGRectMake(900, 45, 120, 20)];
        totailPrice.font = [UIFont systemFontOfSize:20];
        totailPrice.textColor = UIColorFromHex(0xf32a00);
        _totailePriceLab = totailPrice;
        [self addSubview:totailPrice];
        
    }
    
    return self;
}

-(void)setUrl:(NSString *)url
{
    _url = url;
    
    [self.head sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"loading1"]];
    
    //获取网络图片的Size
    [self.head.imageView sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:url] placeholderImage:nil options:(SDWebImageRetryFailed) progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        if (image.size.width>0&&image.size.height>0) {
            
            float imageW=self.head.frame.size.width;
            
            float scaleW1;
            if (image.size.width>=image.size.height) {
                scaleW1=imageW/image.size.width;
            }else{
                scaleW1=imageW/image.size.height;
            }
            
            self.head.imageEdgeInsets=UIEdgeInsetsMake((self.head.frame.size.height-scaleW1*(image.size.height))/2, (self.head.frame.size.width-scaleW1*(image.size.width))/2, (self.head.frame.size.height-scaleW1*(image.size.height))/2, (self.head.frame.size.width-scaleW1*(image.size.width))/2);
        }
        
    }];
    
}

-(void)setTotailePrice:(NSString *)totailePrice
{
    _totailePrice = totailePrice;
    _totailePriceLab.text = [NSString stringWithFormat:@"¥%@",totailePrice];
}

-(void)setModel:(YSKJ_orderModel *)model
{
    _model = model;
    
    if (model.name.length == 0) {
        model.name = @"-";
    }
    if (model.pinpai.length == 0) {
        model.pinpai = @"-";
    }
    if (model.pinlei.length == 0) {
        model.pinlei = @"-";
    }
    if (model.space.length == 0) {
        model.space = @"-";
    }
    if (model.style.length == 0) {
        model.style = @"-";
    }
    if (model.beizhu.length == 0) {
        model.beizhu = @"-";
    }
    if (model.price.length == 0) {
        model.price = @"0";
    }

    _nameLab.text = model.name;
    _pinpaiLab.text = [NSString stringWithFormat:@"品牌：%@",model.pinpai];
    _pinleiLab.text = [NSString stringWithFormat:@"品类：%@",model.pinlei];
    _spaceLab.text = [NSString stringWithFormat:@"空间：%@",model.space];
    _styleLab.text = [NSString stringWithFormat:@"风格：%@",model.style];
    _beizhuLab.text = [NSString stringWithFormat:@"备注：%@",model.beizhu];
    _priceeLab.text = [NSString stringWithFormat:@"¥%@",model.price];
    _numLab.text = [NSString stringWithFormat:@"x%@",model.count];
    
    [self showFaceImage:model.thumb_file];
    
}


-(void)showFaceImage:(NSString*)url
{
    [self.head sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"loading1"]];
    
    //获取网络图片的Size
    [self.head.imageView sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:url] placeholderImage:nil options:(SDWebImageRetryFailed) progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        if (image.size.width>0&&image.size.height>0) {
            
            float imageW=self.head.frame.size.width;
            
            float scaleW1;
            if (image.size.width>=image.size.height) {
                scaleW1=imageW/image.size.width;
            }else{
                scaleW1=imageW/image.size.height;
            }
            
            self.head.imageEdgeInsets=UIEdgeInsetsMake((self.head.frame.size.height-scaleW1*(image.size.height))/2, (self.head.frame.size.width-scaleW1*(image.size.width))/2, (self.head.frame.size.height-scaleW1*(image.size.height))/2, (self.head.frame.size.width-scaleW1*(image.size.width))/2);
        }
        
    }];
    
}


@end
