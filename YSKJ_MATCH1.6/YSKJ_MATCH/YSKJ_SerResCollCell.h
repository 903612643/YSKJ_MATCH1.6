//
//  YSKJ_SerResCollCell.h
//  YSKJ_MATCH
//
//  Created by YSKJ on 17/11/3.
//  Copyright © 2017年 com.yskj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpRequestCalss.h"

#define API_DOMAIN @"www.5164casa.com/api/assist"                  //正式服务器
#define ADDFAV  @"http://"API_DOMAIN@"/store/addfav"    
#define DELFAV  @"http://"API_DOMAIN@"/store/delfav"  

@protocol YSKJ_SerResCollCellDelegate <NSObject>

@optional

-(void)getRow:(NSInteger)row;

-(void)fav:(NSInteger)row boolFav:(BOOL)fav;

@end

@interface YSKJ_SerResCollCell : UICollectionViewCell

@property (strong, nonatomic)UIButton *button;
@property (strong, nonatomic)UILabel *titleLable;
@property (strong, nonatomic)UILabel *moneyLab;

@property (strong, nonatomic)UIButton *panBut;

@property (strong, nonatomic)UIButton *favBtn;

@property (copy, nonatomic)NSString *url;
@property (copy, nonatomic)NSString *title;
@property (copy, nonatomic)NSString *money;

@property (nonatomic, copy)NSDictionary *objDict;

@property (nonatomic, retain) id <YSKJ_SerResCollCellDelegate>delegate;

@end
