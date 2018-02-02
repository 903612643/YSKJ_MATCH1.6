//
//  YSKJ_SaveAlertView.h
//  YSKJ_MATCH
//
//  Created by YSKJ on 17/11/13.
//  Copyright © 2017年 com.yskj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^saveBlock)(void);

typedef void (^cancleBlock)(void);

@interface YSKJ_SaveAlertView : UIButton

@property (nonatomic, strong) UILabel *saveLab;

@property (nonatomic, strong) UILabel *cancleLab;

@property (nonatomic, copy)cancleBlock cancleBlock;

@property (nonatomic, copy)saveBlock saveBlock;

+(void)showSaveAlertCancleBlock:(cancleBlock)cancleBlock saveBlock:(saveBlock)saveBlock;

@end
