//
//  YSKJ_UilityCollCell.m
//  YSKJ_MATCH
//
//  Created by YSKJ on 17/11/6.
//  Copyright © 2017年 com.yskj. All rights reserved.
//

#import "YSKJ_UilityCollCell.h"

#define UIColorFromHex(s)  [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1]

@implementation YSKJ_UilityCollCell

-(id)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        
        self.backgroundColor = UIColorFromHex(0xb76e51);
        
        self.layer.cornerRadius = 5;
        
        self.layer.masksToBounds = YES;
        
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - 40)/2, 44, 40, 40)];
        imageView.image = [UIImage imageNamed:@"spabg"];
        [self addSubview:imageView];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.frame.size.width, 22)];
        title.text = @"空间背景";
        title.textColor = [UIColor whiteColor];
        title.textAlignment = NSTextAlignmentCenter;
        title.font = [UIFont systemFontOfSize:16];
        [self addSubview:title];
        
        
        
    }
    return self;
}
@end
