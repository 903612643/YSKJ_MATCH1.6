//
//  YSKJ_MatchViewController.m
//  YSKJ_MATCH
//
//  Created by YSKJ on 17/10/31.
//  Copyright © 2017年 com.yskj. All rights reserved.
//

#import "YSKJ_MatchViewController.h"

#import <SDAutoLayout/SDAutoLayout.h>

#import "HttpRequestCalss.h"

#import "YSKJ_MoveImageView.h"

#import "YSKJ_SaveAlertView.h"

#import "ToolClass.h"

#import "YSKJ_AlertView.h"

#define URL @"http://octjlpudx.qnssl.com/"

#import "UIImage+Util.h"

#import "YSKJ_PinCanvasView.h"

#define UIColorFromHex(s)  [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1]

@implementation YSKJ_MatchViewController


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
      _Timer=[NSTimer scheduledTimerWithTimeInterval:120 target:self selector:@selector(savePlanTimerAction) userInfo:nil repeats:YES];

}

-(void)viewWillDisappear:(BOOL)animated
{
    [_Timer invalidate];
    [_timer invalidate];
}

-(void)savePlanTimerAction
{
    if (_autoSaveBtn.selected == YES) {
        
        if (_productDataArr.count!=0) {
            
            UIView *loadingView = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 106)/2, 70, 106, 24)];
            loadingView.backgroundColor = [UIColor colorWithRed:47/255.0 green:47/255.0 blue:47/255.0 alpha:0.4];
            loadingView.layer.cornerRadius = 6;
            loadingView.layer.masksToBounds = YES;
            [[UIApplication sharedApplication].keyWindow addSubview:loadingView];
            
            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(8, 2, 20, 20)];
            [loadingView addSubview:bgView];
            
            UIImageView *loadImage = [[UIImageView alloc] init];
            NSURL *localUrl1 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"loading" ofType:@"gif"]];
            loadImage= [AnimatedGif getAnimationForGifAtUrl:localUrl1];
            [bgView addSubview:loadImage];
            loadImage.sd_layout
            .leftSpaceToView(bgView,0)
            .topSpaceToView(bgView,2)
            .widthIs(20)
            .heightEqualToWidth();
            
            UILabel *tip = [[UILabel alloc] initWithFrame:CGRectMake(36, 0, 106-36, 24)];
            tip.textColor = UIColorFromHex(0xffffff);
            tip.font = [UIFont systemFontOfSize:11];
            tip.text = @"正在保存中...";
            [loadingView addSubview:tip];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [loadingView removeFromSuperview];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    UIView *finishView = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 124)/2, 70, 124, 24)];
                    finishView.backgroundColor = [UIColor colorWithRed:47/255.0 green:47/255.0 blue:47/255.0 alpha:0.4];
                    finishView.layer.cornerRadius = 6;
                    finishView.layer.masksToBounds = YES;
                    [[UIApplication sharedApplication].keyWindow addSubview:finishView];
                    
                    UIImageView *finishImage = [[UIImageView alloc] init];
                    finishImage.image = [UIImage imageNamed:@"finish"];
                    [finishView addSubview:finishImage];
                    finishImage.sd_layout
                    .leftSpaceToView(finishView,8)
                    .topSpaceToView(finishView,4)
                    .widthIs(16)
                    .heightEqualToWidth();
                    
                    UILabel *tip = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 124-30 , 24)];
                    tip.textColor = UIColorFromHex(0xffffff);
                    tip.font = [UIFont systemFontOfSize:11];
                    tip.text = @"已经全部自动保存";
                    [finishView addSubview:tip];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        [finishView removeFromSuperview];
                    });
                    
                });
                
            });
            
            if (_planId.length!=0) {
                
                [self updatePlan:YES];
                
            }else{
                
                [self savePlan:@"未命名" boolTimer:YES];
                
            }
        }
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColorFromHex(0xf4f4f4);
    
    self.navigationController.navigationBarHidden = YES;

    _canvas = [[YSKJ_CanvasView alloc] initWithFrame:CGRectMake(70, 90, self.view.frame.size.width-90, self.view.frame.size.height - 110)];
    [self.view addSubview:_canvas];
    [self bindTap:_canvas];
    
    UIView *top = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, _canvas.frame.origin.y)];
    top.backgroundColor = UIColorFromHex(0xf4f4f4);
    _top = top;
    [self.view addSubview:top];
    [self bindTap:top];
    
    UIView *left = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _canvas.frame.origin.x, self.view.frame.size.height)];
    _letf = left;
    left.backgroundColor = UIColorFromHex(0xf4f4f4);
    [self.view addSubview:left];
    [self bindTap:left];
    
    UIView *rigbg = [[UIView alloc] initWithFrame:CGRectMake( _canvas.frame.origin.x + _canvas.frame.size.width, _canvas.frame.origin.y, self.view.frame.size.width - _canvas.frame.origin.x - _canvas.frame.size.width, self.view.frame.size.height)];
    rigbg.backgroundColor = UIColorFromHex(0xf4f4f4);
    _rig = rigbg;
    [self.view addSubview:rigbg];
    [self bindTap:rigbg];
    
    UIImageView *rig = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2, 10, _canvas.frame.size.height)];
    rig.image = [UIImage imageNamed:@"rig1"];
    rig.backgroundColor = UIColorFromHex(0xf4f4f4);
    _rigImage = rig;
    [rigbg addSubview:rig];
    
    UIView *botbg = [[UIView alloc] initWithFrame:CGRectMake(0, _canvas.frame.origin.y+_canvas.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _canvas.frame.origin.y - _canvas.frame.size.height)];
    botbg.backgroundColor = UIColorFromHex(0xf4f4f4);
    _bot = botbg;
    [self.view addSubview:botbg];
    [self bindTap:botbg];
    
    UIImageView *bot = [[UIImageView alloc] initWithFrame:CGRectMake(_canvas.frame.origin.x, 0, _canvas.frame.size.width, 15)];
    bot.image = [UIImage imageNamed:@"bot"];
    _botImage = bot;
    [botbg addSubview:bot];
    
    UIImageView *view2 = [[UIImageView alloc] initWithFrame:CGRectMake(_canvas.frame.origin.x + _canvas.frame.size.width, 0, 10, 15)];
    view2.image = [UIImage imageNamed:@"bot2"];
    _corner = view2;
    [botbg addSubview:view2];
    
    
    pinView = [[YSKJ_PinCanvasView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-168-28, self.view.frame.size.height-44-48, 168, 44)];
    [self.view addSubview:pinView];
    [pinView.nature addTarget:self action:@selector(natureAction) forControlEvents:UIControlEventTouchUpInside];
    [pinView.subtract addTarget:self action:@selector(subtractAction) forControlEvents:UIControlEventTouchUpInside];
    [pinView.add addTarget:self action:@selector(addScaleAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *bgSliderView1 = [[UIView alloc]initWithFrame:CGRectMake(50, self.view.frame.size.height - 6, self.view.frame.size.width - 56, 6)];
    bgSliderView1.backgroundColor = UIColorFromHex(0xf4f4f4);
    bgSliderView1.hidden = YES;
    [self.view addSubview:bgSliderView1];
    
    UIView *slider1 = [[UIView alloc]initWithFrame:CGRectMake(0,  0, self.view.frame.size.width - 56, 6)];
    slider1.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.56];
    _slider1 = slider1;
    slider1.layer.cornerRadius = 3;
    slider1.layer.masksToBounds = YES;
    [bgSliderView1 addSubview:slider1];
    
    UIView *bgSliderView2 = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 6,70,  6, self.view.frame.size.height - 76)];
    bgSliderView2.backgroundColor =  UIColorFromHex(0xf4f4f4);;
    bgSliderView2.hidden = YES;
    [self.view addSubview:bgSliderView2];
    
    UIView *slider2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0,  6, self.view.frame.size.height - 76)];
    slider2.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.56];
    _slider2 = slider2;
    slider2.layer.cornerRadius = 3;
    slider2.layer.masksToBounds = YES;
    [bgSliderView2 addSubview:slider2];
    
    UIView *corssSliderX = [[UIView alloc] initWithFrame:CGRectMake(50, self.view.frame.size.height - 40, self.view.frame.size.width - 56, 40)];
    _corssSliderX = corssSliderX;
    corssSliderX.hidden = YES;
    [self.view addSubview:corssSliderX];
    UIPanGestureRecognizer *panGestureRecognizer1 = [[UIPanGestureRecognizer alloc]
                                                     initWithTarget:self
                                                     action:@selector(handlePan1:)];
    [_corssSliderX addGestureRecognizer:panGestureRecognizer1];
    
    UIView *corssSliderY = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-40, 70, 40, self.view.frame.size.height - 76)];
    _corssSliderY = corssSliderY;
     corssSliderX.hidden = YES;
    [self.view addSubview:corssSliderY];
    UIPanGestureRecognizer *panGestureRecognizer2 = [[UIPanGestureRecognizer alloc]
                                                     initWithTarget:self
                                                     action:@selector(handlePan2:)];
    [_corssSliderY addGestureRecognizer:panGestureRecognizer2];
    
    
    YSKJ_NaviView *navi = [[YSKJ_NaviView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 70)];
    [navi.close addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    [navi.moveAllBut addTarget:self action:@selector(moveAllAction) forControlEvents:UIControlEventTouchUpInside];
    [navi.orderBtn addTarget:self action:@selector(selectOrderAction) forControlEvents:UIControlEventTouchUpInside];
    [navi.exportBtn addTarget:self action:@selector(exportImageAction) forControlEvents:UIControlEventTouchUpInside];
    [navi.autosaveBtn addTarget:self action:@selector(autosaveAction:) forControlEvents:UIControlEventTouchUpInside];
    _autoSaveBtn = navi.autosaveBtn;
    [self.view addSubview:navi];
    
    _hisIndex = 0;
    
    _productDataArr = [[NSMutableArray alloc] init];
    _historiesArr = [[NSMutableArray alloc] init];
    [self addHistoryArr];   //加载空画布到历史纪录
    
    for (UIButton *subView in navi.subviews) {
        if (subView.tag==1000) {
            _lockBut = (UIButton *)subView;
            [subView addTarget:self action:@selector(lockAction) forControlEvents:UIControlEventTouchUpInside];
        }else if (subView.tag==1001){
            _recallBut = (UIButton*)subView;
            [subView addTarget:self action:@selector(recallAction) forControlEvents:UIControlEventTouchUpInside];
        }else if (subView.tag==1002){
            _nextBut = (UIButton*)subView;
            [subView addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
        }else if (subView.tag==1003){
            _mirrorBut= (UIButton*)subView;
            [subView addTarget:self action:@selector(mirrorAction) forControlEvents:UIControlEventTouchUpInside];
        }else if (subView.tag==1004){
            _copyBut = (UIButton*)subView;
            [subView addTarget:self action:@selector(copyAction) forControlEvents:UIControlEventTouchUpInside];
        }else if (subView.tag==1005){
            _moveBut = (UIButton*)subView;
            [subView addTarget:self action:@selector(moveAction) forControlEvents:UIControlEventTouchUpInside];
        }else if (subView.tag == 1006){
            _deletBut = (UIButton*)subView;
            [subView addTarget:self action:@selector(setRightAction) forControlEvents:UIControlEventTouchUpInside];
        }else if (subView.tag == 1007){
            _setRightBtn = (UIButton*)subView;
            [subView addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    cnf = [[ViewTransformConfiguration alloc]init];
    cnf.controlPointSideLen = 10;
    cnf.controlPointTargetViewInset = 2;
    cnf.expandInsetGestureRecognition = CGPointMake(15, 15);
    cnf.minWidth = 0.1;
    cnf.minHeight = 0.1;
    [cnf configBackgroundImage:[UIImage imageNamed:@"RotaryGripper"] forControlPointType:CtrlViewType_out];
    [cnf configBackgroundImage:[UIImage imageNamed:@"SelectedPoints"] forControlPointType:CtrlViewType_lt];
    [cnf configBackgroundImage:[UIImage imageNamed:@"SelectedPoints"] forControlPointType:CtrlViewType_lb];
    [cnf configBackgroundImage:[UIImage imageNamed:@"SelectedPoints"] forControlPointType:CtrlViewType_rb];
    [cnf configBackgroundImage:[UIImage imageNamed:@"SelectedPoints"] forControlPointType:CtrlViewType_rt];
    [cnf configBackgroundImage:[UIImage imageNamed:@"SelectedPoints"] forControlPointType:CtrlViewType_ls];
    [cnf configBackgroundImage:[UIImage imageNamed:@"SelectedPoints"] forControlPointType:CtrlViewType_ts];
    [cnf configBackgroundImage:[UIImage imageNamed:@"SelectedPoints"] forControlPointType:CtrlViewType_rs];
    [cnf configBackgroundImage:[UIImage imageNamed:@"SelectedPoints"] forControlPointType:CtrlViewType_bs];
    [cnf configCtrlPointCapacity:(CtrlViewCapacity_scale) forControlPointType:CtrlViewType_rt];
    

    _planView = [[YSKJ_PlanView alloc] initWithFrame:CGRectMake(-(self.view.frame.size.width - 50), 70, (self.view.frame.size.width - 50)/2, self.view.size.height-70)];
    _planView.delegate = self;
    _planView.hidden = YES;
    _planView.updata = @"";
    [self.view addSubview:_planView];
    
    _uilityView = [[YSKJ_UilityView alloc] initWithFrame:CGRectMake(-(self.view.frame.size.width - 50), 70, (self.view.frame.size.width - 50)/2, self.view.size.height-70)];
    _uilityView.hidden = YES;
    [self.view addSubview:_uilityView];
    
    _detail = [[YSKJ_SideDetaileView alloc] initWithFrame:CGRectMake(-(self.view.frame.size.width - 50), 70, (self.view.frame.size.width - 50)/2, self.view.size.height-70)];
    _detail.hidden = YES;
    [self.view addSubview:_detail];
    
    _myLoad = [[YSKJ_MyLoadProduct alloc] initWithFrame:CGRectMake(-(self.view.frame.size.width - 50), 70, (self.view.frame.size.width - 50)/2, self.view.size.height-70)];
    _myLoad.hidden = YES;
    [self.view addSubview:_myLoad];
    
    _sigleDeView = [[YSKJ_SingleDetailView alloc]initWithFrame:CGRectMake(-(self.view.frame.size.width - 50), 70, (self.view.frame.size.width - 50)/2, self.view.size.height-70)];
    _sigleDeView.hidden = YES;
    [self.view addSubview:_sigleDeView];
    _sigleDeView.model = nil;
    
    UIButton *cancleSide = [[UIButton alloc] initWithFrame:CGRectMake(50, (self.view.frame.size.height -62)/2, 26, 62)];
    cancleSide.backgroundColor = UIColorFromHex(0x354048);
    cancleSide.layer.cornerRadius = 6;
    cancleSide.layer.masksToBounds =YES;
    [cancleSide addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
    [cancleSide setImage:[UIImage imageNamed:@"cancleArrow"] forState:UIControlStateNormal];
    cancleSide.imageEdgeInsets = UIEdgeInsetsMake(18, 10, 18, 5);
    _cancleSide = cancleSide;
    cancleSide.hidden = YES;
    [self.view addSubview:cancleSide];
    
    UIButton *cancleSide1 = [[UIButton alloc] initWithFrame:CGRectMake(50, (self.view.frame.size.height -62)/2, 44, 62)];
    cancleSide1.backgroundColor = [UIColor clearColor];
    [cancleSide1 addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
    _cancleSide1 = cancleSide1;
    cancleSide1.hidden = YES;
    [self.view addSubview:cancleSide1];
    
    YSKJ_SideView *side = [[YSKJ_SideView alloc] initWithFrame:CGRectMake(0, 70, 50, self.view.frame.size.height)];
    _side = side;
    [self.view addSubview:side];
    
    _myLoad.http = YES;
    
    __weak typeof(self) weakSelf = self;
    
    side.selectBlock = ^(NSInteger index,UIButton *button){
        
        _sideBtn = button;
        _detail.hidden = NO;
        _planView.hidden = NO;
        _uilityView.hidden = NO;
        _sigleDeView.hidden = NO;
        _myLoad.hidden = NO;
        
        if (index == 0) {
            [_detail.superview bringSubviewToFront:_detail];
        }else if (index == 1){
            [_myLoad.superview bringSubviewToFront:_myLoad];
        }else if (index == 2){
            [_planView.superview bringSubviewToFront:_planView];
        }else if (index == 3){
            [_uilityView.superview bringSubviewToFront:_uilityView];
        }else if (index == 4){
            [_sigleDeView.superview bringSubviewToFront:_sigleDeView];
        }
        
        [weakSelf.view bringSubviewToFront:_side];
        
        [_canvas.superview sendSubviewToBack:_canvas];
        
        [UIView animateWithDuration:0.3 animations:^{
            _detail.frame = CGRectMake(50, 70,_detail.frame.size.width, _detail.frame.size.height);
            _planView.frame = CGRectMake(50, 70,_planView.frame.size.width, _planView.frame.size.height);
            _uilityView.frame = CGRectMake(50, 70,_uilityView.frame.size.width, _uilityView.frame.size.height);
            _sigleDeView.frame = CGRectMake(50, 70,_sigleDeView.frame.size.width, _sigleDeView.frame.size.height);
            _myLoad.frame = CGRectMake(50, 70,_myLoad.frame.size.width, _myLoad.frame.size.height);
            
        } completion:^(BOOL finished) {
            _cancleSide.hidden = NO;
            cancleSide1.hidden = NO;
            _cancleSide.frame = CGRectMake((self.view.frame.size.width - 50)/2+50 - 10, (self.view.frame.size.height -62)/2, 26, 62);
            _cancleSide1.frame = CGRectMake((self.view.frame.size.width - 50)/2+50, (self.view.frame.size.height -62)/2, 44, 62);
        }];
        
    };
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beganPanAction:) name:@"beganPanNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(panAction:) name:@"panNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endAction:) name:@"endPanNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNoitfiAction:) name:@"addToCanvasNotification" object:nil];
    
    
    _shaLayer = [CAShapeLayer layer];
    _shaLayer.lineWidth = 1;
    _shaLayer.lineCap = @"square";
    _shaLayer.lineDashPattern = @[@4,@4];
    
    _panShaLayer = [CAShapeLayer layer];
    _panShaLayer.lineWidth = 6;
    _panShaLayer.lineCap = @"square";
    
    _planId = [[NSString alloc] init];
    _count = [[NSMutableArray alloc] init];

    tempScaleX = 1.0; tempScaleY = 1.0;_scaleValue = 100;
    
    boolOpenInputName = YES;
    
    openAgain = NO;
    
}

-(void)bindTap:(UIView*)view
{
    UITapGestureRecognizer *tapRecognize = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    tapRecognize.numberOfTapsRequired = 1;
    [view addGestureRecognizer:tapRecognize];
    
}

-(void)handleTap:(UITapGestureRecognizer *)recognizer
{
    _lockBut.enabled = NO;
    _mirrorBut.enabled = NO;
    _copyBut.enabled = NO;
    _moveBut.enabled = NO;
    _deletBut.enabled = NO;
    _setRightBtn.enabled = NO;
    
    _shaLayer.strokeColor = [UIColor clearColor].CGColor;
    
    [_targetView tf_hideAllControlPoint];
    
    _targetView = nil;
    
}

-(void)cancle
{
    _cancleSide.hidden = YES;
    _cancleSide1.hidden = YES;
    NSArray *image = @[@"search",@"SingleProduct",@"programme",@"AuxiliaryEffect",@"details"];
    _sideBtn.backgroundColor = [UIColor clearColor];
    [_sideBtn setImage:[UIImage imageNamed:image[_sideBtn.tag-100]] forState:UIControlStateNormal];
   [UIView animateWithDuration:0.3 animations:^{
       _detail.frame = CGRectMake(-_detail.frame.size.width, 70,_detail.frame.size.width, _detail.frame.size.height);
       _planView.frame = CGRectMake(-_planView.frame.size.width, 70,_planView.frame.size.width, _planView.frame.size.height);
       _uilityView.frame = CGRectMake(-_uilityView.frame.size.width, 70,_uilityView.frame.size.width, _uilityView.frame.size.height);
       _sigleDeView.frame = CGRectMake(-_sigleDeView.frame.size.width, 70,_sigleDeView.frame.size.width, _sigleDeView.frame.size.height);
       _myLoad.frame = CGRectMake(-_myLoad.frame.size.width, 70,_myLoad.frame.size.width, _myLoad.frame.size.height);
       
   } completion:^(BOOL finished) {
      _detail.hidden = YES;
       _planView.hidden = YES;
       _uilityView.hidden = YES;
       _sigleDeView.hidden = YES;
       _myLoad.hidden = YES;
   }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 添加到历史纪录

-(void)addHistoryArr
{
    if (_hisIndex<_historiesArr.count) {
        NSMutableArray *tempArray=[[NSMutableArray alloc] init];
        for (int i=0; i<_hisIndex; i++) {
            [tempArray addObject:_historiesArr[i]];
        }
        [_historiesArr removeAllObjects];
        _historiesArr=tempArray;
    }
    
    NSMutableArray *productArr = [[NSMutableArray alloc] init];
    for (YSKJ_drawModel *model in _productDataArr) {
        [productArr addObject:[model copy]];
    }
    
    YSKJ_HistoryModel *hisModel = [[YSKJ_HistoryModel alloc] init];
    
    hisModel.data = productArr;
    
    [_historiesArr addObject:hisModel];
    
    _hisIndex=(int)_historiesArr.count;
    
    _recallBut.enabled = YES;
    _nextBut.enabled = NO;
    
}

#pragma mark  openPlan －－－－－－－－－－－－－打开方案

-(void)selectImage
{
    if (_count.count == _dataCount) {
        
        [_timer invalidate];
        [_count removeAllObjects];
        
        [YSKJ_CanvasLoading showNotificationViewWithText:nil loadType:done];

        for (UIView *view in _canvas.subviews) {
            [view removeFromSuperview];
        }
        
        YSKJ_HistoryModel *hisModel = [_historiesArr lastObject];
        
        [self setUpOpenPlanView:hisModel.data boolLoad:NO];
    }
}

-(void)setUpOpenPlanView:(NSArray *)data boolLoad:(BOOL)loadHub
{
    _dataCount = data.count;
    
    [_count removeAllObjects];
    
    if (data.count!=0 && loadHub == YES) {
        
        [YSKJ_CanvasLoading showNotificationViewWithText:@"努力加载拼图中..." loadType:isBack];
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.6 target:self selector:@selector(selectImage) userInfo:nil repeats:YES];
    }

    [_productDataArr removeAllObjects];
    
    YSKJ_drawModel *tempModel;
    
    NSMutableArray *tempArr1 = [[NSMutableArray alloc] initWithArray:data];
    
    for (int i=0;i<tempArr1.count;i++) {
        
        YSKJ_drawModel *model = tempArr1[i];
        
        if ([model.objtype isEqualToString:@"spacebg"]) {
            
            if (i!=0) {
                
                tempModel = model;
                
                [tempArr1 removeObject:model];
                
                i--;
            
            }
        }
    }
    
    NSMutableArray *tempArr2 = [[NSMutableArray alloc] init];
    
    if (tempModel!=nil) {
        
        [tempArr2 addObject:tempModel];
        
        for (YSKJ_drawModel *model in tempArr1) {
            [tempArr2 addObject:model];
        }
        
        data = tempArr2;
    }
    
    for (int i=0;i<data.count;i++) {
        
        YSKJ_drawModel *model = [data[i] copy];
        
        UIImageView *proImg = [[UIImageView alloc] init];
        
        [_canvas addSubview:proImg];
        
        [_productDataArr addObject:model];
        
        //获取网络图片的Size
        [proImg sd_setImageWithPreviousCachedImageWithURL:[[NSURL alloc] initWithString:model.src] placeholderImage:nil options:(SDWebImageRetryFailed) progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
        } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            
            if (image.size.height>0 && image.size.width>0) {
                
                [_count addObject:image];
                
                float w = image.size.width*[model.scaleX floatValue];
                float h = image.size.height*[model.scaleY floatValue];
                float x=[model.x floatValue] - w/2 ;
                float y=[model.y floatValue] - h/2 ;
                
                proImg.frame = CGRectMake(x, y, w, h);
                
                proImg.tag = 1000+10*(_count.count-1);
                
                model.naturew = [NSString stringWithFormat:@"%f",image.size.width];
                model.natureh = [NSString stringWithFormat:@"%f",image.size.height];
                model.originX = [NSString stringWithFormat:@"%f",x];
                model.originY = [NSString stringWithFormat:@"%f",y];
                model.w = [NSString stringWithFormat:@"%f",w];
                model.h = [NSString stringWithFormat:@"%f",h];
                model.imageId = [NSString stringWithFormat:@"%ld",(long)proImg.tag];

                proImg.image = image;
                
                //是否镜像
                if ([model.mirror integerValue] == 1) {
                    
                    proImg.image = [proImg.image rotate:UIImageOrientationUpMirrored];
                    
                }
                //是否镜像，并得到弧度
                if ([model.mirror integerValue] == 1) {
                    CGFloat angle = (-[model.rotation floatValue])/180*M_PI;
                    proImg.transform = CGAffineTransformMakeRotation(angle);
                }else{
                    CGFloat angle = [model.rotation floatValue]/180*M_PI ;
                    proImg.transform = CGAffineTransformMakeRotation(angle);
                }
                
                [proImg tf_showTransformOperationWithConfiguration:cnf delegate:self];
                
                //是否锁定
                if ([model.lock integerValue] == 0) {
                    
                    [proImg tf_enableAll];
                    
                }else{
                    [proImg tf_disableAll];
                }
                
            }

        }];
    
    }
    
}

-(void)addProToDrawBoard:(YSKJ_drawModel*)model
{
    UIImageView *proImg = [[UIImageView alloc] initWithFrame:CGRectMake([model.originX floatValue], [model.originY floatValue], [model.w floatValue], [model.h floatValue])];
    
    proImg.tag = 1000 + _productDataArr.count*10;
    
    model.imageId = [NSString stringWithFormat:@"%ld",(long)proImg.tag];
    
    [proImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.src]] placeholderImage:nil];
    
    [_canvas addSubview:proImg];
    //是否镜像
    if ([model.mirror integerValue] == 1) {
        
        proImg.image = [proImg.image rotate:UIImageOrientationUpMirrored];
        
    }
    //是否镜像，并得到弧度
    if ([model.mirror integerValue] == 1) {
        CGFloat angle = (-[model.rotation floatValue])/180*M_PI ;
        proImg.transform = CGAffineTransformMakeRotation(angle);
    }else{
        CGFloat angle = [model.rotation floatValue]/180*M_PI ;
        proImg.transform = CGAffineTransformMakeRotation(angle);
    }
    
    [proImg tf_showTransformOperationWithConfiguration:cnf delegate:self];
    
    YSKJ_drawModel *firstModel = [_productDataArr firstObject];
    
    if ([firstModel.objtype isEqualToString:@"spacebg"]) {
            
            if ([model.objtype isEqualToString:@"spacebg"]) {
                
                [self hideAllImageOperation];
                
                [[_canvas viewWithTag:1000] removeFromSuperview];
                
                [proImg.superview sendSubviewToBack:proImg];
                
                model.x = firstModel.x;
                model.y = firstModel.y;
                model.scaleX = firstModel.scaleX;
                model.scaleY = firstModel.scaleY;
                model.rotation = firstModel.rotation;
                
                float x=[model.x floatValue]-([model.naturew floatValue]*[model.scaleX floatValue])/2;
                float y=[model.y floatValue]-([model.natureh floatValue]*[model.scaleY floatValue])/2;
                
                proImg.frame = CGRectMake(x, y, [model.naturew floatValue]*[model.scaleX floatValue], [model.natureh floatValue]*[model.scaleY floatValue]);
                
                proImg.transform = CGAffineTransformMakeRotation([model.rotation floatValue]/180*M_PI);
                
                [self showAllImageTransformOperation];
                
               [_productDataArr removeObject:firstModel];
                
               [_productDataArr insertObject:model atIndex:0];

            }else{
                
                [_productDataArr addObject:model];
                
            }
    }else{
        
        if ([model.objtype isEqualToString:@"spacebg"]) {
            
            [self hideAllImageOperation];
            
            [_canvas sendSubviewToBack:proImg];
            
            [self showAllImageTransformOperation];
            
            [_productDataArr insertObject:model atIndex:0];

        }else{
            
            [_productDataArr addObject:model];
            
        }
        
    }
    
    [self canvasImageViewWithTagSort];
    
    [_targetView tf_hideAllControlPoint];
    
    _drawModel = model;
    
    _targetView = proImg;
    
    _lockBut.enabled = YES;
    
    [self lock:NO];
    
    [self addBorder];
    
    [self updateAsameProduct];
    
    [_targetView tf_showAllControlPoint];

    [self addHistoryArr];
    
    for (int i=0;i<_productDataArr.count;i++) {
        
        YSKJ_drawModel *model = _productDataArr[i];
        model.imageId = [NSString stringWithFormat:@"%d",1000 + 10*i];
    }
    
}


#pragma mark ViewTransformeDelegate

- (void) onScaleTotal:(CGPoint)totalScale panDurationScale:(CGPoint)panDurationScale targetView:(UIView*)targetView ges:(UIPanGestureRecognizer*)ges
{
    _drawModel.scaleX = [NSString stringWithFormat:@"%f",panDurationScale.x*tempScaleX];
    _drawModel.scaleY = [NSString stringWithFormat:@"%f",panDurationScale.y*tempScaleY];
    
    [self addBorder];
    
    if (ges.state == UIGestureRecognizerStateEnded) {
        
        [self addHistoryArr];
        
        _drawModel = _productDataArr[(targetView.tag - 1000)/10];
        
    }
}

- (void)onRotateTotal:(CGFloat)totalAngle panDurationAngle:(CGFloat)panDurationAngle targetView:(UIView *)targetView ges:(UIPanGestureRecognizer *)ges{
    
    [self addBorder];
    
    if (ges.state == UIGestureRecognizerStateEnded) {
        
        CGFloat degree = totalAngle/M_PI * 180;
        
        NSString *str = [NSString stringWithFormat:@"%f",degree];
        
        if (degree>360 || degree<-360) {
            
            degree -= 360*([str intValue]/360);
            
        }else if(degree<-180){
            
            degree += 360;
            
        }else if (degree>180 && degree<360){
            
            degree -= 360;
        }
        
        NSString *rotation;
        if ([_drawModel.mirror integerValue] == 1) {
            rotation = [NSString stringWithFormat:@"%f",-degree];
        }else{
            rotation = [NSString stringWithFormat:@"%f",degree];
        }
        
        _drawModel.rotation = rotation;
        
        [self addHistoryArr];
        
    }
}

- (void)onDragPanDurationOffset:(CGPoint)panDurationOffset targetView:(UIView *)targetView ges:(UIPanGestureRecognizer *)ges{
    
    [self addBorder];
    
    if (ges.state == UIGestureRecognizerStateEnded) {

        if ([_drawModel.objtype isEqualToString:@"product"]) {
            
            [self updateAsameProduct];
            
        }else{
            _sigleDeView.tipTitle = @"没有相关的相似背景信息";
        }
        
        _drawModel.x = [NSString stringWithFormat:@"%0.2f",targetView.center.x];
        _drawModel.y = [NSString stringWithFormat:@"%0.2f",targetView.center.y];

        
         [self addHistoryArr];
    
    }
}

- (void)tapGWihttargetView:(UIView*)targetView ges:(UITapGestureRecognizer *)ges
{
    _targetView = (UIImageView *)targetView;
    
    [self addBorder];
    
    _lockBut.enabled = YES;
    _mirrorBut.enabled = YES;
    _copyBut.enabled = YES;
    _moveBut.enabled = YES;
    _deletBut.enabled = YES;
    _setRightBtn.enabled = YES;
    
    [_sigleDeView.superview bringSubviewToFront:_sigleDeView];
    
    if (_cancleSide1.hidden == NO) {
        UIButton *lastBut = [_side.sideButtonArr lastObject];
        lastBut.backgroundColor = UIColorFromHex(0x354048);
        [lastBut setImage:[UIImage imageNamed:@"details1"] forState:UIControlStateNormal];
        NSArray *imageNameArr = @[@"search",@"SingleProduct",@"programme",@"AuxiliaryEffect",@"details"];
        for (UIButton *but in _side.sideButtonArr) {
            if (but!=lastBut) {
                but.backgroundColor = [UIColor clearColor];
                [but setImage:[UIImage imageNamed:imageNameArr[[_side.sideButtonArr indexOfObject:but]]] forState:UIControlStateNormal];
            }
        }
    }
    
    _drawModel = _productDataArr[(targetView.tag - 1000)/10];
    
    tempScaleX = [_drawModel.scaleX floatValue];
    tempScaleY = [_drawModel.scaleY floatValue];
    
    [_targetView tf_showAllControlPoint];

    cnf.minHeight = 0.1;
    cnf.minWidth =  0.1;
    
    //是否锁定
    if ([_drawModel.lock integerValue] == 0) {
        
        _lockBut.selected = NO;
        
        [self lock:NO];
        
    }else{
        _lockBut.selected = YES;
        
        [self lock:YES];
    }
    
    if ([_drawModel.objtype isEqualToString:@"spacebg"]) {

        _mirrorBut.enabled = NO;
        _copyBut.enabled = NO;
        _moveBut.enabled = NO;

    }
    
    if (ges.state == UIGestureRecognizerStateEnded) {
    
        
        if ([_drawModel.objtype isEqualToString:@"product"]) {
            
            _sigleDeView.model = _drawModel;
            
        }else{
            
            _sigleDeView.tipTitle = @"没有相关的相似背景信息";
        }
        
    }

}

#pragma mark naviOperation

-(void)saveAction
{
    [YSKJ_SaveAlertView showSaveAlertCancleBlock:^{
        
        [YSKJ_AlertView showAlertTitle:@"您是否放弃本次编辑" content:@"返回到主菜单" cancleBlock:^{
            
        } finishBlock:^{
            
            [_productDataArr removeAllObjects];
            
            [_historiesArr removeAllObjects];
            
            _drawModel = nil;
            
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:[NSString stringWithFormat:@"%@_plan",[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]]];
            
            [[NSNotificationCenter defaultCenter] removeObserver:self name:@"beganPanNotification" object:nil];
            
            [[NSNotificationCenter defaultCenter] removeObserver:self name:@"panNotification" object:nil];
            
            [[NSNotificationCenter defaultCenter] removeObserver:self name:@"endPanNotification" object:nil];
            
            [[NSNotificationCenter defaultCenter] removeObserver:self name:@"addToCanvasNotification" object:nil];
            
            [YSKJ_CanvasLoading showNotificationViewWithText:nil loadType:done];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.navigationController popViewControllerAnimated:YES];
                
            });
        }];
        
    } saveBlock:^{
        
        
        if (_planId.length!=0) {
            
            [YSKJ_PushPlanNameView showInputPlanNameView:_planName CancleBlock:^{
                
            } sureBlock:^(NSString *planName, BOOL open) {
                
                _sname = planName;
                
                _planName = planName;
                
                 [self updatePlan:NO];
                
            }];
        
 
        }else{

            
            [YSKJ_PushPlanNameView showInputPlanNameView:_planName CancleBlock:^{

                
            } sureBlock:^(NSString *planName, BOOL open) {
                
                _planName = planName;
                
                [self savePlan:planName boolTimer:NO];
                
            }];
            
        }
        
    }];
    
}

