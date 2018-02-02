//
//  YSKJ_MoveImageView.m
//  YSKJ_MATCH
//
//  Created by YSKJ on 17/11/7.
//  Copyright © 2017年 com.yskj. All rights reserved.
//

#import "YSKJ_MoveImageView.h"

#define UIColorFromHex(s)  [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1]

@implementation YSKJ_MoveImageView

-(id)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        
        [self addTarget:self action:@selector(cancleSelf) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(335, 75, 175, 40)];
        view.backgroundColor = UIColorFromHex(0x293136);
        view.layer.cornerRadius = 5;
        view.layer.masksToBounds = YES;
        [self addSubview:view];
        
        NSArray *imageNameArr = @[@"BringFor",@"Sendbackward",@"Top",@"bottom"];
        NSArray *heiNameArr = @[@"BringFor1",@"Sendbackward1",@"Top1",@"bottom1"];
        for (int i = 0; i<imageNameArr.count; i++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(175/4*i, 0, 175/4, 40)];
            button.tag = 100+i;
            [button addTarget:self action:@selector(moveAction:) forControlEvents:UIControlEventTouchUpInside];
            [button setImage:[UIImage imageNamed:imageNameArr[i]] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:heiNameArr[i]] forState:UIControlStateHighlighted];
            [view addSubview:button];
        }
        
    }
    
    return self;
}

-(void)cancleSelf
{
    [self removeFromSuperview];
}

-(void)moveAction:(UIButton*)sender
{
    if (self.block) {
        self.block(sender.tag-100);
    }
}

-(instancetype)show
{
    if ([self initWithFrame:CGRectMake(0, 0, [UIApplication sharedApplication].keyWindow.frame.size.width, [UIApplication sharedApplication].keyWindow.frame.size.height)]) {
        
    }
    return self;
}

+(void)showMoveView:(MoveBlock)block;
{
    YSKJ_MoveImageView *moveView = [[YSKJ_MoveImageView alloc] show];
    
    moveView.block = block;
    
    [[UIApplication sharedApplication].keyWindow addSubview:moveView];
    
}

@end
