//
//  YSKJ_SerLabCollectionViewCell.m
//  YSKJ_MATCH
//
//  Created by YSKJ on 17/11/2.
//  Copyright © 2017年 com.yskj. All rights reserved.
//

#import "YSKJ_SerLabCollectionViewCell.h"

#define UIColorFromHex(s)  [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1]

@implementation YSKJ_SerLabCollectionViewCell

-(id)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        
        self.lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - 26, self.frame.size.height)];
        self.lable.font = [UIFont systemFontOfSize:14];
        self.lable.textColor = [UIColor whiteColor];
        [self addSubview:self.lable];
        
        self.line = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width - 26, 0, 1, self.frame.size.height)];
        self.line.backgroundColor = UIColorFromHex(0x1384b4);
        [self addSubview:self.line];
        
        self.backgroundColor = UIColorFromHex(0x00abf2);
        
        self.deleteItem = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 26, 0, 26, self.frame.size.height)];
        [self.deleteItem setImage:[UIImage imageNamed:@"del"] forState:UIControlStateNormal];
        [self addSubview:self.deleteItem];
        
    }
    
    return self;
}

-(void)setTitle:(NSString *)title{
    _title = title;
    self.lable.text = title;
}

-(void)setDeleWidth:(float)deleWidth{
    
    _deleWidth = deleWidth;
    
    self.deleteItem.frame = CGRectMake(self.frame.size.width - 26, 0, deleWidth, self.frame.size.height);
    
    self.line.frame = CGRectMake(self.frame.size.width - 26, 0, 1, self.frame.size.height);
    
    self.lable.frame = CGRectMake(0, 0, self.frame.size.width - 26, self.frame.size.height);
    
}


@end