-(void)lockAction
{
    
    if (_lockBut.selected == NO) {
        _lockBut.selected =YES;
        _drawModel.lock = @"1";
        [self lock:YES];
    }else{
        _lockBut.selected = NO;
        _drawModel.lock = @"0";
        [self lock:NO];
    }
    [self addHistoryArr];
    
    
}

-(void)lock:(BOOL)yes
{
    if (yes == YES) {
        
        [_targetView tf_disableAll];
        [_lockBut setImage:[UIImage imageNamed:@"locking"] forState:UIControlStateNormal];
        [self rotateImage].image = [UIImage imageNamed:@"lockImage"] ;
        _mirrorBut.enabled = NO;
        _copyBut.enabled = NO;
        _moveBut.enabled = NO;
        _deletBut.enabled = NO;
        _setRightBtn.enabled = NO;
        
    }else{
        [_targetView tf_enableAll];
        [_lockBut setImage:[UIImage imageNamed:@"Unlock"] forState:UIControlStateNormal];
        [self rotateImage].image = [UIImage imageNamed:@"RotaryGripper"] ;
        
       if ([_drawModel.objtype isEqualToString:@"product"]) {
            _mirrorBut.enabled = YES;
            _copyBut.enabled = YES;
            _moveBut.enabled = YES;
            _deletBut.enabled = YES;
           _setRightBtn.enabled = YES;
        }else{
            _mirrorBut.enabled = NO;
            _copyBut.enabled = NO;
            _moveBut.enabled = NO;
            _deletBut.enabled = YES;
            _setRightBtn.enabled = YES;
        }
        
    }

}

