//
//  YSKJ_OrderListViewController.m
//  YSKJ_MATCH
//
//  Created by YSKJ on 18/1/10.
//  Copyright © 2018年 com.yskj. All rights reserved.
//

#import "YSKJ_OrderListViewController.h"

#define UIColorFromHex(s)  [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1]

@interface YSKJ_OrderListViewController ()<UITableViewDataSource,UITableViewDelegate>

{
    UITableView *_tableView,*_listTableView;
    
    YSKJ_OrderListTabCell *_cell;
    
    YSKJ_OrderListTabCell1 *_cell1;
    
    NSMutableArray *_detailArr;
}

@end

@implementation YSKJ_OrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title=@"方案清单";
    UIFont *font = [UIFont fontWithName:@"Arial-ItalicMT" size:18];
    UIColor *titleColor=UIColorFromHex(0xffffff);
    NSDictionary *dic = @{NSFontAttributeName:font,
                          NSForegroundColorAttributeName: titleColor};
    self.navigationController.navigationBar.titleTextAttributes =dic;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nabg"] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.view.backgroundColor=UIColorFromHex(0xffffff);
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    UIButton *buttonItem=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [buttonItem addTarget:self action:@selector(dissmissAction) forControlEvents:UIControlEventTouchUpInside];
    [buttonItem setImage:[UIImage imageNamed:@"Back"] forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:buttonItem];
    
    UIButton *buttontitle=[[UIButton alloc] initWithFrame:CGRectMake(0, 0,40, 40)];
    UIColor *titlecol=UIColorFromHex(0xffffff);
    [buttontitle setTitleColor:titlecol forState:UIControlStateNormal];
    [buttontitle addTarget:self action:@selector(dissmissAction) forControlEvents:UIControlEventTouchUpInside];
    [buttontitle setTitle:@"返回" forState:UIControlStateNormal];
    UIBarButtonItem *titeitem = [[UIBarButtonItem alloc]initWithCustomView:buttontitle];
    self.navigationItem.leftBarButtonItems=@[leftItem,titeitem];
    
    UIButton *buttonItem1=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [buttonItem1 addTarget:self action:@selector(expList:) forControlEvents:UIControlEventTouchUpInside];
    [buttonItem1 setImage:[UIImage imageNamed:@"exp1"] forState:UIControlStateNormal];
    _listImageBtn = buttonItem1;
    UIBarButtonItem *leftItem1 = [[UIBarButtonItem alloc]initWithCustomView:buttonItem1];
   
    UIButton *buttontitle1=[[UIButton alloc] initWithFrame:CGRectMake(10, 0,40, 40)];
    UIColor *titlecol1=UIColorFromHex(0x00abf2);
    _listBtn = buttontitle1;
    [buttontitle1 setTitleColor:titlecol1 forState:UIControlStateNormal];
    [buttontitle1 addTarget:self action:@selector(expList:) forControlEvents:UIControlEventTouchUpInside];
    [buttontitle1 setTitle:@"清单" forState:UIControlStateNormal];
    UIBarButtonItem *titeitem1 = [[UIBarButtonItem alloc]initWithCustomView:buttontitle1];
    self.navigationItem.rightBarButtonItems=@[titeitem1,leftItem1];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-54-64)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[YSKJ_OrderListTabCell class] forCellReuseIdentifier:@"cellId"];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, _tableView.frame.size.height + _tableView.frame.origin.y, self.view.frame.size.width, 54)];
    view.backgroundColor  =[UIColor whiteColor];
    [self.view addSubview:view];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    line.backgroundColor = UIColorFromHex(0xd8d8d8);
    [view addSubview:line];
    
    UIButton *checkBtn = [[UIButton alloc] initWithFrame:CGRectMake(16, 13, 28, 28)];
    _checkAllBtn = checkBtn;
    checkBtn.selected = YES;
    [checkBtn setImage:[UIImage imageNamed:@"check1"] forState:UIControlStateNormal];
    [checkBtn addTarget:self action:@selector(checkAllAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:checkBtn];
    
    UILabel *pinpai = [[UILabel alloc] initWithFrame:CGRectMake(54,17, 30, 20)];
    pinpai.text = @"全选";
    pinpai.font = [UIFont systemFontOfSize:14];
    pinpai.textColor = UIColorFromHex(0x333333);
    [view addSubview:pinpai];
    
    UILabel *checkTitle = [[UILabel alloc] initWithFrame:CGRectMake(122, 13, 250, 25)];
    _checkTitle = checkTitle;
    checkTitle.textAlignment = NSTextAlignmentLeft;
    [view addSubview:checkTitle];
    
    UILabel *totailePrice = [[UILabel alloc] initWithFrame:CGRectMake(522,  13, 180, 25)];
    _totailePrice = totailePrice;
    totailePrice.textColor = UIColorFromHex(0x00abf2);
    totailePrice.font = [UIFont systemFontOfSize:18];
    [view addSubview:totailePrice];
    
    UILabel *totailTitle = [[UILabel alloc] initWithFrame:CGRectMake(476, 17, 30, 20)];
    totailTitle.text = @"总计";
    totailTitle.font = [UIFont systemFontOfSize:14];
    totailTitle.textColor = UIColorFromHex(0x333333);
    [view addSubview:totailTitle];
    
    _detailArr=[[NSMutableArray alloc] init];
    
    _listTempArray = [[NSMutableArray alloc] init];
    
    [YSKJ_CanvasLoading showNotificationViewWithText:@"正在加载..." loadType:loading];
    
    for (int i=0; i<self.proIdArr.count; i++) {
        
        HttpRequestCalss *httpRequest=[[HttpRequestCalss alloc] init];
    
        NSDictionary *prodict=@{
                                @"id":_proIdArr[i],
                                @"userid":[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]
                                };
        
        [httpRequest postHttpDataWithParam:prodict url:DETAIL success:^(NSDictionary *dict, BOOL success) {
            
            [_detailArr addObject:dict];
            
            if (_detailArr.count==self.proIdArr.count) {
                
                _tempArray=[[NSMutableArray alloc] init];
                
                [YSKJ_ListData listDataArray:self.proIdArr detailArr:_detailArr Block:^(NSMutableArray *array) {
                    _tempArray = array;
                }];
                
                [self getCateNumWithAllNum];
                
                [self getTotailePrice];
                
                [_tableView reloadData];            //刷新界面
                
                _listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,370+146*_tempArray.count+345)];
                _listTableView.delegate = self;
                _listTableView.dataSource = self;
                [self.view addSubview:_listTableView];
                [self.view sendSubviewToBack:_listTableView];
                [_listTableView registerClass:[YSKJ_OrderListTabCell1 class] forCellReuseIdentifier:@"cellId1"];
                
                [self listData];
                
                [YSKJ_CanvasLoading showNotificationViewWithText:nil loadType:done];
    
            }
            
        } fail:^(NSError *error) {
        
        }];
        
    }
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    
    [self.view addGestureRecognizer:singleTap];
    
    //监听软键盘事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    ProTotalPrice = 0.0;
    
}

