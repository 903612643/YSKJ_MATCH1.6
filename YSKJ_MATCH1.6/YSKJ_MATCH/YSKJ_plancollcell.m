//
//  YSKJ_plancollcell.m
//  YSKJ_MATCH
//
//  Created by YSKJ on 17/11/6.
//  Copyright © 2017年 com.yskj. All rights reserved.
//

#import "YSKJ_plancollcell.h"

#import "YSKJ_AlertView.h"

#import "ToolClass.h"

#import <SDWebImage/UIImageView+WebCache.h>

#import <SDWebImage/UIButton+WebCache.h>

#define URL @"http://octjlpudx.qnssl.com/"

#define UIColorFromHex(s)  [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1]

@implementation YSKJ_plancollcell

-(id) initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        
        UIButton *view = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 200, 120)];
        _face = view;
        view.backgroundColor = [UIColor whiteColor];
        view.adjustsImageWhenHighlighted = NO;
        [self addSubview:view];
        
        UIButton *update = [[UIButton alloc] initWithFrame:CGRectMake(18, 18, 36, 36)];
        update.backgroundColor = UIColorFromHex(0x00abf2);
        [update setImage:[UIImage imageNamed:@"editPlan"] forState:UIControlStateNormal];
        _editBtn = update;
        update.layer.cornerRadius = 4;
        update.layer.masksToBounds = YES;
        update.layer.borderColor = UIColorFromHex(0x008bc5).CGColor;
        update.layer.borderWidth = 1;
        [self addSubview:update];
        
        UIButton *delete = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-54, 18, 36, 36)];
        _delBtn = delete;
        delete.backgroundColor = [UIColor whiteColor];
        [delete setImage:[UIImage imageNamed:@"deletePlan"] forState:UIControlStateNormal];
        delete.layer.borderColor = UIColorFromHex(0xc7c7c7).CGColor;
        delete.layer.borderWidth = 1;
        delete.layer.cornerRadius = 4;
        delete.layer.masksToBounds = YES;
        [self addSubview:delete];
        
        UILabel *planName = [[UILabel alloc] initWithFrame:CGRectMake(10, view.frame.origin.y + view.frame.size.height + 8, self.frame.size.width - 20, 22)];
        _nameLab = planName;
        planName.textColor = UIColorFromHex(0x666666);
        planName.textAlignment = NSTextAlignmentLeft;
        planName.font = [UIFont systemFontOfSize:16];
        [self addSubview:planName];
        
        UILabel *date = [[UILabel alloc] initWithFrame:CGRectMake(10, self.frame.size.height - 24, self.frame.size.width - 20, 20)];
        _dateLab = date;
        date.textColor = UIColorFromHex(0xb1c0c8);
        date.textAlignment = NSTextAlignmentLeft;
        date.font = [UIFont systemFontOfSize:14];
        [self addSubview:date];
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        
    }
    
    return self;
    
}

-(void)setName:(NSString *)name
{
    _name = name;
    self.nameLab.text = name;
}

-(void)setDateStr:(NSString *)dateStr
{
    _dateStr = dateStr;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"YYYY-MM-dd hh:mm:ss";
    NSString *dateString = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[dateStr intValue]]];
    self.dateLab.text = dateString;
}

-(void)setDataInfo:(NSString *)dataInfo
{
    _dataInfo = dataInfo;
    
    NSDictionary *dict = [ToolClass dictionaryWithJsonString:dataInfo];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL,[dict objectForKey:@"url"]];
    
    [_face sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"loading2"]];
    
    
}

-(void)setEdit:(NSString *)edit
{
    _edit = edit;
    if ([edit integerValue] == 1) {
        _editBtn.hidden = NO;
        _delBtn.hidden = NO;
    }else{
        _editBtn.hidden = YES;
        _delBtn.hidden = YES;
    }
}



@end