-(void)recallAction
{
    if (_historiesArr.count>1) {
        
        _hisIndex--;
        
        for (UIView *subViews in _canvas.subviews) {
            
            [subViews removeFromSuperview];
        }
        
        YSKJ_HistoryModel *hisModel = _historiesArr[_hisIndex-1];
        [self setUpOpenPlanView:hisModel.data boolLoad:NO];
        
        _targetView = nil;
        
    }
    
    if (_hisIndex==1) {
  
        _recallBut.enabled = NO;
        
    }
    
    _lockBut.enabled = NO;
    _nextBut.enabled = YES;
    _mirrorBut.enabled = NO;
    _copyBut.enabled = NO;
    _moveBut.enabled = NO;
    _deletBut.enabled = NO;
    _setRightBtn.enabled = NO;
    
    _shaLayer.strokeColor = [UIColor clearColor].CGColor;
    
}

-(void)nextAction
{
    if (_hisIndex<_historiesArr.count) {
        
        _hisIndex++;
        
        for (UIView *subViews in _canvas.subviews) {
            
            [subViews removeFromSuperview];
        }
        
        YSKJ_HistoryModel *hisModel = _historiesArr[_hisIndex-1];
        [self setUpOpenPlanView:hisModel.data boolLoad:NO];
        
        _targetView = nil;
        
        
    }
    
    if (_hisIndex==_historiesArr.count) {
        _nextBut.enabled = NO;
    }
    
    _lockBut.enabled = NO;
    _recallBut.enabled = YES;
    _mirrorBut.enabled = NO;
    _copyBut.enabled = NO;
    _moveBut.enabled = NO;
    _deletBut.enabled = NO;
    _setRightBtn.enabled = NO;
    
    _shaLayer.strokeColor = [UIColor clearColor].CGColor;
    
}

