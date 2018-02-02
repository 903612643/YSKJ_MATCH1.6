//
//  YSKJ_MatchViewController.h
//  YSKJ_MATCH
//
//  Created by YSKJ on 17/10/31.
//  Copyright © 2017年 com.yskj. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YSKJ_SideDetaileView.h"

#import "UIView+Transform.h"

#import "YSKJ_HistoryModel.h"

#import "AnimatedGif.h"

#import "YSKJ_NaviView.h"

#import "YSKJ_SideView.h"

#import "YSKJ_CanvasView.h"

#import "YSKJ_SideDetaileView.h"

#import "YSKJ_PlanView.h"

#import "YSKJ_UilityView.h"

#import "YSKJ_SingleDetailView.h"

#import "YSKJ_PushPlanNameView.h"

#import <Qiniu/QiniuSDK.h>

#import "NSString+MD5.h"

#import "YSKJ_SaveWebImageClass.h"

#import "YSKJ_CanvasLoading.h"

#import "YSKJ_DrawData.h"

#import "YSKJ_PinCanvasView.h"

#import "YSKJ_OrderPopWindow.h"

#import "YSKJ_MyLoadProduct.h"

#import "YSKJ_OrderListViewController.h"

#import "YSKJ_ScreenShotClass.h"

#define API_DOMAIN @"www.5164casa.com/api/assist" //正式服务器

#define ADDPROPLAN @"http://"API_DOMAIN@"/solution/add" //新增方案

#define GETTOKEN @"http://"API_DOMAIN@"/sysconfig/gettoken" //得到token

#define  UPDATEPLANFACE @"http://"API_DOMAIN@"/solution/editface"     //修改方案头像

#define UPDATEPLAN @"http://"API_DOMAIN@"/solution/edit" //修改方案

#define QINIU @"http://octjlpudx.qnssl.com/"      //七牛绝对路径

@interface YSKJ_MatchViewController : UIViewController<ViewTransformeDelegate,YSKJ_PlanViewDelegate>
{
     NSMutableArray *_productDataArr;
    
    NSMutableArray *_historiesArr;
    
    ViewTransformConfiguration *cnf;
    
    UIImageView *_targetView;
    
    YSKJ_drawModel *_drawModel;
    
    UIButton *_panButton;
    
    UIView *_corssView;
    
    UIButton *_lockBut,*_recallBut,*_nextBut,*_mirrorBut,*_copyBut,*_moveBut,*_deletBut,*_setRightBtn;
    
    CAShapeLayer *_shaLayer;
    
    CAShapeLayer *_panShaLayer;
    
    UIButton *_cancleSide,*_cancleSide1;
    
    NSString *_planId,*_sname;
    
    NSTimer *_timer;
    
    NSMutableArray *_count;
    
    UIImage *_savedImage;
    
    NSInteger _dataCount;
    
    int  _hisIndex ;
    
    float tempScaleX ,tempScaleY ;
    
    UIView *_top,*_rig,*_rigImage,*_letf,*_bot,*_botImage,*_corner;
    
    int _scaleValue;
    
    YSKJ_PinCanvasView *pinView ;
    
    UIView *_slider1,*_slider2,*_corssSliderX,*_corssSliderY;
    
    float sliderX,sliderY,canvasX,canvasY,canvasCenterX,canvasCenterY;
    
    UIView *_faceView;
    
     YSKJ_OrderPopWindow *_popViewWindow;
    
    NSString *_key;
    
     NSTimer *_Timer;            //每隔5秒自动保存方案一次
    
    
    BOOL boolOpenInputName;
    
    NSString *_planName;
    
    BOOL Pan;
    
    BOOL openAgain;
    
    UIButton *_autoSaveBtn;
}

@property (nonatomic, strong) YSKJ_CanvasView *canvas;
@property (nonatomic, strong) YSKJ_SideDetaileView *detail;
@property (nonatomic, strong) UIButton *sideBtn;
@property (nonatomic, strong) YSKJ_PlanView *planView;
@property (nonatomic, strong) YSKJ_SideView *side;
@property (nonatomic, strong) YSKJ_UilityView *uilityView;
@property (nonatomic, strong) YSKJ_SingleDetailView *sigleDeView;
@property (nonatomic, strong) YSKJ_MyLoadProduct *myLoad;


@end
