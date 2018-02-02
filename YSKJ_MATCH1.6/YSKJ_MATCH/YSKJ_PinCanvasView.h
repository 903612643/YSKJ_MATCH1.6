//
//  YSKJ_PinCanvasView.h
//  YSKJ_MATCH
//
//  Created by YSKJ on 17/12/7.
//  Copyright © 2017年 com.yskj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSKJ_PinCanvasView : UIView

@property (nonatomic, strong) UIButton *nature;
@property (nonatomic, strong) UIButton *subtract;
@property (nonatomic, strong) UIButton *add;
@property (nonatomic, strong) UILabel *valueLab;

@property (nonatomic, assign) int scaleValue;

@end
