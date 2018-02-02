//
//  YSKJ_OrderPopWindow.h
//  YSKJ
//
//  Created by YSKJ on 17/7/27.
//  Copyright © 2017年 5164casa.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^tagBlock)(void);

typedef void (^copyBlock)(NSString *url);

typedef void (^openUrlBlock)(NSString *url);

@interface YSKJ_OrderPopWindow : UIView

@property (nonatomic , strong)UIView *popView;

@property (nonatomic,strong) UILabel *titleLab;

@property (nonatomic,strong) UIImageView *triangleImageView;

@property (nonatomic,strong) UITextField *urlText;

@property (nonatomic,retain) NSString *title;

@property (nonatomic,retain) NSString *url;

@property (nonatomic, copy)tagBlock tagBlock;

@property (nonatomic, copy)copyBlock copyBlock;

@property (nonatomic, copy)openUrlBlock openUrlBlock;


+(void)showPopViewWithTitle:(NSString*)title triangleX:(CGFloat)triangleX CopyBlock:(copyBlock)copyBlock openUrlBlock:(openUrlBlock)openUrlBlock tagBlock:(tagBlock)tagBlock;


@end
