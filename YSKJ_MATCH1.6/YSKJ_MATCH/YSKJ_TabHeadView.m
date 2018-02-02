//
//  YSKJ_TabHeadView.m
//  YSKJ_MATCH
//
//  Created by YSKJ on 18/1/11.
//  Copyright © 2018年 com.yskj. All rights reserved.
//

#import "YSKJ_TabHeadView.h"

#define UIColorFromHex(s)  [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1]

@implementation YSKJ_TabHeadView

-(id)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        
        self.backgroundColor = UIColorFromHex(0xf8f8f8);
        
        UILabel *planName = [[UILabel alloc] initWithFrame:CGRectMake(32, 40, self.frame.size.width-32, 22)];
        _planNameLab = planName;
        planName.font = [UIFont systemFontOfSize:16];
        planName.textColor = UIColorFromHex(0x333333);
        [self addSubview:planName];
        
        UILabel *proName = [[UILabel alloc] initWithFrame:CGRectMake(152, 10, 80, 20)];
        proName.text = @"商品名称";
        proName.font = [UIFont systemFontOfSize:14];
        [self addSubview:proName];
        
        UILabel *detail = [[UILabel alloc] initWithFrame:CGRectMake(437, 10, 80, 20)];
        detail.text = @"详细信息";
        detail.font = [UIFont systemFontOfSize:14];
        [self addSubview:detail];
        
        UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(707, 10, 30, 20)];
        price.text = @"单价";
        price.font = [UIFont systemFontOfSize:14];
        [self addSubview:price];
        
        UILabel *num = [[UILabel alloc] initWithFrame:CGRectMake(822, 10, 30, 20)];
        num.text = @"数量";
        num.font = [UIFont systemFontOfSize:14];
        [self addSubview:num];
        
        UILabel *totailPrice = [[UILabel alloc] initWithFrame:CGRectMake(935, 10, 30, 20)];
        totailPrice.text = @"总价";
        totailPrice.font = [UIFont systemFontOfSize:14];
        [self addSubview:totailPrice];
        
    }
    return self;
}

-(void)setPlanName:(NSString *)planName{
    _planName = planName;
    _planNameLab.text = [NSString stringWithFormat:@"方案名称：%@",planName];
}
@end
