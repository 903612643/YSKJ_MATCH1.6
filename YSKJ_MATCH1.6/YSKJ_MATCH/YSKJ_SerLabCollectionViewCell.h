//
//  YSKJ_SerLabCollectionViewCell.h
//  YSKJ_MATCH
//
//  Created by YSKJ on 17/11/2.
//  Copyright © 2017年 com.yskj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSKJ_SerLabCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *lable;

@property (nonatomic, strong) UIButton *deleteItem;

@property (nonatomic, strong) UIView *line;

@property (nonatomic, retain) NSString *title;

@property (nonatomic ,assign)float deleWidth;

@end
