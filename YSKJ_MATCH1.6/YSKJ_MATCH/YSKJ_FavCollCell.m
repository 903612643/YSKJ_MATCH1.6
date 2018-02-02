//
//  YSKJ_FavCollCell.m
//  YSKJ_MATCH
//
//  Created by YSKJ on 18/1/22.
//  Copyright © 2018年 com.yskj. All rights reserved.
//

#import "YSKJ_FavCollCell.h"

#import <SDWebImage/UIButton+WebCache.h>
#import <SDWebImage/UIImageView+WebCache.h>

#define UIColorFromHex(s)  [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1]

@implementation YSKJ_FavCollCell

-(id)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(13, 13,self.frame.size.width - 26, self.frame.size.width - 26)];
        bgView.backgroundColor = UIColorFromHex(0xf2f2f2);
        [self addSubview:bgView];
        
        self.button = [[UIButton alloc]initWithFrame:bgView.bounds];
        [bgView addSubview:self.button];
        
        self.panBut = [[UIButton alloc] initWithFrame:CGRectMake(40, (self.frame.size.height-40)/2-10, self.frame.size.width-80, 40)];
        self.panBut.alpha = 0.03;
        [self addSubview:self.panBut];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self.panBut addGestureRecognizer:pan];
        
        UIButton *addBut = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-12-36, 12, 36, 36)];
        [addBut setImage:[UIImage imageNamed:@"AddTo"] forState:UIControlStateNormal];
        addBut.backgroundColor = [UIColor clearColor];
        [addBut addTarget:self action:@selector(addToCanvas:) forControlEvents:UIControlEventTouchUpInside];
        addBut.layer.cornerRadius = 5;
        addBut.layer.masksToBounds = YES;
        [self addSubview:addBut];
        
        UIButton *favBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 12, 36, 36)];
        favBtn.backgroundColor = [UIColor clearColor];
        _favBtn = favBtn;
        favBtn.layer.cornerRadius = 5;
        favBtn.layer.masksToBounds = YES;
        [self addSubview:favBtn];
        
        self.titleLable=[[UILabel alloc] initWithFrame:CGRectMake(11, bgView.frame.origin.y + bgView.frame.size.height+8, self.button.frame.size.width, 20)];
        self.titleLable.textAlignment= NSTextAlignmentLeft;
        self.titleLable.font = [UIFont systemFontOfSize:14];
        self.titleLable.textColor=UIColorFromHex(0x666666);
        [self addSubview:self.titleLable];
        
        self.moneyLab=[[UILabel alloc] initWithFrame:CGRectMake(11, self.titleLable.frame.origin.y + self.titleLable.frame.size.height, self.button.frame.size.width, 20)];
        self.moneyLab.textAlignment= NSTextAlignmentLeft;
        self.moneyLab.font = [UIFont systemFontOfSize:12];
        self.moneyLab.textColor=UIColorFromHex(0x666666);
        [self addSubview:self.moneyLab];
    }
    
    return self;
}

-(void)setFav:(NSString *)fav
{
    _fav = fav;
    if ([fav isEqualToString:@"Y"]) {
        
        [ _favBtn  setImage:[UIImage imageNamed:@"isFav1"] forState:UIControlStateNormal];
        _favBtn.selected = YES;
        
    }else{
        [ _favBtn  setImage:[UIImage imageNamed:@"isFav"] forState:UIControlStateNormal];
        _favBtn.selected = NO;
    }
    
}

-(void)setUrl:(NSString *)url{
    
    _url = url;
    
    [self.button sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"loading1"]];
    
    [self.panBut sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal placeholderImage:nil];
    
    //获取网络图片的Size
    [self.button.imageView sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:url] placeholderImage:nil options:(SDWebImageRetryFailed) progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        if (image.size.width>0&&image.size.height>0) {
            
            float imageW=self.frame.size.width - 40;
            float imageW1=self.frame.size.width - 60;
            float scaleW,scaleW1;
            if (image.size.width>=image.size.height) {
                scaleW=imageW/image.size.width;
                scaleW1=imageW1/image.size.width;
            }else{
                scaleW=imageW/image.size.height;
                scaleW1=imageW1/image.size.height;
            }
            
            self.button.frame = CGRectMake((self.button.superview.frame.size.width-scaleW*image.size.width)/2, (self.button.superview.frame.size.height-scaleW*image.size.height)/2, scaleW*image.size.width, scaleW*image.size.height);
            
            self.panBut.imageEdgeInsets=UIEdgeInsetsMake((self.panBut.frame.size.height-scaleW1*(image.size.height))/2, (self.panBut.frame.size.width-scaleW1*(image.size.width))/2, (self.panBut.frame.size.height-scaleW1*(image.size.height))/2, (self.panBut.frame.size.width-scaleW1*(image.size.width))/2);
        }
        
    }];
    
}

-(void)setTitle:(NSString *)title
{
    _title=title;
    
    if (title.length>25) {
        NSString *subString=[title substringToIndex:25.5];
        self.titleLable.text=subString;
    }else{
        self.titleLable.text=title;
    }
    
}

-(void)setMoney:(NSString *)money
{
    _money = money;
    if ([money containsString:@"."]) {        //是否包含"."
        
        self.moneyLab.text=[NSString stringWithFormat:@"¥%@",money];
        
    } else {
        
        if (money.length>3) {
            
            NSInteger inde=money.length-3;
            NSRange ranges = {inde,0};
            NSString *subStr = [money stringByReplacingCharactersInRange:ranges withString:@","];
            self.moneyLab.text=[NSString stringWithFormat:@"¥%@",subStr];
            
        }else{
            
            self.moneyLab.text=[NSString stringWithFormat:@"¥%@",money];
            
        }
    }
}

-(void)addToCanvas:(UIButton*)sender
{
    UICollectionViewCell *cell = (UICollectionViewCell*)sender.superview;
    
    NSIndexPath *indexPath = [(UICollectionView*)cell.superview indexPathForCell:cell];
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(favGetRow:)]) {
        [self.delegate favGetRow:indexPath.row];
    }
}

-(void)setObjDict:(NSDictionary *)objDict
{
    _objDict = objDict;
}

-(void)pan:(UIPanGestureRecognizer*)ges
{
    
    NSDictionary *dict = @{@"ges":ges,
                           @"button":ges.view,
                           @"dict":self.objDict
                           };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"panNotification" object:nil userInfo:dict];
    
    if (ges.state == UIGestureRecognizerStateBegan) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"beganPanNotification" object:nil userInfo:dict];
    }
    
    if (ges.state == UIGestureRecognizerStateEnded || ges.state == UIGestureRecognizerStateFailed){
        
        UIImageView *imageView = [[UIImageView alloc] init];
        //获取网络图片的Size
        [imageView sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:[self.objDict objectForKey:@"thumb_file"]] placeholderImage:nil options:(SDWebImageRetryFailed) progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
        } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            
            if (image.size.width>0 && image.size.height>0) {
                [self.objDict setValue:[NSString stringWithFormat:@"%f",image.size.width] forKey:@"netW"];
                [self.objDict setValue:[NSString stringWithFormat:@"%f",image.size.height] forKey:@"netH"];
            }else{
                [self.objDict setValue:@800 forKey:@"netW"];
                [self.objDict setValue:@800 forKey:@"netH"];
            }
            
            
        }];
        
        NSDictionary *dict = @{@"ges":ges,
                               @"button":ges.view,
                               @"dict":self.objDict
                               };
        [[NSNotificationCenter defaultCenter] postNotificationName:@"endPanNotification" object:nil userInfo:dict];
        
    }
    
}


@end
