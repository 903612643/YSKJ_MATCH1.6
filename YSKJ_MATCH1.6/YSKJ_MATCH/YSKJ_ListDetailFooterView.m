//
//  YSKJ_ListDetailFooterView.m
//  YSKJ_MATCH
//
//  Created by YSKJ on 18/1/19.
//  Copyright © 2018年 com.yskj. All rights reserved.
//

#import "YSKJ_ListDetailFooterView.h"

#define UIColorFromHex(s)  [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1]

@implementation YSKJ_ListDetailFooterView


-(id)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        
        UILabel *procount = [[UILabel alloc] initWithFrame:CGRectMake(600, 97, 150, 28)];
        procount.font = [UIFont systemFontOfSize:20];
        _countLab = procount;
        [self addSubview:procount];
        
        UILabel *totail  = [[UILabel alloc] initWithFrame:CGRectMake(800, 97, 60, 28)];
        totail.text = @"总计：";
        [self addSubview:totail];
        
        UILabel *totailPrice = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 120 - 60, 48, 120, 124)];
        totailPrice.textColor = UIColorFromHex(0xf32a00);
        totailPrice.textAlignment = NSTextAlignmentRight;
        _priceLab = totailPrice;
        [self addSubview:totailPrice];
        
        UILabel *user = [[UILabel alloc ] initWithFrame:CGRectMake(600, 150, 150, 20)];
        user.font = [UIFont systemFontOfSize:15];
        user.text = @"客户负责人：";
        [self addSubview:user];
        
        UILabel *phone = [[UILabel alloc ] initWithFrame:CGRectMake(800, 150, 60, 20)];
        phone.font = [UIFont systemFontOfSize:15];
        phone.text = @"电话：";
        [self addSubview:phone];
        
        UILabel *adderss = [[UILabel alloc ] initWithFrame:CGRectMake(600, 190, 350, 20)];
        adderss.font = [UIFont systemFontOfSize:15];
        adderss.text = @"公司地址：深圳市福田区车公庙14A";
        [self addSubview:adderss];
        
        UILabel *adderssPhone = [[UILabel alloc ] initWithFrame:CGRectMake(870, 190, 200, 20)];
        adderssPhone.font = [UIFont systemFontOfSize:15];
        adderssPhone.text = @"电话：13476897254";
        [self addSubview:adderssPhone];
        
        UILabel *userName = [[UILabel alloc ] initWithFrame:CGRectMake(600, 243, 200, 20)];
        userName.font = [UIFont systemFontOfSize:20];
        userName.text = @"客户签字：";
        [self addSubview:userName];

        
        
    }
    return self;
}

-(void)setCount:(NSString *)count
{
    _count = count;
    self.countLab.text = [NSString stringWithFormat:@"已有%@件商品",count];
}

-(void)setPrice:(float )price
{
    _price = price;
    _priceLab.text = [NSString stringWithFormat:@"¥%0.2f",price];
}

@end
