//
//  YSKJ_AlertView.h
//  YSKJ_MATCH
//
//  Created by YSKJ on 17/11/6.
//  Copyright © 2017年 com.yskj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^cancleBlock)(void);

typedef void (^finishBlock)(void);

@interface YSKJ_AlertView : UIView

@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) UILabel *contentLab;

@property (nonatomic, copy)cancleBlock cancleBlock;

@property (nonatomic, copy)finishBlock finishBlock;

@property (nonatomic, strong) UITextField *nameTextf;

+(void)showAlertTitle:(NSString*)title content:(NSString*)content cancleBlock:(cancleBlock)cancleBlock finishBlock:(finishBlock)finishBlock;


@end
