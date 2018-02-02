//
//  YSKJ_NoneDataView.m
//  YSKJ_MATCH
//
//  Created by YSKJ on 18/1/22.
//  Copyright © 2018年 com.yskj. All rights reserved.
//

#import "YSKJ_NoneDataView.h"

#define UIColorFromHex(s)  [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1]

@implementation YSKJ_NoneDataView

-(id)initWithFrame:(CGRect)frame
{
    if (self ==[super initWithFrame:frame]) {
        
        UIImageView *nonePro = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - 290)/2, 235-54, 290, 200)];
        nonePro.image = [UIImage imageNamed:@"nonePlan"];
        [self addSubview:nonePro];
        
        UILabel *noneTitle =[[UILabel alloc] initWithFrame:CGRectMake(0, 421, self.frame.size.width, 20)];
        noneTitle.textAlignment = NSTextAlignmentCenter;
        _titleLab = noneTitle;
        noneTitle.textColor = UIColorFromHex(0xb1c0c8);
        noneTitle.font = [UIFont systemFontOfSize:14];
        [self addSubview:noneTitle];

    }
    return self;
}

-(void)setTitle:(NSString *)title{
    _title = title;
    _titleLab.text = title;
}

@end
