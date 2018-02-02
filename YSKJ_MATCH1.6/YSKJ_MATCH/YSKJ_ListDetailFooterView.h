//
//  YSKJ_ListDetailFooterView.h
//  YSKJ_MATCH
//
//  Created by YSKJ on 18/1/19.
//  Copyright © 2018年 com.yskj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSKJ_ListDetailFooterView : UIView

@property (nonatomic, strong)UILabel *countLab;
@property (nonatomic, strong)UILabel *priceLab;

@property (nonatomic, copy)NSString *count;
@property (nonatomic, assign)float price;

@end
