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

@interface YSKJ_OrderListTabCell1 : UITableViewCell<UITextFieldDelegate>

@property (nonatomic, strong) UIButton *head;

@property (nonatomic, strong) UILabel *nameLab;

@property (nonatomic, strong) UILabel *pinpaiLab;

@property (nonatomic, strong) UILabel *pinleiLab;

@property (nonatomic, strong) UILabel *spaceLab;

@property (nonatomic, strong) UILabel *styleLab;

@property (nonatomic, strong) UILabel *beizhuLab;

@property (nonatomic, strong) UILabel *priceeLab;

@property (nonatomic, strong) UILabel *numLab;

@property (nonatomic, strong) UILabel *totailePriceLab;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *totailePrice;

@property (nonatomic, copy) YSKJ_orderModel *model;

@end
