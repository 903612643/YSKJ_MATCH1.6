//
//  YSKJ_OrderListViewController.h
//  YSKJ_MATCH
//
//  Created by YSKJ on 18/1/10.
//  Copyright © 2018年 com.yskj. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YSKJ_OrderListTabCell.h"

#import "YSKJ_TabHeadView.h"

#import "HttpRequestCalss.h"

#import "ToolClass.h"

#import "YSKJ_OrderListTabCell1.h"

#define API_DOMAIN @"www.5164casa.com/api/assist"                  //正式服务器

#define DETAIL @"http://"API_DOMAIN@"/store/detail"  //商品详情

#import "YSKJ_orderModel.h"

#import <MJExtension/MJExtension.h>

#import "YSKJ_SaveWebImageClass.h"

#import "HttpRequestCalss.h"

#define API_DOMAIN @"www.5164casa.com/api/assist" //正式服务器

#define GETTOKEN @"http://"API_DOMAIN@"/sysconfig/gettoken" //得到token

#import <Qiniu/QiniuSDK.h>

#import "NSString+MD5.h"

#import "YSKJ_OrderPopWindow.h"

#define QINIU @"http://octjlpudx.qnssl.com/"      //七牛绝对路径

#import "YSKJ_CanvasLoading.h"

#import "YSKJ_ScreenShotClass.h"

#import "YSKJ_ListDetailHeaderView.h"

#import "YSKJ_ListDetailFooterView.h"

#import "YSKJ_ListData.h"

@interface YSKJ_OrderListViewController : UIViewController<UITextFieldDelegate>
{
     NSMutableArray *_tempArray,*_listTempArray;
    UILabel *_checkTitle;
    UILabel *_totailePrice;
    
    float ProTotalPrice,listProTotailPrice;
    
    UIButton *_checkAllBtn,*_listBtn,*_listImageBtn;
    
    BOOL _showKeyBord;
    
    YSKJ_OrderPopWindow *_popViewWindow;
    
    
}

@property (nonatomic,retain) NSMutableArray *proIdArr;

@property (nonatomic, retain) NSString *planName;


@end
