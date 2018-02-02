//
//  YSKJ_MyLoadProduct.h
//  YSKJ_MATCH
//
//  Created by YSKJ on 17/12/18.
//  Copyright © 2017年 com.yskj. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YSKJ_LoadCollCell.h"

#import <MJExtension/MJExtension.h>

#import "YSKJ_ProModel.h"

#import "YSKJ_UploadInput.h"

#import "YSKJ_TipViewCalss.h"

#import "YSKJ_SaveWebImageClass.h"

#import "NSString+MD5.h"

#import <Qiniu/QiniuSDK.h>

#import "YSKJ_CanvasLoading.h"

#import "YSKJ_DrawData.h"

#import "YSKJ_AlertView.h"

#import <SDWebImage/UIImageView+WebCache.h>

#import "YSKJ_HeaderView.h"

#import "YSKJ_FavCollCell.h"

#import "YSKJ_NoneDataView.h"

#define API_DOMAIN @"www.5164casa.com/api/assist" //正式服务器

#define GETTOKEN @"http://"API_DOMAIN@"/sysconfig/gettoken" //得到token

#define ADDPRO @"http://"API_DOMAIN@"/store/add" //添加

#define DELPRO @"http://"API_DOMAIN@"/store/delprduct" //添加

#define ADDFAV  @"http://"API_DOMAIN@"/store/addfav"

#define DELFAV  @"http://"API_DOMAIN@"/store/delfav"

@interface YSKJ_MyLoadProduct : UIView<UICollectionViewDataSource,UICollectionViewDelegate,YSKJ_LoadCollCellDelegate,YSKJ_FavCollCellDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    NSMutableArray *_data,*_favData;
    UICollectionView *_colletionView,*_favColletionView;
    
    
    YSKJ_UploadInput *input;
    
    YSKJ_HeaderView *_headerView;
    
    YSKJ_LoadCollCell *cell;
    
    YSKJ_FavCollCell *_favCell;
    
    UIView *coverView;
    
    UIImage *_proImage;
    
    YSKJ_NoneDataView *_none;
    YSKJ_NoneDataView *_favNone;
}

@property(assign ,nonatomic)BOOL http;

@end
