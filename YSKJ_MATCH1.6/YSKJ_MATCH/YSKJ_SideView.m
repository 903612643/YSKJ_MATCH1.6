//
//  YSKJ_SideView.m
//  YSKJ_MATCH
//
//  Created by YSKJ on 17/10/31.
//  Copyright © 2017年 com.yskj. All rights reserved.
//

#import "YSKJ_SideView.h"

#define UIColorFromHex(s)  [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1]

@implementation YSKJ_SideView

-(id)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        
        self.sideButtonArr = [[NSMutableArray alloc] init];
        
        self.backgroundColor = UIColorFromHex(0x293136);
        
        image = @[@"search",@"SingleProduct",@"programme",@"AuxiliaryEffect",@"details"];
        image1 = @[@"search1",@"SingleProduct1",@"programme1",@"AuxiliaryEffect1",@"details1"];
        
        for (int i = 0; i<image.count; i++) {
            
            UIButton *but = [[UIButton alloc] initWithFrame:CGRectMake(0, 50+i*50 +28*i, 50, 50)];
            but.tag = 100+i;
            [but addTarget:self action:@selector(choose:) forControlEvents:UIControlEventTouchUpInside];
            [but setImage:[UIImage imageNamed:image[i]] forState:UIControlStateNormal];
            [but setImage:[UIImage imageNamed:image1[i]] forState:UIControlStateHighlighted];
            [self addSubview:but];
            
            [self.sideButtonArr addObject:but];
            
        }
        
    }
    
    return self;
}

- (void)choose:(UIButton *)sender{
    
    for (int i = 0; i < image.count; i++) {
        
        UIButton *btn = (UIButton *)[[sender superview] viewWithTag:100 + i];
        
        //选中当前按钮时
        if (sender.tag == btn.tag) {
            
            btn.backgroundColor = UIColorFromHex(0x354048);
            [btn setImage:[UIImage imageNamed:image1[i]] forState:UIControlStateNormal];
            sender.selected = !sender.selected;
            
        }else{
            
            btn.backgroundColor = [UIColor clearColor];
            [btn setImage:[UIImage imageNamed:image[i]] forState:UIControlStateNormal];
            [btn setSelected:NO];
        }
        
        
    }
    
    if (self.selectBlock) {
        self.selectBlock(sender.tag - 100,sender);
    }

    
}

@end