-(void)mirrorAction
{

    if ([_drawModel.mirror integerValue] == 0) {
        
        _drawModel.mirror = @"1";
    }
    else{
        _drawModel.mirror = @"0";
    }
    
   _drawModel.rotation = [NSString stringWithFormat:@"%f",-[_drawModel.rotation floatValue]];
    
    [self addHistoryArr];
    
    UIImageView *imageView = (UIImageView *)_targetView;
    
    imageView.image = [imageView.image rotate:UIImageOrientationUpMirrored];
    
}


-(void)copyAction
{
    //1.拷贝model
    YSKJ_drawModel *model = [_drawModel copy];
    
    //2.设置中心点偏移20个像素,并加入当前画板模型数组
    model.x = [NSString stringWithFormat:@"%f",[model.x floatValue] + 20];
    model.y = [NSString stringWithFormat:@"%f",[model.y floatValue] + 20];
    
    float x=[model.x floatValue]-[model.scaleX floatValue]*[model.naturew floatValue]/2;
    float y=[model.y floatValue]-[model.scaleY floatValue]*[model.natureh floatValue]/2;
    
    model.originX = [NSString stringWithFormat:@"%f",x];
    model.originY = [NSString stringWithFormat:@"%f",y];
    model.w = [NSString stringWithFormat:@"%f",[model.scaleX floatValue]*[model.naturew floatValue]];
    model.h = [NSString stringWithFormat:@"%f",[model.scaleY floatValue]*[model.natureh floatValue]];
    
    [self addProToDrawBoard:model];
    
}

