//
//  YSKJ_OrderListTabCell.m
//  YSKJ_MATCH
//
//  Created by YSKJ on 18/1/10.
//  Copyright © 2018年 com.yskj. All rights reserved.
//

#import "YSKJ_OrderListTabCell.h"



#define UIColorFromHex(s)  [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1]

@implementation YSKJ_OrderListTabCell

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
         
         UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 120,[UIScreen mainScreen].bounds.size.width, 10)];
         
         footView.backgroundColor = UIColorFromHex(0xf8f8f8);
         
         [self addSubview:footView];
         
         UIButton *checkBtn = [[UIButton alloc] initWithFrame:CGRectMake(16, 46, 28, 28)];
         checkBtn.selected = YES;
         _checkBtn = checkBtn;
         [self addSubview:checkBtn];
         
         UIButton *headImageBtn = [[UIButton alloc] initWithFrame:CGRectMake(68, 20, 80, 80)];
         _head = headImageBtn;
         [self addSubview:headImageBtn];
         
         UITextField *nameTextFild = [[UITextField alloc] initWithFrame:CGRectMake(158, 20, 242, 24)];
         nameTextFild.borderStyle = UITextBorderStyleNone;
         _nameTextf = nameTextFild;
         nameTextFild.enabled = NO;
         nameTextFild.delegate = self;
         nameTextFild.font = [UIFont systemFontOfSize:14];
         [self addSubview:nameTextFild];
         
         UILabel *pinpai = [[UILabel alloc] initWithFrame:CGRectMake(158, 53, 45, 17)];
         pinpai.text = @"品牌：";
         pinpai.font = [UIFont systemFontOfSize:12];
         pinpai.textColor = UIColorFromHex(0x666666);
         [self addSubview:pinpai];
         
         UITextField *pinpaiTef = [[UITextField alloc] initWithFrame:CGRectMake(194, 53, 206, 20)];
         pinpaiTef.borderStyle = UITextBorderStyleNone;
         pinpaiTef.placeholder = @"请输入品牌名称";
         pinpaiTef.enabled = NO;
         _pinpaiTextf = pinpaiTef;
         pinpaiTef.delegate = self;
         pinpaiTef.textColor = UIColorFromHex(0x666666);
         pinpaiTef.font = [UIFont systemFontOfSize:12];
         [self addSubview:pinpaiTef];
         
         UILabel *pinlei = [[UILabel alloc] initWithFrame:CGRectMake(158, 83, 45, 17)];
         pinlei.text = @"品类：";
         pinlei.font = [UIFont systemFontOfSize:12];
         pinlei.textColor = UIColorFromHex(0x666666);
         [self addSubview:pinlei];
         
         UITextField *pinleiTef = [[UITextField alloc] initWithFrame:CGRectMake(194, 80, 206, 20)];
         pinleiTef.borderStyle = UITextBorderStyleNone;
         pinleiTef.placeholder = @"请输入品类名称";
         pinleiTef.enabled = NO;
          _pinleiTextf = pinleiTef;
         pinleiTef.delegate = self;
         pinleiTef.font = [UIFont systemFontOfSize:12];
         pinleiTef.textColor = UIColorFromHex(0x666666);
         [self addSubview:pinleiTef];
         
         UILabel *space = [[UILabel alloc] initWithFrame:CGRectMake(437, 20, 45, 17)];
         space.text = @"空间：";
         space.font = [UIFont systemFontOfSize:12];
         space.textColor = UIColorFromHex(0x666666);
         [self addSubview:space];
         
         UITextField *spaceTef = [[UITextField alloc] initWithFrame:CGRectMake(473, 20, 206, 20)];
         spaceTef.borderStyle = UITextBorderStyleNone;
         spaceTef.placeholder = @"请输入空间名称";
         spaceTef.enabled = NO;
         spaceTef.delegate = self;
         spaceTef.font = [UIFont systemFontOfSize:12];
         spaceTef.textColor = UIColorFromHex(0x666666);
         _spaceTextf = spaceTef;
         [self addSubview:spaceTef];
         
         UILabel *style = [[UILabel alloc] initWithFrame:CGRectMake(437, 53, 45, 17)];
         style.text = @"风格：";
         style.font = [UIFont systemFontOfSize:12];
         style.textColor = UIColorFromHex(0x666666);
         [self addSubview:style];
         
         UITextField *styleTef = [[UITextField alloc] initWithFrame:CGRectMake(473, 53, 206, 20)];
         styleTef.borderStyle = UITextBorderStyleNone;
         styleTef.textColor = UIColorFromHex(0x666666);
         styleTef.placeholder = @"请输入风格名称";
         styleTef.enabled = NO;
         _styleTextf = styleTef;
         styleTef.delegate = self;
         styleTef.font = [UIFont systemFontOfSize:12];
         [self addSubview:styleTef];
         
         UILabel *beizhu = [[UILabel alloc] initWithFrame:CGRectMake(437, 83, 45, 17)];
         beizhu.text = @"备注：";
         beizhu.font = [UIFont systemFontOfSize:12];
         beizhu.textColor = UIColorFromHex(0x666666);
         [self addSubview:beizhu];
         
         UITextField *beizhuTef = [[UITextField alloc] initWithFrame:CGRectMake(473, 80, 206, 20)];
         beizhuTef.borderStyle = UITextBorderStyleNone;
         beizhuTef.textColor = UIColorFromHex(0x666666);
         beizhuTef.placeholder = @"请输入备注";
         beizhuTef.enabled = NO;
         _beizhuTextf = beizhuTef;
         beizhuTef.delegate = self;
         beizhuTef.font = [UIFont systemFontOfSize:12];
         [self addSubview:beizhuTef];
         
         UILabel *money = [[UILabel alloc] initWithFrame:CGRectMake(707, 50, 9, 20)];
         money.text = @"¥";
         money.font = [UIFont systemFontOfSize:14];
         money.textColor = UIColorFromHex(0x00abf2);
         [self addSubview:money];
         
         UITextField *moneyTef = [[UITextField alloc] initWithFrame:CGRectMake(720, 48, 65, 24)];
         moneyTef.borderStyle = UITextBorderStyleNone;
         moneyTef.enabled = NO;
         moneyTef.font = [UIFont systemFontOfSize:14];
         _priceeTextf = moneyTef;
         moneyTef.delegate = self;
         moneyTef.keyboardType = UIKeyboardTypePhonePad;
         moneyTef.textColor = UIColorFromHex(0x00abf2);
         [self addSubview:moneyTef];
         
         UIButton *lessen = [[UIButton alloc] initWithFrame:CGRectMake(795, 48, 24, 24)];
         [lessen setImage:[UIImage imageNamed:@"Reduce"] forState:UIControlStateNormal];
         lessen.adjustsImageWhenDisabled = NO;
         _lessen = lessen;
         [self addSubview:lessen];
         
         UILabel *num = [[UILabel alloc] initWithFrame:CGRectMake(824, 50, 30, 20)];
         num.textAlignment = NSTextAlignmentCenter;
         num.font = [UIFont systemFontOfSize:14];
         _numLab = num;
         num.textColor = UIColorFromHex(0x333333);
         [self addSubview:num];
         
         UIButton *add = [[UIButton alloc] initWithFrame:CGRectMake(860, 48, 24, 24)];
         [add setImage:[UIImage imageNamed:@"Plus"] forState:UIControlStateNormal];
         _add = add;
         [self addSubview:add];
         
         UILabel *totailPrice = [[UILabel alloc] initWithFrame:CGRectMake(935, 50, 80, 20)];
         totailPrice.font = [UIFont systemFontOfSize:14];
         totailPrice.textColor = UIColorFromHex(0x00abf2);
         _totailePriceLab = totailPrice;
         [self addSubview:totailPrice];
         
         UIButton *editBtn = [[UIButton alloc] initWithFrame:CGRectMake(696, 82, 44, 44)];
         [editBtn setImage:[UIImage imageNamed:@"editCell"] forState:UIControlStateNormal];
         _editBtn = editBtn;
         [self addSubview:editBtn];
         
         UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(707, 100, 37, 20)];
         [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
         sureBtn.backgroundColor = UIColorFromHex(0x00abf2);
         sureBtn.titleLabel.font = [UIFont systemFontOfSize:12];
         sureBtn.layer.cornerRadius = 3;
         sureBtn.layer.masksToBounds = YES;
         _surnBtn = sureBtn;
         sureBtn.hidden = YES;
         [sureBtn setTitleColor:UIColorFromHex(0xffffff) forState:UIControlStateNormal];
         [self addSubview:sureBtn];

         
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

-(void)setSelect:(BOOL)select
{
    _checkBtn.selected = select;
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
    if ([model.check integerValue] == 1) {
        [_checkBtn setImage:[UIImage imageNamed:@"check1"] forState:UIControlStateNormal];
        
    }else{
        [_checkBtn setImage:[UIImage imageNamed:@"Unchecked"] forState:UIControlStateNormal];
    }
    
    if ([model.count integerValue]== 1) {
        
        _lessen.enabled = NO;
        
    }else{
        
        _lessen.enabled = YES;
        
    }
    
    
    _nameTextf.text = model.name;
    _pinpaiTextf.text = model.pinpai;
    _pinleiTextf.text = model.pinlei;
    _spaceTextf.text = model.space;
    _styleTextf.text = model.style;
    _beizhuTextf.text = model.beizhu;
    _priceeTextf.text = model.price;
    _numLab.text = model.count;
    
    [self showFaceImage:model.thumb_file];
    
    [self showEditState:model.edit];
    
}

-(void)showEditState:(NSString*)edit
{
    if ([edit integerValue] == 1) {
        _nameTextf.borderStyle = UITextBorderStyleRoundedRect;
        _nameTextf.enabled = YES;
        _pinpaiTextf.borderStyle = UITextBorderStyleRoundedRect;
        _pinpaiTextf.enabled = YES;
        _pinleiTextf.borderStyle = UITextBorderStyleRoundedRect;
        _pinleiTextf.enabled = YES;
        _spaceTextf.borderStyle = UITextBorderStyleRoundedRect;
        _spaceTextf.enabled = YES;
        _styleTextf.borderStyle = UITextBorderStyleRoundedRect;
        _styleTextf.enabled = YES;
        _beizhuTextf.borderStyle = UITextBorderStyleRoundedRect;
        _beizhuTextf.enabled = YES;
        _priceeTextf.borderStyle = UITextBorderStyleRoundedRect;
        _priceeTextf.enabled = YES;
        _surnBtn.hidden = NO;
        _editBtn.hidden = YES;
        
    }else{
        
        _nameTextf.borderStyle = UITextBorderStyleNone;
        _nameTextf.enabled = NO;
        _pinpaiTextf.borderStyle = UITextBorderStyleNone;
        _pinpaiTextf.enabled = NO;
        _pinleiTextf.borderStyle = UITextBorderStyleNone;
        _pinleiTextf.enabled = NO;
        _spaceTextf.borderStyle = UITextBorderStyleNone;
        _spaceTextf.enabled = NO;
        _styleTextf.borderStyle = UITextBorderStyleNone;
        _styleTextf.enabled = NO;
        _beizhuTextf.borderStyle = UITextBorderStyleNone;
        _beizhuTextf.enabled = NO;
        _priceeTextf.borderStyle = UITextBorderStyleNone;
        _priceeTextf.enabled = NO;
        _surnBtn.hidden = YES;
        _editBtn.hidden = NO;
        
    }
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
