//
//  YSKJ_SingleDetailView.h
//  YSKJ_MATCH
//
//  Created by YSKJ on 17/11/9.
//  Copyright © 2017年 com.yskj. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AnimatedGif.h"

#import "YSKJ_drawModel.h"

#define API_DOMAIN @"www.5164casa.com/api/assist"                  //正式服务器
#define ADDFAV  @"http://"API_DOMAIN@"/store/addfav"
#define DELFAV  @"http://"API_DOMAIN@"/store/delfav"

@interface YSKJ_SingleDetailView : UIView<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
{
    UITableView *_tableView;
    
    NSMutableArray *_dataSource;
    
    NSMutableArray *_sampleData;
    
    float collcellHei;
    
    UIView *_noneView;
    
    NSInteger _selectIndex;
    
    NSDictionary *_proInfoDict;
    
    UIImage *panImage;
    
    float panScale;
    
    UIImageView *_noSameImageView;
    UILabel *_noSameTitleLab;
    
    UIButton *_retArrow;
    
    BOOL _showTag;
    
    NSMutableArray *_hositroyArr;
    
    UILabel *_name,*_price;
    
}

@property (nonatomic, strong) UICollectionView* singleCellView;

@property (nonatomic, strong) UICollectionView* sampleCellView;

@property (nonatomic, strong)UILabel *tipLab;

@property (nonatomic, copy)YSKJ_drawModel *model;

@property (nonatomic, copy)UIButton *proBut;

@property (nonatomic, copy)NSString *url;

@property (nonatomic, copy)NSString *tipTitle;

@end