#pragma mark - 键盘弹出时界面上移及还原


-(void)keyboardWillShow:(NSNotification *) notification{
    
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    float keyBoardHeight = keyboardRect.size.height;
    
    if (_showKeyBord == YES){
        
        //使视图上移
        CGRect viewFrame = self.view.frame;
        viewFrame.origin.y = -keyBoardHeight + 64 + 54;
        self.view.frame = viewFrame;
    }
}

-(void)keyboardWillHide
{
    //使视图还原
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y = 63;
    self.view.frame = viewFrame;
    
}

-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    [self.view endEditing:YES];
    
}

-(void)listData
{
    [_listTempArray removeAllObjects];
    for (NSDictionary *dict in _tempArray) {
        if ([[dict objectForKey:@"check"] integerValue] == 1) {
            [_listTempArray addObject:dict];
        }
    }
    _listTableView.frame = CGRectMake(0, 0, self.view.frame.size.width,370+146*_listTempArray.count+345);
    [_listTableView reloadData];
}

-(void)checkAllAction:(UIButton*)sender
{
    
    
    if (sender.selected == YES) {
        sender.selected =NO;
        [sender setImage:[UIImage imageNamed:@"Unchecked"] forState:UIControlStateNormal];
        for (NSDictionary *dicta in _tempArray) {
            [dicta setValue:@"0" forKey:@"check"];
        }
    }else{
        sender.selected =YES;
        [sender setImage:[UIImage imageNamed:@"check1"] forState:UIControlStateNormal];
        for (NSDictionary *dicta in _tempArray) {
            [dicta setValue:@"1" forKey:@"check"];
        }
    }
    
    [self listData];
    
    [self getCateNumWithAllNum];
    
    [self getTotailePrice];
    
    [_tableView reloadData];
    
}

