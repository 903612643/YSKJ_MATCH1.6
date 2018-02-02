//
//  YSKJ_PinCanvasView.m
//  YSKJ_MATCH
//
//  Created by YSKJ on 17/12/7.
//  Copyright © 2017年 com.yskj. All rights reserved.
//

#import "YSKJ_PinCanvasView.h"

#define UIColorFromHex(s)  [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1]

@implementation YSKJ_PinCanvasView

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithRed:47.013/255.0 green:47.013/255.0 blue:47.013/255.0 alpha:0.6];
        self.layer.cornerRadius = 8;
        self.layer.masksToBounds = YES;
        
        UIButton *canvasNature = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [canvasNature setImage:[UIImage imageNamed:@"recovery"] forState:UIControlStateNormal];
        _nature = canvasNature;
        [canvasNature setImage:[UIImage imageNamed:@"recovery1"] forState:UIControlStateHighlighted];
        [self addSubview:canvasNature];
        
        UIButton *subtract = [[UIButton alloc] initWithFrame:CGRectMake(32+13, 0, 32, 44)];
        _subtract = subtract;
        _subtract.tag = 101;
        [subtract setTitle:@"—" forState:UIControlStateNormal];
        [subtract setTitleColor:UIColorFromHex(0x00abf2) forState:UIControlStateHighlighted];
        subtract.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [self addSubview:subtract];
        
        UILabel *scale = [[UILabel alloc] initWithFrame:CGRectMake(32*2+13*2 - 7, 0, 44, 44)];
        scale.text = @"100%";
        _valueLab = scale;
        scale.font = [UIFont boldSystemFontOfSize:16];
        scale.textColor = [UIColor whiteColor];
        [self addSubview:scale];
        
        UIButton *add = [[UIButton alloc] initWithFrame:CGRectMake(168-44, 0, 44, 44)];
        [add setTitle:@"＋" forState:UIControlStateNormal];
        _add = add;
        _add.tag = 102;
        add.titleLabel.font = [UIFont boldSystemFontOfSize:30];
        [add setTitleColor:UIColorFromHex(0x00abf2) forState:UIControlStateHighlighted];
        [self addSubview:add];

    }
    return self;
}

-(void)setScaleValue:(int)scaleValue
{
    _scaleValue = scaleValue;
    
    _valueLab.text = [NSString stringWithFormat:@"%d%@",scaleValue,@"%"];
    
}



@end
