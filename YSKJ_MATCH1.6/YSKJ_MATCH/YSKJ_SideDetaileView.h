//
//  YSKJ_SideDetaileView.h
//  YSKJ_MATCH
//
//  Created by YSKJ on 17/10/31.
//  Copyright © 2017年 com.yskj. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YSKJ_DetailTbCell.h"

#import "YSKJ_CateoryTbCell.h"

#import "YSKJ_SerLbLayout.h"

#import "YSKJ_SegView.h"

#import "YSKJ_SerLabCollectionViewCell.h"

#import "YSKJ_ParamModel.h"

#import "YSKJ_SerReslutView.h"

#import "AnimatedGif.h"


@interface YSKJ_SideDetaileView : UIButton<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,DetailTbDelegate,UICollectionViewDataSource,UICollectionViewDelegate,YSKJ_SerLayoutDelegate,YSKJ_CateoryTbCellDelegate,YSKJ_SerReslutViewDelegate>
{
    NSMutableArray *_dataSoure;
    
    YSKJ_DetailTbCell *_detailTbCell;
    
    YSKJ_CateoryTbCell *_CateoryTbCell;
    
    NSMutableArray *_serchArr;
    
    NSMutableArray *_serchLength;
    
    UIView *_loadListView;
    
}

@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UICollectionView *serLabCollectionView;

@property (nonatomic, strong) NSMutableArray* titles;

@property (nonatomic , strong) UIButton *selfReturn;

@property (nonatomic , strong) UITextField *serchTextf;

@property (nonatomic, strong) NSMutableArray* styleArr;
@property (nonatomic, strong) NSMutableArray* spaceArr;
@property (nonatomic, strong) NSMutableArray* categoryArr;
@property (nonatomic, strong) NSMutableArray* sourceArr;

@property (nonatomic, strong) NSMutableArray* floatArr;

@property (nonatomic , strong) YSKJ_SegView *seg;

@property (nonatomic , strong) YSKJ_ParamModel *paramModel;

@property (nonatomic,retain)NSMutableArray *addDataArr;

@property (nonatomic, strong) YSKJ_SerReslutView *serResultView;


@end