-(void)moveAction
{
    [YSKJ_MoveImageView showMoveView:^(NSInteger index) {
        
        //移动步骤：1.计算对应model在_productDataArr的位置；2.移动视图；3.视图tag按顺序排序。
        //移除框架，即移除CtrView
        [self hideAllImageOperation];
        
        if (index == 0) {
            
            int i = 0;
            
            for (UIView *view in _canvas.subviews) {
                
                i++;
                
                if (view == _targetView) {
                    
                    if (i<=_productDataArr.count-1) {
                        
                        [_productDataArr exchangeObjectAtIndex:i-1 withObjectAtIndex:i];
                        [_canvas insertSubview:_targetView atIndex:i];
                        [self addHistoryArr];
                        UIImageView *afterImage = [_canvas viewWithTag:1000 + 10*i];
                        afterImage.tag = afterImage.tag - 10;
                        _targetView.tag = _targetView.tag + 10;
                        
                        for (int i=0;i<_productDataArr.count;i++) {
                            
                            YSKJ_drawModel *model = _productDataArr[i];
                            model.imageId = [NSString stringWithFormat:@"%d",1000 + 10*i];
                            
                        }
                        
  
                    }
                    
                }
                
            }
  
        }else if (index == 1){
            
            int i = -1;
            
            for (UIView *view in _canvas.subviews) {
                
                i++;
                
                if (view == _targetView) {
                    
                    YSKJ_drawModel *firstModel = [_productDataArr firstObject];
                    
                    if (![firstModel.objtype isEqualToString:@"product"]) {
                        
                        if (i >=2 ) {
                            
                            [_productDataArr exchangeObjectAtIndex:i withObjectAtIndex:i-1];
                            [_canvas insertSubview:_targetView atIndex:i-1];
                            [self addHistoryArr];
                            UIImageView *beforeImage = [_canvas viewWithTag:1000 + 10*(i-1)];
                            beforeImage.tag = beforeImage.tag + 10;
                            _targetView.tag = _targetView.tag - 10;
                            
                            for (int i=0;i<_productDataArr.count;i++) {
                                
                                YSKJ_drawModel *model = _productDataArr[i];
                                model.imageId = [NSString stringWithFormat:@"%d",1000 + 10*i];
                
                            }
                            
    

                        }
                        
                    }else{
                    
                        if (i >=1 ) {
                            
                            [_productDataArr exchangeObjectAtIndex:i withObjectAtIndex:i-1];
                            [_canvas insertSubview:_targetView atIndex:i-1];
                            [self addHistoryArr];
                            UIImageView *beforeImage = [_canvas viewWithTag:1000 + 10*(i-1)];
                            beforeImage.tag = beforeImage.tag + 10;
                            _targetView.tag = _targetView.tag - 10;
                            
                            for (int i=0;i<_productDataArr.count;i++) {
                                
                                YSKJ_drawModel *model = _productDataArr[i];
                                model.imageId = [NSString stringWithFormat:@"%d",1000 + 10*i];
                            }
                            
                            
                        }

                    }
                    
                }
                
            }
            
        }else if (index == 2){
                
            if ((_targetView.tag-1000)/10 < _productDataArr.count-1) {  //最上面的一个不能置顶
                
                YSKJ_drawModel *model = _productDataArr[(_targetView.tag-1000)/10];
                
                [_productDataArr removeObject:model];
                
                NSMutableArray *tempArr = [[NSMutableArray alloc] init];
                
                tempArr = _productDataArr;
                
                [tempArr addObject:model];
                
                _productDataArr = tempArr;
                
                [_targetView.superview bringSubviewToFront:_targetView];
                
                
                [self addHistoryArr];
                
                [self canvasImageViewWithTagSort];
                
                for (int i=0;i<_productDataArr.count;i++) {
                    
                    YSKJ_drawModel *model = _productDataArr[i];
                    model.imageId = [NSString stringWithFormat:@"%d",1000 + 10*i];
                }
            }
            
        }else{
            
            if ((_targetView.tag-1000)/10>0) {
                
                YSKJ_drawModel *model = _productDataArr[(_targetView.tag-1000)/10];
                
                YSKJ_drawModel *firstModel = [_productDataArr firstObject];
                
                 if (![firstModel.objtype isEqualToString:@"product"]) {
                     
                     if ((_targetView.tag -1000)/10>1) {
                         
                         [_productDataArr removeObject:model];
                         
                         [_productDataArr removeObject:firstModel];
                         
                         NSMutableArray *tempArr = [[NSMutableArray alloc] init];
                         
                         [tempArr addObject:firstModel];
                         
                         [tempArr addObject:model];
                         
                         [tempArr addObjectsFromArray:_productDataArr];
                         
                         _productDataArr = tempArr;
                         
                         [_targetView.superview sendSubviewToBack:_targetView];
                         
                         [_targetView.superview sendSubviewToBack:[_canvas viewWithTag:1000]];
                         
                         [self addHistoryArr];
                         
                         [self canvasImageViewWithTagSort];
                         
                         for (int i=0;i<_productDataArr.count;i++) {
                             
                             YSKJ_drawModel *model = _productDataArr[i];
                             model.imageId = [NSString stringWithFormat:@"%d",1000 + 10*i];
                         }
                         
                     }
                     
                 }else{
                     
                     if ((_targetView.tag-1000)/10>0) {
                         
                         [_productDataArr removeObject:model];
                         
                         NSMutableArray *tempArr = [[NSMutableArray alloc] init];
                         
                         [tempArr addObject:model];
                         
                         [tempArr addObjectsFromArray:_productDataArr];
                         
                         _productDataArr = tempArr;
                         
                         [_targetView.superview sendSubviewToBack:_targetView];
                         
                         [self addHistoryArr];
                         
                         [self canvasImageViewWithTagSort];
                         
                         for (int i=0;i<_productDataArr.count;i++) {
                             
                             YSKJ_drawModel *model = _productDataArr[i];
                             model.imageId = [NSString stringWithFormat:@"%d",1000 + 10*i];
                         }
                     }
   
                 }
    
            }
   
        }

        [self showAllImageTransformOperation];
        
        [_targetView tf_showAllControlPoint];
        
        [self addBorder];
 
    }];
    
}


-(void)setRightAction
{
    if ([_drawModel.rotation integerValue] != 0) {
        
        [self hideAllImageOperation];
        
        UIImageView *proImg = [[UIImageView alloc] init];
        
        [_canvas addSubview:proImg];
        
        //获取网络图片的Size
        [proImg sd_setImageWithPreviousCachedImageWithURL:[[NSURL alloc] initWithString:_drawModel.src] placeholderImage:nil options:(SDWebImageRetryFailed) progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
        } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            
            if (image.size.height>0 && image.size.width>0) {
                
                 [_targetView removeFromSuperview];
                
                float w = image.size.width*[_drawModel.scaleX floatValue];
                float h = image.size.height*[_drawModel.scaleY floatValue];
                float x=[_drawModel.x floatValue] - w/2 ;
                float y=[_drawModel.y floatValue] - h/2 ;
                
                proImg.frame = CGRectMake(x, y, w, h);
                
                proImg.tag = _targetView.tag;
                
                _targetView = proImg;
                
                [_canvas insertSubview:proImg atIndex:(_targetView.tag-1000)/10];
                
                _drawModel.originX = [NSString stringWithFormat:@"%f",x];
                _drawModel.originY = [NSString stringWithFormat:@"%f",y];
                _drawModel.w = [NSString stringWithFormat:@"%f",w];
                _drawModel.h = [NSString stringWithFormat:@"%f",h];
                
                proImg.image = image;
               
                //是否镜像
                if ([_drawModel.mirror integerValue] == 1) {
                    
                    proImg.image = [proImg.image rotate:UIImageOrientationUpMirrored];
                    
                }
                
                proImg.transform = CGAffineTransformMakeRotation(0);

                _drawModel.rotation = @"0";
                
                [self addHistoryArr];
                
            }
        }];
        
        [self showAllImageTransformOperation];
        
        [self addBorder];
        
        [_targetView tf_showAllControlPoint];
        
    }
    
}

-(void)deleteAction
{

    //1.先移除_productDataArr对应的model
    [_productDataArr removeObjectAtIndex:(_targetView.tag - 1000)/10];
    
    //2.加入历史纪录
    [self addHistoryArr];
    
    //3.移除视图 (*每一个图片对应一个CtrView,取消操作，即移除对应的CtrView)
    [_targetView tf_hideTransformOperation];
    [_targetView removeFromSuperview];
    
    //4.画板全部视图tag重新按顺序排列
    for (int i=0; i<[self imageViewArr].count; i++) {
        UIImageView *imageView = [self imageViewArr][i];
        imageView.tag = 1000 + i*10;
    }
    
    for (int i=0;i<_productDataArr.count;i++) {
        
        YSKJ_drawModel *model = _productDataArr[i];
        model.imageId = [NSString stringWithFormat:@"%d",1000 + 10*i];
    }
    
    [_targetView tf_hideAllControlPoint];
    
    if (_productDataArr.count!=0) {
        _copyBut.enabled = YES;
    }else{
        _copyBut.enabled = NO;
    }
    
    _lockBut.enabled = NO;
    _mirrorBut.enabled = NO;
    _copyBut.enabled = NO;
    _moveBut.enabled = NO;
    _deletBut.enabled = NO;
    _setRightBtn.enabled = NO;
    
    _shaLayer.strokeColor = [UIColor clearColor].CGColor;
    
    
}

-(void)autosaveAction:(UIButton*)sender
{
    if (sender.selected == NO) {
        sender.selected = YES;
        [sender setImage:[UIImage imageNamed:@"OpenAutoSave"] forState:UIControlStateNormal];
    }else{
        sender.selected = NO;
        [sender setImage:[UIImage imageNamed:@"CloseAutoSave"] forState:UIControlStateNormal];
    }
}

-(void)selectOrderAction
{
    if (_productDataArr.count!=0) {
        
        NSMutableArray *proIdArr = [[NSMutableArray alloc] init];
        
        for (YSKJ_drawModel *model in _productDataArr) {
            if ([model.pid integerValue]!=888) {
                [proIdArr addObject:model.pid];
            }
        }
        
        YSKJ_OrderListViewController *list = [[YSKJ_OrderListViewController alloc] init];
        list.proIdArr = proIdArr;
        list.planName = _planName;
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:list];
        //模态风格
        [self presentViewController:navi animated:YES completion:^{
            
        }];
        
    }else{
        
        [YSKJ_CanvasLoading showNotificationViewWithText:@"当前拼图没有单品，无法导出清单" loadType:fail];
        
    }
    
}

-(void)exportImageAction
{
    
    [YSKJ_CanvasLoading showNotificationViewWithText:@"正在导出..." loadType:loading];

    _shaLayer.strokeColor = [UIColor clearColor].CGColor;
    [_targetView tf_hideAllControlPoint];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [YSKJ_ScreenShotClass screenShotView:_canvas CGRect:_canvas.bounds CGSize:CGSizeMake(934, 658) key:@"projecturl" bucket:@"design" successBlock:^(NSString *key) {
            
            [YSKJ_CanvasLoading showNotificationViewWithText:nil loadType:done];
            
            [YSKJ_OrderPopWindow showPopViewWithTitle:key triangleX:105 CopyBlock:^(NSString *url) {
                
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                
                pasteboard.string = url;
                
            } openUrlBlock:^(NSString *url) {
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                
            }tagBlock:^() {
                
            }];
            
        } failBlock:^{
            
            [YSKJ_CanvasLoading showNotificationViewWithText:nil loadType:done];
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if (_lockBut.enabled != NO) {
                _shaLayer.strokeColor = UIColorFromHex(0xbbbbbe).CGColor;
                [_targetView tf_showAllControlPoint];
            }
            
        });
    });
}

