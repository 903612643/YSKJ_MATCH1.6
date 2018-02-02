//
//  YSKJ_LoadCollCell.h
//  YSKJ_MATCH
//
//  Created by YSKJ on 17/12/18.
//  Copyright © 2017年 com.yskj. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HttpRequestCalss.h"

#define API_DOMAIN @"www.5164casa.com/api/assist"                  //正式服务器
#define PICURL @"http://odso4rdyy.qnssl.com"                    //图片固定地址
#define UPLOADLIST  @"http://"API_DOMAIN@"/store/mylist"    //单品列表
#define FAVLIST  @"http://"API_DOMAIN@"/store/favlist"    //收藏列表



@protocol YSKJ_LoadCollCellDelegate <NSObject>

@optional

-(void)getRow:(NSInteger)row;

-(void)deleteRow:(NSInteger)row;

@end


@interface YSKJ_LoadCollCell : UICollectionViewCell

@property (strong, nonatomic)UIButton *button;
@property (strong, nonatomic)UILabel *titleLable;
@property (strong, nonatomic)UILabel *moneyLab;

@property (strong, nonatomic)UIButton *panBut;

@property (copy, nonatomic)NSString *url;
@property (copy, nonatomic)NSString *title;
@property (copy, nonatomic)NSString *money;

@property (strong, nonatomic)UIButton *favBtn;

@property (strong, nonatomic)UIButton *addBtn;

@property (strong, nonatomic)UIButton *delBtn;

@property (nonatomic, copy)NSDictionary *objDict;

@property (nonatomic, copy)NSString *fav;

@property (nonatomic, copy)NSString *edit;

@property (nonatomic, retain) id <YSKJ_LoadCollCellDelegate>delegate;

@end
