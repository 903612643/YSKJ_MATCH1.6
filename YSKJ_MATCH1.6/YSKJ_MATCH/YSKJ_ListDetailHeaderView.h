//
//  YSKJ_ListDetailHeaderView.h
//  YSKJ_MATCH
//
//  Created by YSKJ on 18/1/19.
//  Copyright © 2018年 com.yskj. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UIColorFromHex(s)  [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1]

@interface YSKJ_ListDetailHeaderView : UIView

@property (nonatomic,strong) UILabel *planNameLab;

@property (nonatomic,copy)NSString *name;

@end