-(void)moveAllAction
{
    for (UIView *view in _canvas.subviews) {
        [view removeFromSuperview];
    }
    
    [_productDataArr removeAllObjects];
    
    [self addHistoryArr];
    
    _lockBut.enabled = NO;
    _mirrorBut.enabled = NO;
    _copyBut.enabled = NO;
    _moveBut.enabled = NO;
    _deletBut.enabled = NO;
    _setRightBtn.enabled = NO;
    
    _shaLayer.strokeColor = [UIColor clearColor].CGColor;
    
}

-(void)natureAction
{
    _slider1.superview.hidden = YES;
    _slider2.superview.hidden = YES;
    _corssSliderX.hidden = YES;
    _corssSliderY.hidden = YES;
    
    if (_scaleValue!=100) {

        _scaleValue = 100;
        
        pinView.scaleValue = 100;
        
        float scale = (self.view.frame.size.width-90)/_canvas.frame.size.width;
        
        _canvas.transform = CGAffineTransformScale(_canvas.transform, scale, scale);
        
        _canvas.frame = CGRectMake(70, 90, (self.view.frame.size.width-90), (self.view.frame.size.height-110));

        [self addCorssRectView];

    }
}

-(void)subtractAction
{
    if (_scaleValue>50) {
        
        pinView.scaleValue = _scaleValue-10;
        _scaleValue -= 10;
        
        if (_scaleValue<=100) {
            _slider1.superview.hidden = YES;
            _slider2.superview.hidden = YES;
            _corssSliderX.hidden = YES;
            _corssSliderY.hidden = YES;
        }
        
        float scale = _canvas.frame.size.width/(_canvas.frame.size.width*0.1+_canvas.frame.size.width);
        
        _canvas.transform = CGAffineTransformScale(_canvas.transform, scale, scale);
        
        _canvas.frame = CGRectMake((self.view.frame.size.width - _canvas.frame.size.width+50)/2 , (self.view.frame.size.height - _canvas.frame.size.height+70)/2, _canvas.frame.size.width, _canvas.frame.size.height);
        
        _slider1.frame = CGRectMake((70-_canvas.frame.origin.x)/2, 0, _slider1.superview.frame.size.width - (70-_canvas.frame.origin.x), 6);
        
        _slider2.frame = CGRectMake(0, (90-_canvas.frame.origin.y)/2, 6, _slider2.superview.frame.size.height - (90-_canvas.frame.origin.y));
        
        _corssSliderX.frame = CGRectMake((70-_canvas.frame.origin.x)/2 + 50, _corssSliderX.frame.origin.y, _slider1.frame.size.width, 40);
        
        _corssSliderY.frame = CGRectMake(self.view.frame.size.width - 40, (90-_canvas.frame.origin.y)/2 + 70, _corssSliderY.frame.origin.y, _slider2.frame.size.height);
        
        sliderX = _corssSliderX.frame.origin.x;
        
        sliderY = _corssSliderY.frame.origin.y;
        
        canvasX = sliderX;
        canvasY = sliderY;
        
        canvasCenterX = _canvas.centerX;
        canvasCenterY = _canvas.centerY;
        
        [self addCorssRectView];
        
    }
    
}

-(void)addScaleAction
{
    if (_scaleValue<=190) {
        
        pinView.scaleValue = _scaleValue+10;
        
        _scaleValue += 10;
        
        if (_scaleValue>100) {
            _slider1.superview.hidden = NO;
            _slider2.superview.hidden = NO;
            _corssSliderX.hidden = NO;
            _corssSliderY.hidden = NO;
        }
        
        _canvas.transform = CGAffineTransformScale(_canvas.transform, 1.1, 1.1);
        
        _canvas.frame = CGRectMake((self.view.frame.size.width - _canvas.frame.size.width+50)/2 , (self.view.frame.size.height - _canvas.frame.size.height+70)/2, _canvas.frame.size.width, _canvas.frame.size.height);
        
        _slider1.frame = CGRectMake((70-_canvas.frame.origin.x)/2, 0, _slider1.superview.frame.size.width - (70-_canvas.frame.origin.x), 6);
        
        _slider2.frame = CGRectMake(0, (90-_canvas.frame.origin.y)/2, 6, _slider2.superview.frame.size.height - (90-_canvas.frame.origin.y));

        _corssSliderX.frame = CGRectMake((70-_canvas.frame.origin.x)/2 + 50, _corssSliderX.frame.origin.y, _slider1.frame.size.width, 40);
        
        _corssSliderY.frame = CGRectMake(self.view.frame.size.width - 40, (90-_canvas.frame.origin.y)/2 + 70, _corssSliderY.frame.origin.y, _slider2.frame.size.height);
        
        sliderX = _corssSliderX.frame.origin.x;
        sliderY = _corssSliderY.frame.origin.y;
        
        canvasX = sliderX;
        canvasY = sliderY;
        
        canvasCenterX = _canvas.centerX;
        canvasCenterY = _canvas.centerY;

        [self addCorssRectView];
    
    }
}

-(void)addCorssRectView
{
    _top.frame = CGRectMake(0, 0, self.view.frame.size.width, _canvas.frame.origin.y );
    _letf.frame = CGRectMake(0, 0, _canvas.frame.origin.x , self.view.frame.size.height);
    _rig.frame = CGRectMake( _canvas.frame.origin.x + _canvas.frame.size.width, 0, self.view.frame.size.width - _canvas.frame.origin.x - _canvas.frame.size.width, self.view.frame.size.height);
    _rigImage.frame = CGRectMake(0, _canvas.frame.origin.y, 10, _canvas.frame.size.height);
    _bot.frame = CGRectMake(0, _canvas.frame.origin.y+_canvas.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _canvas.frame.origin.y - _canvas.frame.size.height);
    _botImage.frame = CGRectMake(_canvas.frame.origin.x, 0, _canvas.frame.size.width, 15);
    _corner.frame = CGRectMake(_canvas.frame.origin.x + _canvas.frame.size.width, 0, 10, 15);
}

- (void) handlePan1:(UIPanGestureRecognizer*) recognizer
{
    CGPoint translation = [recognizer translationInView:recognizer.view.superview];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointZero inView:recognizer.view.superview];
    
    float x;
    if (recognizer.view.frame.origin.x<50) {
        x = 50;
    }else{
        x = recognizer.view.frame.origin.x;
    }
    
    if (recognizer.view.frame.origin.x>2*sliderX - 50) {
        x = 2*sliderX-50;
    }
    
    recognizer.view.frame = CGRectMake(x, self.view.frame.size.height - 40, _corssSliderX.frame.size.width, 40);
    
    _slider1.frame = CGRectMake(x-50, _slider1.frame.origin.y, recognizer.view.frame.size.width, 6);
    
    float offx = sliderX - recognizer.view.frame.origin.x;
    
    float centerX = canvasCenterX + offx*2;
    
    float x1=centerX-_canvas.frame.size.width/2;
    
    if (recognizer.view.frame.origin.x>0 && recognizer.view.frame.origin.x<2*sliderX) {
        _canvas.frame = CGRectMake(x1, _canvas.frame.origin.y, _canvas.frame.size.width, _canvas.frame.size.height);
    }
    
    [self addCorssRectView];;
    
}

- (void) handlePan2:(UIPanGestureRecognizer*) recognizer
{
    CGPoint translation = [recognizer translationInView:recognizer.view.superview];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointZero inView:recognizer.view.superview];
    
    float y;
    if (recognizer.view.frame.origin.y<70) {
        y = 70;
    }else{
        y = recognizer.view.frame.origin.y;
    }
    
    if (recognizer.view.frame.origin.y>2*sliderY-70) {
        y = 2*sliderY-70;
    }
    
    recognizer.view.frame = CGRectMake(self.view.frame.size.width-40, y, 40, _corssSliderY.frame.size.height);
    
    _slider2.frame = CGRectMake(0, y-70, 6, recognizer.view.frame.size.height);
    
    float offx = sliderY - recognizer.view.frame.origin.y;
    
    float centerY = canvasCenterY + offx*2;
    
    float y1=centerY-_canvas.frame.size.height/2;
    
    if (recognizer.view.frame.origin.y>0 && recognizer.view.frame.origin.y<2*sliderY) {
        _canvas.frame = CGRectMake(_canvas.frame.origin.x, y1, _canvas.frame.size.width, _canvas.frame.size.height);
    }
    
    [self addCorssRectView];
    
}

-(void)beganPanAction:(NSNotification*)notification
{
    _detail.hidden = YES;
    _planView.hidden = YES;
    _uilityView.hidden = YES;
    _sigleDeView.hidden = YES;
    _myLoad.hidden = YES;
    
    _cancleSide.hidden = YES;
    _cancleSide1.hidden = YES;
    
    [self hideAllImageOperation];
    
    _shaLayer.strokeColor = [UIColor clearColor].CGColor;
    
    _corssView = [[UIView alloc] initWithFrame:CGRectMake(0,0, _canvas.frame.size.width, _canvas.frame.size.height)];
    [_canvas addSubview:_corssView];
    
    UIPanGestureRecognizer *panGes = [notification.userInfo objectForKey:@"ges"] ;
    
    UIButton *button = [notification.userInfo objectForKey:@"button"];
    
    CGPoint location = [panGes locationInView:button];
    
    CGPoint point = [button convertPoint:location toView:_canvas];
    
    _panButton=[[UIButton alloc] initWithFrame:CGRectMake(point.x-(button.size.width)/2, point.y-(button.frame.size.width)/2, button.frame.size.width, button.frame.size.height)];
    _panButton.alpha = 0.8;
    [_panButton setImage:button.imageView.image forState:UIControlStateNormal];
    _panButton.imageEdgeInsets=button.imageEdgeInsets;
    [_corssView addSubview:_panButton];

}

