//
//  YSKJ_SerReslutView.h
//  YSKJ_MATCH
//
//  Created by YSKJ on 17/11/3.
//  Copyright © 2017年 com.yskj. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YSKJ_SerResCollCell.h"

#import <SDWebImage/UIImageView+WebCache.h>

#import <MJExtension/MJExtension.h>

#import "YSKJ_drawModel.h"

#define API_DOMAIN @"www.5164casa.com/api/assist"                  //正式服务器
#define PICURL @"http://odso4rdyy.qnssl.com"                    //图片固定地址
#define SHOPLISTURL  @"http://"API_DOMAIN@"/store/list"    //列表

@protocol YSKJ_SerReslutViewDelegate <NSObject>

@optional

-(void)addProToDrawBoard:(YSKJ_drawModel*)model withDict:(NSDictionary *)dict;

@end

@interface YSKJ_SerReslutView : UIView<UICollectionViewDataSource,UICollectionViewDelegate,YSKJ_SerResCollCellDelegate>
{
    NSMutableArray *_data;
    
    UIImageView *_none;
    
    UILabel *_noneTitle;
}

@property (nonatomic, strong) UICollectionView* collect;

@property (nonatomic, retain) NSDictionary *paramDict;


@property (nonatomic , retain) id <YSKJ_SerReslutViewDelegate>delegate;

@property (nonatomic, assign) float collViewHei;

@property (nonatomic, assign)int removeAllObj;


@end