-(void)dissmissAction
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if (_tableView == tableView) {
        return _tempArray.count;
    }else{
        return _listTempArray.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (_tableView == tableView) {
        
        _cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
        
        _cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        YSKJ_orderModel *model = [YSKJ_orderModel  mj_objectWithKeyValues:_tempArray[indexPath.row]];
        
        _cell.model = model;
        
        _cell.totailePrice = [NSString stringWithFormat:@"%0.2f",[model.count integerValue]*[model.price floatValue]];
        
        [_cell.checkBtn addTarget:self action:@selector(checkOneProAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [_cell.editBtn addTarget:self action:@selector(editOneProAciton:) forControlEvents:UIControlEventTouchUpInside];
        
        [_cell.surnBtn addTarget:self action:@selector(sureOneProAciton:) forControlEvents:UIControlEventTouchUpInside];
        
        [_cell.lessen addTarget:self action:@selector(lessenAciton:) forControlEvents:UIControlEventTouchUpInside];
        
        [_cell.add addTarget:self action:@selector(addProAciton:) forControlEvents:UIControlEventTouchUpInside];
        
        if ([model.check integerValue] == 1) {
            _cell.select = YES;
        }else{
            _cell.select = NO;
        }
        
        _cell.nameTextf.delegate = self;
        _cell.pinpaiTextf.delegate = self;
        _cell.pinleiTextf.delegate = self;
        _cell.spaceTextf.delegate = self;
        _cell.styleTextf.delegate = self;
        _cell.beizhuTextf.delegate = self;
        _cell.priceeTextf.delegate = self;
        
        _cell.nameTextf.tag = [[NSString stringWithFormat:@"%ld000",(long)indexPath.row +1] integerValue];
        _cell.pinpaiTextf.tag = [[NSString stringWithFormat:@"%ld001",(long)indexPath.row +1] integerValue];
        _cell.pinleiTextf.tag = [[NSString stringWithFormat:@"%ld002",(long)indexPath.row +1] integerValue];
        _cell.spaceTextf.tag = [[NSString stringWithFormat:@"%ld003",(long)indexPath.row +1] integerValue];
        _cell.styleTextf.tag = [[NSString stringWithFormat:@"%ld004",(long)indexPath.row +1] integerValue];
        _cell.beizhuTextf.tag = [[NSString stringWithFormat:@"%ld005",(long)indexPath.row +1] integerValue];
        _cell.priceeTextf.tag = [[NSString stringWithFormat:@"%ld006",(long)indexPath.row +1] integerValue];
        
        return _cell;

        
    }else{
        
        _cell1 = [tableView dequeueReusableCellWithIdentifier:@"cellId1"];
        
        _cell1.selectionStyle=UITableViewCellSelectionStyleNone;
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        YSKJ_orderModel *model = [YSKJ_orderModel  mj_objectWithKeyValues:_listTempArray[indexPath.row]];
        
        _cell1.model = model;
        
        _cell1.totailePrice = [NSString stringWithFormat:@"%0.2f",[model.count integerValue]*[model.price floatValue]];
        
        return _cell1;

    }
    
}

#pragma mark UITableViewDelegate

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
    if (_tableView == tableView) {
        YSKJ_TabHeadView *headView= [[YSKJ_TabHeadView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 72)];
        if (self.planName.length == 0) {
            self.planName = @"未命名";
        }
        headView.planName = self.planName;
        return headView;
    }else{
        
        YSKJ_ListDetailHeaderView *view = [[YSKJ_ListDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 370)];
        view.name = self.planName;
        
        return view;
    }
    
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;
{
    if (_tableView == tableView) {
        return  nil;
    }else{
        
        YSKJ_ListDetailFooterView *view = [[YSKJ_ListDetailFooterView alloc] initWithFrame:CGRectMake(0, 0, _listTableView.frame.size.width, 345)];
    
        NSInteger allNum;
        
        allNum = 0;
        
        for (NSDictionary *dict in _listTempArray) {
            if ([[dict objectForKey:@"check"] integerValue] == 1) {
                NSInteger count = [[dict objectForKey:@"count"] integerValue];
                allNum += count;
            }
        }
        view.count = [NSString stringWithFormat:@"%ld",(long)allNum];
        
        listProTotailPrice = 0.0;
        
        for (NSDictionary *dicta in _listTempArray) {
            
            if ([[dicta objectForKey:@"check"] integerValue] == 1) {
                
                float totalPrice=[[dicta objectForKey:@"price"]  integerValue]*[[dicta objectForKey:@"count"] floatValue];
                listProTotailPrice=listProTotailPrice+totalPrice;
            }
        }
        view.price = listProTotailPrice;
        

        return view;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (_tableView == tableView) {
        return 130;
    }else{
        return 146;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    if (_tableView == tableView) {
        return 72;
    }else{
        return 370;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    if (_tableView == tableView) {
        return 0.001;
    }else{
        return   345;
    }
}

#pragma mark method

-(void)checkOneProAction:(UIButton *)sender
{

     NSInteger row = [self getRow:sender];
    
    if (sender.selected == YES) {
        
        sender.selected = NO;

        NSDictionary *dict = _tempArray[row];
        
        [dict setValue:@"0" forKey:@"check"];
        
    }else{
        sender.selected = YES;
        
        NSDictionary *dict = _tempArray[row];
        
        [dict setValue:@"1" forKey:@"check"];
    }
    
    BOOL checkAll = YES;
    
    for (NSDictionary *dcit in _tempArray) {
        if ([[dcit objectForKey:@"check"] integerValue] == 0) {
            checkAll = NO;
        }
    }
    
    if (checkAll == NO) {
        _checkAllBtn.selected = NO;
        [_checkAllBtn setImage:[UIImage imageNamed:@"Unchecked"] forState:UIControlStateNormal];
    }else{
        _checkAllBtn.selected = YES;
        [_checkAllBtn setImage:[UIImage imageNamed:@"check1"] forState:UIControlStateNormal];
    }
    
    [self getCateNumWithAllNum];
    
    [self getTotailePrice];
    
    [_tableView reloadData];
    
    [self listData];

}

-(void)editOneProAciton:(UIButton*)sender
{
     NSInteger row = [self getRow:sender];
    
    for (NSDictionary *dict1 in _tempArray) {

         [dict1 setValue:@"0" forKey:@"edit"];
    }
    
    NSDictionary *dict = _tempArray[row];
    
    [dict setValue:@"1" forKey:@"edit"];
    
    ProTotalPrice = 0.0;
    [_tableView reloadData];
    
}

-(void)sureOneProAciton:(UIButton*)sender
{
    NSInteger row = [self getRow:sender];
    
    NSDictionary *dict = _tempArray[row];
    
    [dict setValue:@"0" forKey:@"edit"];
    
    ProTotalPrice = 0.0;
    [_tableView reloadData];

}

-(void)lessenAciton:(UIButton*)sender
{
     NSInteger row = [self getRow:sender];
    
    NSDictionary *dict = _tempArray[row];
    
    [dict setValue:[NSString stringWithFormat:@"%d",[[dict objectForKey:@"count"] intValue]-1] forKey:@"count"];
    
    [self getCateNumWithAllNum];
    
    [self getTotailePrice];
    
    [_tableView reloadData];
    
    [self listData];
}

-(void)addProAciton:(UIButton*)sender
{
    NSInteger row = [self getRow:sender];
    
    NSDictionary *dict = _tempArray[row];
    
    [dict setValue:[NSString stringWithFormat:@"%d",[[dict objectForKey:@"count"] intValue]+1] forKey:@"count"];
    
    [self getCateNumWithAllNum];
    
    [self getTotailePrice];
    
    [_tableView reloadData];
    
    [self listData];
}

-(void)expList:(UIButton*)sender
{
    if (_listTempArray.count>0) {
        
        _listBtn.enabled = NO;
        
        _listImageBtn.enabled = NO;
        
        [YSKJ_CanvasLoading showNotificationViewWithText:@"正在导出..." loadType:loading];
        
        [YSKJ_ScreenShotClass screenShotView:_listTableView CGRect:_listTableView.bounds CGSize:_listTableView.bounds.size key:@"projectList" bucket:@"design" successBlock:^(NSString *key) {
            
            [YSKJ_CanvasLoading showNotificationViewWithText:nil loadType:done];
            
            [YSKJ_OrderPopWindow showPopViewWithTitle:key triangleX:32 CopyBlock:^(NSString *url) {
                
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                
                pasteboard.string = url;
                
            } openUrlBlock:^(NSString *url) {
                
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                
            }tagBlock:^() {
                
                _listBtn.enabled = YES;
                
                _listImageBtn.enabled = YES;
                
            }];
            
        } failBlock:^() {
            
            _listBtn.enabled = YES;
            
            _listImageBtn.enabled = YES;
            
            [YSKJ_CanvasLoading showNotificationViewWithText:nil loadType:done];
            
        }];
        
    }else{
        
        [YSKJ_CanvasLoading showNotificationViewWithText:@"至少选中一个单品" loadType:fail];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [YSKJ_CanvasLoading showNotificationViewWithText:nil loadType:done];
            
        });
        
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField;           // became first responder
{
    CGPoint point = textField.frame.origin;
    
    CGPoint realLocation;
    
    realLocation = [textField convertPoint:point toView:self.view];

    if (realLocation.y>365) {
        _showKeyBord = YES;
    }else{
        _showKeyBord = NO;
    }
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
{
    if ([textField.text isEqualToString:@"-"]) {
        textField.text = @"";
    }
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField;
{
    
    NSInteger row = [self getRow:textField];
    
    NSString *str = [NSString stringWithFormat:@"%ld",(long)textField.tag];
    
    NSString *sub = [str substringFromIndex:str.length-1];
    
    NSDictionary *dict = _tempArray[row];
    
    if ([sub integerValue] == 0) {
    
        [dict setValue:textField.text forKey:@"name"];
        
    }else if ([sub integerValue] == 1){
        
        [dict setValue:textField.text forKey:@"pinpai"];
        
    }else if ([sub integerValue] == 2){
        
        [dict setValue:textField.text forKey:@"pinlei"];
        
    }else if ([sub integerValue] == 3){
        
        [dict setValue:textField.text forKey:@"space"];
        
    }else if ([sub integerValue] == 4){
        
        [dict setValue:textField.text forKey:@"style"];
        
    }else if ([sub integerValue] == 5){
        
        [dict setValue:textField.text forKey:@"beizhu"];
        
    }else if ([sub integerValue] == 6){
        
        [dict setValue:textField.text forKey:@"price"];
        
        [self getTotailePrice];
    
    }
    [self listData];
    
    return YES;
}

-(NSInteger)getRow:(UIView*)view
{
    UITableViewCell *cell = (UITableViewCell*)view.superview;
    
    NSIndexPath *indexPath;
    
    if (![(UITableView*)cell.superview isKindOfClass:[UITableView class]]) {
        
        indexPath = [(UITableView*)cell.superview.superview indexPathForCell:cell];
        
    }else if([(UITableView*)cell.superview isKindOfClass:[UITableView class]]){
        
        indexPath = [(UITableView*)cell.superview indexPathForCell:cell];
        
    }
    return indexPath.row;
}

-(void)getTotailePrice
{
    ProTotalPrice = 0.0;
    
    for (NSDictionary *dicta in _tempArray) {
        
        if ([[dicta objectForKey:@"check"] integerValue] == 1) {
            
            float totalPrice=[[dicta objectForKey:@"price"]  integerValue]*[[dicta objectForKey:@"count"] floatValue];
            ProTotalPrice=ProTotalPrice+totalPrice;
        }
    }
    
    _totailePrice.text=[NSString stringWithFormat:@"¥%0.2f",ProTotalPrice];
}

-(void)getCateNumWithAllNum
{
    NSInteger cateNum,allNum;
    
    cateNum = 0;allNum = 0;
    
    for (NSDictionary *dict in _tempArray) {
        if ([[dict objectForKey:@"check"] integerValue] == 1) {
            cateNum++;
            NSInteger count = [[dict objectForKey:@"count"] integerValue];
            allNum += count;
        }
        
    }
    
    NSString  *textStr=[NSString stringWithFormat:@"已选%lu种商品，共%lu件",(unsigned long)cateNum,(unsigned long)allNum];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:textStr]; // 改变特定范围颜色大小要用的
    //种类的属性
    if (cateNum>=10) {
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(2,2)];
        [attributedString addAttribute:NSFontAttributeName
                                 value:[UIFont systemFontOfSize:24.0]
                                 range:NSMakeRange(2,2)];
    }else {
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(2,1)];
        [attributedString addAttribute:NSFontAttributeName
                                 value:[UIFont systemFontOfSize:24.0]
                                 range:NSMakeRange(2,1)];
    }
    
    if (allNum>=10) {
        //数量的属性
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(textStr.length-3,2)];
        [attributedString addAttribute:NSFontAttributeName
                                 value:[UIFont systemFontOfSize:24.0]
                                 range:NSMakeRange(textStr.length-3,2)];
    }else{
        //数量的属性
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(textStr.length-2,1)];
        [attributedString addAttribute:NSFontAttributeName
                                 value:[UIFont systemFontOfSize:24.0]
                                 range:NSMakeRange(textStr.length-2,1)];
    }
    _checkTitle.attributedText=attributedString;
}

@end