-(void)panAction:(NSNotification*)notification
{
    UIPanGestureRecognizer *panGes = [notification.userInfo objectForKey:@"ges"] ;
    
    UIButton *button = [notification.userInfo objectForKey:@"button"];
    
    CGPoint location = [panGes locationInView:button];
    
    CGPoint point = [button convertPoint:location toView:_canvas];
    
    if (point.x>0 && button.size.width>0 && point.y>0 && button.size.height>0) {
        
        _panButton.frame=CGRectMake(point.x-(button.size.width)/2, point.y-(button.frame.size.width)/2, button.frame.size.width, button.frame.size.height);
    }
    
    CGPoint centerPoint = CGPointMake(_panButton.center.x, _panButton.center.y);
    
    BOOL containsPoint=NO;
    
    _targetView = nil;
    
    for (UIView *subView in _canvas.subviews) {
        
        if (subView!=_corssView && [subView isKindOfClass:[UIImageView class]]) {
            
            if (CGRectContainsPoint(subView.frame, centerPoint)) {
                
                YSKJ_drawModel *model = _productDataArr[(subView.tag-1000)/10];
        
                if ([model.objtype isEqualToString:@"product"]) {
                    
                    _targetView = (UIImageView *)subView;
                    
                    _drawModel = _productDataArr[(subView.tag-1000)/10];
                    
                    if ([_drawModel.lock integerValue]!=1) {
                        
                        for (UIView *view in _corssView.subviews) {
                            if (![view isKindOfClass:[UIButton class]]) {
                                [view removeFromSuperview];
                            }
                        }
                        
                        UIImageView *imageView = [[UIImageView alloc] init];
                        
                        [_corssView addSubview:imageView];
                        
                        [imageView sd_setImageWithURL:[NSURL URLWithString:model.src] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                            
                            if (image.size.width>0 && image.size.height>0) {
                                
                                UIView *borView = [[UIView alloc] init];
                                
                                float w = image.size.width*[model.scaleX floatValue];
                                float h = image.size.height*[model.scaleY floatValue];
                                float x=[_drawModel.x floatValue] - w/2 ;
                                float y=[_drawModel.y floatValue] - h/2 ;
                                
                                borView.frame = CGRectMake(x-5, y-5, w+10, h+10);
                                
                                //是否镜像，并得到弧度
                                if ([model.mirror integerValue] == 1) {
                                    CGFloat angle = (-[model.rotation floatValue])/180*M_PI ;
                                    borView.transform = CGAffineTransformMakeRotation(angle);
                                }else{
                                    CGFloat angle = [model.rotation floatValue]/180*M_PI ;
                                    borView.transform = CGAffineTransformMakeRotation(angle);
                                }
                                
                                [_corssView addSubview:borView];
                                
                                _panShaLayer.strokeColor = UIColorFromHex(0x00abf2).CGColor;
                                _panShaLayer.fillColor = nil;
                                _panShaLayer.path = [UIBezierPath bezierPathWithRect:borView.bounds].CGPath;
                                _panShaLayer.frame =  borView.bounds;
                                [borView.layer addSublayer:_panShaLayer];

                            }
                            
                        }];
                        
                        containsPoint = YES;
                        
                    }else{
                        
                        _targetView = nil;
                        containsPoint = NO;
                        
                    }

                }
                
                
            }else{
                
                if (containsPoint == NO) {
                    _targetView = nil;
                    for (UIView *view in _canvas.subviews) {
                        if ([view isKindOfClass:[UIImageView class]]) {
                            _panShaLayer.strokeColor = [UIColor clearColor].CGColor;
                        }

                    }
                }
                
            }
  
        }
    }
    

}

-(void)endAction:(NSNotification*)notification
{
    _panShaLayer.strokeColor = [UIColor clearColor].CGColor;
    
    NSDictionary *obj = [notification.userInfo objectForKey:@"dict"];
    
    if ([obj objectForKey:@"netW"]  && [obj objectForKey:@"netH"]) { //防止如果没加载图片出来，obj不存在netW和netH，key时引起闪退。
        
        if (_targetView==nil) {
            
            _cancleSide.hidden = NO;
            _cancleSide1.hidden = NO;
            
            [_corssView removeFromSuperview];
            _detail.hidden = NO;
            _planView.hidden = NO;
            _uilityView.hidden = NO;
            _sigleDeView.hidden = NO;
            _myLoad.hidden = NO;
            
            [self showAllImageTransformOperation];
            
            [_targetView tf_showAllControlPoint];
            
            [self add:obj];
            
        }else{
            
            [_panButton removeFromSuperview];
            UIView *view = [[UIImageView alloc] initWithFrame:CGRectMake(_targetView.center.x-40, _targetView.center.y-12.5, 80, 25)];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:view.bounds];
            NSURL *localUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"panGif" ofType:@"gif"]];
            imageView= [AnimatedGif getAnimationForGifAtUrl:localUrl];
            [view addSubview:imageView];
            [_corssView addSubview:view];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [_corssView removeFromSuperview];
                
                _detail.hidden = NO;
                _planView.hidden = NO;
                _uilityView.hidden = NO;
                _sigleDeView.hidden = NO;
                _myLoad.hidden = NO;
                
                _cancleSide.hidden = NO;
                _cancleSide1.hidden = NO;
                
                NSString *urlStr = [obj objectForKey:@"thumb_file"];
                
                //3.替换url,pid
                _drawModel.src = urlStr;
                _drawModel.pid = [obj objectForKey:@"id"];
                _drawModel.objtype = @"product";
                
                //6.加入历史纪录
                [self addHistoryArr];
                
                for (UIView *subViews in _canvas.subviews) {
                    [subViews removeFromSuperview];
                }
                
                YSKJ_HistoryModel *hisModel =[_historiesArr lastObject];
                
                [self setUpOpenPlanView:hisModel.data boolLoad:NO];
                
                //8.能替换说明没锁，打开导航栏的锁
                _lockBut.selected = NO;
                [_lockBut setImage:[UIImage imageNamed:@"Unlock"] forState:UIControlStateNormal];
                
                _lockBut.enabled = YES;
                _mirrorBut.enabled = YES;
                _copyBut.enabled = YES;
                _moveBut.enabled = YES;
                _deletBut.enabled = YES;
                _setRightBtn.enabled = YES;
                
                _targetView = [_canvas viewWithTag:_targetView.tag];
                
                [_targetView tf_showAllControlPoint];
                
                _sigleDeView.model = _drawModel;
                
                if (_targetView!=nil && (_targetView.tag-1000)/10<=_productDataArr.count-1) {

                    _drawModel = _productDataArr[(_targetView.tag-1000)/10];
                    
                    [self addBorder];
                    
                }else{
                    
                    _lockBut.enabled = NO;
                    _mirrorBut.enabled = NO;
                    _copyBut.enabled = NO;
                    _moveBut.enabled = NO;
                    _deletBut.enabled = NO;
                    _setRightBtn.enabled = NO;
                }
                
            });
        }
        
    }else{
        
        [_corssView removeFromSuperview];
        
        _detail.hidden = NO;
        _planView.hidden = NO;
        _uilityView.hidden = NO;
        _sigleDeView.hidden = NO;
        _myLoad.hidden = NO;
        
        _cancleSide.hidden = NO;
        _cancleSide1.hidden = NO;
        
        [self showAllImageTransformOperation];
        
        [_targetView tf_showAllControlPoint];
        
    }
}

#pragma mark util 

-(void)canvasImageViewWithTagSort
{
    //画板全部视图tag重新按顺序排列
    for (int i=0; i<[self imageViewArr].count; i++) {
        UIImageView *imageView = [self imageViewArr][i];
        imageView.tag = 1000 + i*10;
    }
}

-(void)hideAllImageOperation{
    for (UIView *subView in _canvas.subviews) {
        if ([subView isKindOfClass:[UIImageView class]]) {
            [subView tf_hideTransformOperation];
        }
    }
}

-(void)showAllImageTransformOperation
{
    for (UIView *view in _canvas.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view tf_showTransformOperationWithConfiguration:cnf delegate:self];
        }
    }
}

-(NSMutableArray*)imageViewArr     //获得画板图片数组
{
    NSMutableArray *imageArr = [[NSMutableArray alloc] init];
    for (UIView *subView in _canvas.subviews) {
        if ([subView isKindOfClass:[UIImageView class]]) {
            [imageArr addObject:subView];
        }
    }
    return imageArr;
}

-(UIImageView *)rotateImage         //获得旋转图片
{
    UIImageView *rotImage;
    NSMutableArray *ctrViewArr = [[NSMutableArray alloc] init];
    for (UIView *subView in _canvas.subviews) {
        if (![subView isKindOfClass:[UIImageView class]]) {
            [ctrViewArr addObject:subView];
        }
    }
    
    UIView *ctrView = ctrViewArr[(_targetView.tag - 1000)/10];
    for (UIView *sub in ctrView.subviews) {
        if (sub.tag == 10) {
            for (UIView *view in sub.subviews) {
                rotImage = (UIImageView*)view;
            }
        }
    }
    return rotImage;
}

-(void)updateProductDataArr
{
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    for (UIView *subView in _canvas.subviews) {
        for (YSKJ_drawModel *model in _productDataArr) {
            if (subView.tag == [model.imageId integerValue]) {
                model.x = [NSString stringWithFormat:@"%f",subView.center.x];
                model.y = [NSString stringWithFormat:@"%f",subView.center.y];
                [tempArr addObject:model];
            }
        }
    }
    _productDataArr = tempArr;
    
}

-(void)addBorder
{
     UIView *_lt,*_rt,*_rb,*_lb;
    
    if (_targetView==nil || (_targetView.tag-1000)/10>_productDataArr.count-1) {
        return;
    }
    
    NSMutableArray *ctrViewArr = [[NSMutableArray alloc] init];
    for (UIView *subView in _canvas.subviews) {
        if (![subView isKindOfClass:[UIImageView class]]) {
            [ctrViewArr addObject:subView];
        }
    }
    UIView *ctrView = ctrViewArr[(_targetView.tag - 1000)/10];
    for (UIView *sub in ctrView.subviews) {
        if (sub.userInteractionEnabled!=NO) {
            if (sub.tag==1 ) {_lt=sub;}if (sub.tag==2 ) {_lb=sub;}
            if (sub.tag==3 ) {_rb=sub;}if (sub.tag==4 ) {_rt=sub;}
        }
    }
    
    UIBezierPath *aPath = [UIBezierPath bezierPath];
    CGPoint point1 = [_lt.superview convertPoint:_lt.center toView:_canvas];
    CGPoint point2 = [_lb.superview convertPoint:_lb.center toView:_canvas];
    CGPoint point3 = [_rb.superview convertPoint:_rb.center toView:_canvas];
    CGPoint point4 = [_rt.superview convertPoint:_rt.center toView:_canvas];
    [aPath moveToPoint:CGPointMake(point1.x,point1.y)];
    [aPath addLineToPoint:CGPointMake(point2.x,point2.y)];
    [aPath addLineToPoint:CGPointMake(point3.x,point3.y)];
    [aPath addLineToPoint:CGPointMake(point4.x,point4.y)];
    [aPath closePath];
    _shaLayer.strokeColor = UIColorFromHex(0xbbbbbe).CGColor;
    _shaLayer.fillColor = nil;
    _shaLayer.path = aPath.CGPath;
    [_canvas.layer addSublayer:_shaLayer];
}

