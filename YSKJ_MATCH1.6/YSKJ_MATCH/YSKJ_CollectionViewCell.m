//
//  OJLCollectionViewCell.m
//  OJLLabelLayout
//
//  Created by oujinlong on 16/6/12.
//  Copyright © 2016年 oujinlong. All rights reserved.
//

#import "YSKJ_CollectionViewCell.h"

#define UIColorFromHex(s)  [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1]

@interface YSKJ_CollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *label;

@end
@implementation YSKJ_CollectionViewCell

-(void)setTitle:(NSString *)title{
    self.label.textColor = UIColorFromHex(0x666666);
    self.label.text = title;
}

@end
