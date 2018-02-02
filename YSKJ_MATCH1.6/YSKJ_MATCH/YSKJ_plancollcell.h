//
//  YSKJ_plancollcell.h
//  YSKJ_MATCH
//
//  Created by YSKJ on 17/11/6.
//  Copyright © 2017年 com.yskj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSKJ_plancollcell : UICollectionViewCell

@property (nonatomic, strong) UIButton *face;

@property(nonatomic,strong)UILabel *nameLab;
@property (nonatomic,strong)UILabel *dateLab;

@property (nonatomic, strong)UIButton *delBtn;

@property (nonatomic, strong)UIButton *editBtn;


@property (nonatomic, copy)NSString *name;

@property (nonatomic, copy)NSString *dateStr;

@property (nonatomic, copy)NSString *dataInfo;

@property (nonatomic,copy)NSString *edit;


@end