-(void)add:(NSDictionary*)obj{
    
    _lockBut.selected = NO;
    
    float netW = [[obj objectForKey:@"netW"] floatValue];
    
    float netH = [[obj objectForKey:@"netH"] floatValue];

    float centerX = _panButton.center.x;
    float centerY = _panButton.center.y;
    
    float x=centerX-(netW*0.2)/2;
    float y=centerY-(netH*0.2)/2;
    
    NSDictionary *jsonDict = @{
                               @"x":[NSString stringWithFormat:@"%0.2f",centerX],
                               @"y":[NSString stringWithFormat:@"%0.2f",centerY],
                               @"scaleX":@0.2,
                               @"scaleY":@0.2,
                               @"rotation":@0,
                               @"objtype":@"product",
                               @"mirror":@0,
                               @"src":[obj objectForKey:@"thumb_file"],
                               @"lock":@0,
                               @"pid":[obj objectForKey:@"id"],
                               @"naturew":[obj objectForKey:@"netW"],
                               @"natureh":[obj objectForKey:@"netH"],
                               @"originX":[NSString stringWithFormat:@"%f",x],
                               @"originY":[NSString stringWithFormat:@"%f",y],
                               @"w":[NSString stringWithFormat:@"%f",netW*0.2],
                               @"h":[NSString stringWithFormat:@"%f",netH*0.2]
                               };

    YSKJ_drawModel *model = [YSKJ_drawModel mj_objectWithKeyValues:jsonDict];
    [self addProToDrawBoard:model];
    
}

#pragma mark addToCanvasNotification

-(void)addNoitfiAction:(NSNotification*)notification
{
    YSKJ_drawModel *model = [notification.userInfo objectForKey:@"model"];
    [self addProToDrawBoard:model];
}



#pragma mark 相似商品

-(void)updateAsameProduct
{
    if (_lockBut.enabled!=NO) {
        _sigleDeView.model = _drawModel;
    }
}

#pragma mark YSKJ_PlanViewDelegate

-(void)addPlan;
{
    for (UIView *view in _canvas.subviews) {
        [view removeFromSuperview];
    }
    _shaLayer.strokeColor = [UIColor clearColor].CGColor;
    [_count removeAllObjects];
    [_productDataArr removeAllObjects];
    
    _planId = @"";
    
     _planName = @"";
    
    [_historiesArr removeAllObjects];
    
    boolOpenInputName = YES;
    
    [self addHistoryArr];
    
    _lockBut.enabled = NO;
    _recallBut.enabled = NO;
    _nextBut.enabled = NO;
    _mirrorBut.enabled = NO;
    _copyBut.enabled = NO;
    _moveBut.enabled = NO;
    _deletBut.enabled = NO;
    _setRightBtn.enabled = NO;
    
    _targetView = nil;
    
}

-(void)editPlan:(NSDictionary *)dict;
{
    for (UIView *view in _canvas.subviews) {
        [view removeFromSuperview];
    }
    [_count removeAllObjects];
    
    [_productDataArr removeAllObjects];
    
    [_historiesArr removeAllObjects];

    NSArray *data = [ToolClass arrayWithJsonString:[dict objectForKey:@"data_value"]];
    
    _planId = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
    
    _sname = [NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
    
    _planName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
    
    for ( NSDictionary *dict in  data) {
        
        [_productDataArr addObject:[YSKJ_drawModel mj_objectWithKeyValues:dict]];
        
    }

    [self addHistoryArr];
    
    YSKJ_HistoryModel *hisModel = [_historiesArr lastObject];
    
    [self setUpOpenPlanView:hisModel.data boolLoad:YES];
    

    _shaLayer.strokeColor = [UIColor clearColor].CGColor;
    
    _lockBut.enabled = NO;
    _recallBut.enabled = NO;
    _nextBut.enabled = NO;
    _mirrorBut.enabled = NO;
    _copyBut.enabled = NO;
    _moveBut.enabled = NO;
    _deletBut.enabled = NO;
    _setRightBtn.enabled = NO;
    
    _sigleDeView.model = nil;
    _targetView = nil;
    
    if ([_sname isEqualToString:@"未命名"]) {
        boolOpenInputName = YES;
    }else{
        boolOpenInputName = NO;
    }
    
}

-(void)deletePlan:(NSDictionary *)dict;
{
    if ([[dict objectForKey:@"id"] integerValue] == [_planId integerValue]) {
        
         _planId = @"";
        
        _planName = @"";
        
        boolOpenInputName = YES;
        
        [_productDataArr removeAllObjects];
        for (UIView *subView in _canvas.subviews) {
            [subView removeFromSuperview];
        }
        _drawModel = nil;
        _targetView = nil;
        _shaLayer.strokeColor = [UIColor clearColor].CGColor;
        
        _lockBut.enabled = NO;
        _nextBut.enabled = NO;
        _mirrorBut.enabled = NO;
        _copyBut.enabled = NO;
        _moveBut.enabled = NO;
        _deletBut.enabled = NO;
        _setRightBtn.enabled = NO;

    }else{
        
        if ([_sname isEqualToString:@"未命名"]) {
            boolOpenInputName = YES;
        }else{
            boolOpenInputName = NO;
        }
        
    }
    
}

#pragma mark SavePlan

-(void)updatePlan:(BOOL)boolTimer
{
    NSDictionary *param;
    
    if (_sname == nil) {
        
        param =@{
                 @"userid":[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"],
                 @"id":_planId,
                 @"data_value":[self data_value]
                 };
        
    }else{
    
        param =@{
                 @"userid":[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"],
                 @"id":_planId,
                 @"data_value":[self data_value],
                 @"sname":_sname
                 };
    }
    
    HttpRequestCalss *requset=[[HttpRequestCalss alloc ] init];
    
    if (boolTimer != YES) {
        [YSKJ_CanvasLoading showNotificationViewWithText:@"正在修改..." loadType:loading];
    }
    
    [requset postHttpDataWithParam:param url:UPDATEPLAN  success:^(NSDictionary *dict, BOOL success) {
        
        _shaLayer.strokeColor = [UIColor clearColor].CGColor;
        [_targetView tf_hideAllControlPoint];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [YSKJ_ScreenShotClass screenShotView:_canvas CGRect:_canvas.bounds CGSize:CGSizeMake(600, 600/_canvas.frame.size.width*_canvas.frame.size.height) key:@"solutionface" bucket:@"design" successBlock:^(NSString *key) {
                
                [self updatePlanFace:key];
                
                
            } failBlock:^{
                
                [YSKJ_CanvasLoading showNotificationViewWithText:nil loadType:done];
            }];
            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                if (_lockBut.enabled != NO) {
                    _shaLayer.strokeColor = UIColorFromHex(0xbbbbbe).CGColor;
                    [_targetView tf_showAllControlPoint];
                }
 
            });
        });
        
    } fail:^(NSError *error) {
        
        [YSKJ_CanvasLoading showNotificationViewWithText:nil loadType:done];
        [YSKJ_CanvasLoading showNotificationViewWithText:@"修改失败" loadType:fail];

    }];
}

-(void)savePlan:(NSString*)planName boolTimer:(BOOL)boolTimer
{
    NSDictionary *param=@{
                          @"data_value":[self data_value],
                          @"userid":[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"],
                          @"sname":planName
                          };
    
    HttpRequestCalss *requset=[[HttpRequestCalss alloc ] init];
    
    if (boolTimer!=YES) {
        [YSKJ_CanvasLoading showNotificationViewWithText:@"正在保存..." loadType:loading];
    }else{
        _planName = @"未命名";
    }
    
    [requset postHttpDataWithParam:param url:ADDPROPLAN  success:^(NSDictionary *dict, BOOL success) {
        
        _planId = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"data"] objectForKey:@"id"]];
        
        _shaLayer.strokeColor = [UIColor clearColor].CGColor;
        [_targetView tf_hideAllControlPoint];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [YSKJ_ScreenShotClass screenShotView:_canvas CGRect:_canvas.bounds CGSize:CGSizeMake(600, 600/_canvas.frame.size.width*_canvas.frame.size.height) key:@"solutionface" bucket:@"design" successBlock:^(NSString *key) {
                
                [self updatePlanFace:key];
                
                
            } failBlock:^{
                
                 [YSKJ_CanvasLoading showNotificationViewWithText:nil loadType:done];
            }];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                if (_lockBut.enabled != NO) {
                    _shaLayer.strokeColor = UIColorFromHex(0xbbbbbe).CGColor;
                    [_targetView tf_showAllControlPoint];
                }
            });
            
        });
        
    } fail:^(NSError *error) {
        
        [YSKJ_CanvasLoading showNotificationViewWithText:nil loadType:done];
        [YSKJ_CanvasLoading showNotificationViewWithText:@"保存失败" loadType:fail];
        
    }];
}

-(NSString*)data_value
{
    [self updateProductDataArr];
    
    NSMutableArray *jsonArr = [[NSMutableArray alloc] init];
    
    for (YSKJ_drawModel *model in _productDataArr) {
        
        NSDictionary *proDict = @{
                                  @"pid":model.pid,
                                  @"x":model.x,
                                  @"y":model.y,
                                  @"scaleX":model.scaleX,
                                  @"scaleY":model.scaleY,
                                  @"rotation":model.rotation,
                                  @"objtype":model.objtype,
                                  @"lock":model.lock,
                                  @"mirror":model.mirror,
                                  @"src":model.src,
                                  };
        
        [jsonArr addObject:proDict];
    }
    
    return [ToolClass stringWithArr:jsonArr];
    
}

//修改方案头像
-(void)updatePlanFace:(NSString *)key
{
    HttpRequestCalss *requset=[[HttpRequestCalss alloc ] init];
    
    NSDictionary *param=
    @{
      @"userid":[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"],
      @"id":_planId,
      @"url":key
      };
    
    [requset postHttpDataWithParam:param url:UPDATEPLANFACE  success:^(NSDictionary *dict, BOOL success) {
        
        _planView.updata = @"";
        
        [YSKJ_CanvasLoading showNotificationViewWithText:nil loadType:done];

    } fail:^(NSError *error) {

    }];
 
}

@end


