//
//  YSKJ_OrderListTabCell.h
//  YSKJ_MATCH
//
//  Created by YSKJ on 18/1/10.
//  Copyright © 2018年 com.yskj. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <SDWebImage/UIButton+WebCache.h>
#import <SDWebImage/UIImageView+WebCache.h>

#import "YSKJ_orderModel.h"

@interface YSKJ_OrderListTabCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic, strong) UIButton *head;

@property (nonatomic, strong) UITextField *nameTextf;

@property (nonatomic, strong) UIButton *checkBtn;

@property (nonatomic, strong) UITextField *pinpaiTextf;

@property (nonatomic, strong) UITextField *pinleiTextf;

@property (nonatomic, strong) UITextField *spaceTextf;

@property (nonatomic, strong) UITextField *styleTextf;

@property (nonatomic, strong) UITextField *beizhuTextf;

@property (nonatomic, strong) UITextField *priceeTextf;

@property (nonatomic, strong) UIButton *lessen;

@property (nonatomic, strong) UILabel *numLab;

@property (nonatomic, strong) UIButton *add;

@property (nonatomic, strong) UILabel *totailePriceLab;

@property (nonatomic, strong) UIButton *editBtn;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *check;

@property (nonatomic, copy) NSString *pinPai;

@property (nonatomic, copy) NSString *pinLei;

@property (nonatomic, copy) NSString *space;

@property (nonatomic, copy) NSString *style;

@property (nonatomic, copy) NSString *beizhu;

@property (nonatomic, copy) NSString *price;

@property (nonatomic, copy) NSString *num;

@property (nonatomic, copy) NSString *totailePrice;

@property (nonatomic, strong) UIButton *surnBtn;

@property (nonatomic, assign) BOOL select;

@property (nonatomic, copy) NSString* edit;

@property (nonatomic, copy) YSKJ_orderModel *model;

@end
