//
//  YSKJ_ListDetailHeaderView.m
//  YSKJ_MATCH
//
//  Created by YSKJ on 18/1/19.
//  Copyright © 2018年 com.yskj. All rights reserved.
//

#import "YSKJ_ListDetailHeaderView.h"

@implementation YSKJ_ListDetailHeaderView

-(id)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(32, 32, 140, 60)];
        imageview.image = [UIImage imageNamed:@"loading3"];
        [self addSubview:imageview];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width - 144)/2, 100, 200, 56)];
        title.textColor = UIColorFromHex(0x333333);
        title.font = [UIFont systemFontOfSize:36];
        title.text = @"方案清单";
        [self addSubview:title];
        
        UILabel *planName = [[UILabel alloc] initWithFrame:CGRectMake(32, 206, 300, 25)];
        self.planNameLab = planName;
        planName.font = [UIFont systemFontOfSize:18];
        [self addSubview:planName];
        
        UILabel *addess = [[UILabel alloc] initWithFrame:CGRectMake(32, 252, 300, 25)];
        addess.text = [NSString stringWithFormat:@"地址："];
        addess.font = [UIFont systemFontOfSize:18];
        [self addSubview:addess];
        
        UILabel *date = [[UILabel alloc] initWithFrame:CGRectMake(700, 206, 300, 25)];
        NSDate *nowDate = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy年MM月dd日";
        NSString *dateStr = [formatter stringFromDate:nowDate];
        date.text = [NSString stringWithFormat:@"订货日期：%@",dateStr];
        date.font = [UIFont systemFontOfSize:18];
        [self addSubview:date];
        
        UILabel *user = [[UILabel alloc] initWithFrame:CGRectMake(700, 252, 300, 25)];
        user.text = [NSString stringWithFormat:@"客户："];
        user.font = [UIFont systemFontOfSize:18];
        [self addSubview:user];
        
        UILabel *phone = [[UILabel alloc] initWithFrame:CGRectMake(840, 252, 300, 25)];
        phone.text = [NSString stringWithFormat:@"电话："];
        phone.font = [UIFont systemFontOfSize:18];
        [self addSubview:phone];
        
        UILabel *proName = [[UILabel alloc] initWithFrame:CGRectMake(166, 317, 100, 25)];
        proName.text = [NSString stringWithFormat:@"商品名称"];
        proName.font = [UIFont systemFontOfSize:18];
        [self addSubview:proName];
        
        UILabel *detail = [[UILabel alloc] initWithFrame:CGRectMake(415, 317, 100, 25)];
        detail.text = [NSString stringWithFormat:@"详细信息"];
        detail.font = [UIFont systemFontOfSize:18];
        [self addSubview:detail];
        
        UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(670, 317, 100, 25)];
        price.text = [NSString stringWithFormat:@"单价"];
        price.font = [UIFont systemFontOfSize:18];
        [self addSubview:price];
        
        UILabel *num = [[UILabel alloc] initWithFrame:CGRectMake(790, 317, 100, 25)];
        num.text = [NSString stringWithFormat:@"数量"];
        num.font = [UIFont systemFontOfSize:18];
        [self addSubview:num];
        
        UILabel *totaile = [[UILabel alloc] initWithFrame:CGRectMake(910, 317, 100, 25)];
        totaile.text = [NSString stringWithFormat:@"总价"];
        totaile.font = [UIFont systemFontOfSize:18];
        [self addSubview:totaile];

    }
    return self;
}
-(void)setName:(NSString *)name
{
    _name = name;
    self.planNameLab.text = [NSString stringWithFormat:@"方案清单：%@",name];
}

@end
