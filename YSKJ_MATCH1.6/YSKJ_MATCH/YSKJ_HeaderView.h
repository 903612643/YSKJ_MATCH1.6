//
//  YSKJ_HeaderView.h
//  YSKJ_MATCH
//
//  Created by YSKJ on 18/1/22.
//  Copyright © 2018年 com.yskj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSKJ_HeaderView : UIView

typedef void (^selectIndexBlock)(NSInteger selectIndex);

@property (nonatomic, copy) selectIndexBlock selectBlock;

@property (nonatomic ,copy) NSArray *titeleArray;

@property (nonatomic, strong) UIButton *addBtn;

@property (nonatomic, strong) UIButton *editList;


@end
