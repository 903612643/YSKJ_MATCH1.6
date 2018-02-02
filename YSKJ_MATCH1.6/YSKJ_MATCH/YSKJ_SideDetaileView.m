//
//  YSKJ_SideDetaileView.m
//  YSKJ_MATCH
//
//  Created by YSKJ on 17/10/31.
//  Copyright © 2017年 com.yskj. All rights reserved.
//

#import "YSKJ_SideDetaileView.h"
#import "HttpRequestCalss.h"
#import <SDAutoLayout/SDAutoLayout.h>

#define API_DOMAIN @"www.5164casa.com/api/assist"                  //正式服务器
#define  GETTYPE @"http://"API_DOMAIN@"/store/gettype"     //分类数据

#define TABHEI1 116

#define TABHEI2 74

#define UIColorFromHex(s)  [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1]

@implementation YSKJ_SideDetaileView

- (NSArray *)titles
{
    if (!_titles) {
        _titles = [NSMutableArray arrayWithArray:@[]];
    }
    return _titles;
}

-(id)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
       
        UIView *detail = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        detail.backgroundColor = UIColorFromHex(0x354048);
        [self addSubview:detail];
        
        UIButton *selfRet = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 49, 44)];
        self.selfReturn = selfRet;
        [selfRet addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [selfRet setImage:[UIImage imageNamed:@"Back"] forState:UIControlStateNormal];
        selfRet.hidden = YES;
        [self addSubview:selfRet];
        
        YSKJ_SerLbLayout* layout = [[YSKJ_SerLbLayout alloc] init];
        layout.panding = 16;
        layout.rowPanding = 10;
        layout.delegate = self;
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(60, TABHEI1, self.frame.size.width - 60, self.frame.size.height - TABHEI1) collectionViewLayout:layout];
        self.serLabCollectionView = collectionView;
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.backgroundColor = UIColorFromHex(0x354048);
        [collectionView registerClass:[YSKJ_SerLabCollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
        [self addSubview:collectionView];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, TABHEI1, self.frame.size.width, self.frame.size.height-TABHEI1)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = UIColorFromHex(0x354048);
        [self addSubview:_tableView];
        
        _dataSoure = [[NSMutableArray alloc] init];
        cateId = @"1";
        [self getLableHttpData];
        
        [_tableView registerClass:[YSKJ_DetailTbCell class] forCellReuseIdentifier:@"cellId"];
        [_tableView registerClass:[YSKJ_CateoryTbCell class] forCellReuseIdentifier:@"cellId1"];
        
        UITextField *serch = [[UITextField alloc] init];
        self.serchTextf = serch;
        serch.placeholder = @"输入搜索";
        serch.delegate = self;
        serch.clearButtonMode = UITextFieldViewModeWhileEditing;
        serch.font = [UIFont systemFontOfSize:14];
        serch.borderStyle = UITextBorderStyleRoundedRect;
        [self addSubview:serch];
        serch.sd_layout
        .leftSpaceToView(self,16)
        .widthIs(_tableView.frame.size.width - 106)
        .heightIs(44)
        .topSpaceToView(self,20);
        UIButton *serImage = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        serImage.imageEdgeInsets = UIEdgeInsetsMake(5, 8, 5, 2);
        serch.leftView = serImage;
        [serImage setImage:[UIImage imageNamed:@"searchImg"] forState:UIControlStateNormal];
        serch.leftViewMode = UITextFieldViewModeAlways;
        
        UIButton *serBut = [[UIButton alloc] initWithFrame:CGRectMake(_tableView.frame.size.width - 58 - 16, 20, 58, 44)];
        serBut.backgroundColor = UIColorFromHex(0x00abf2);
        serBut.layer.cornerRadius = 5;
        serBut.layer.masksToBounds = YES;
        serBut.titleLabel.font = [UIFont systemFontOfSize:17];
        [serBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [serBut addTarget:self action:@selector(sureSerch) forControlEvents:UIControlEventTouchUpInside];
        [serBut setTitle:@"搜索" forState:UIControlStateNormal];
        [self addSubview:serBut];
        
        self.paramModel = [[YSKJ_ParamModel alloc] init];
        [self initHttpParam];
        self.serResultView = [[YSKJ_SerReslutView alloc] initWithFrame:CGRectMake(0, 126, _tableView.frame.size.width, self.frame.size.height - 126)];
        self.serResultView.hidden = YES;
        self.serResultView.delegate = self;
        [self addSubview:self.serResultView];
        
        _seg = [[YSKJ_SegView alloc] initWithFrame:CGRectMake(0, 74, _tableView.frame.size.width, 42)];
        [self addSubview:_seg];
        
        __weak typeof(self) weakSelf = self;
        _seg.selectBlock = ^(NSInteger selectIndex)
        {
            weakSelf.serResultView.hidden = YES;
            
            weakSelf.serchTextf.text = @"";
            
            if (selectIndex == 0) {
                cateId = @"1";
                [weakSelf getLableHttpData];
            }else if (selectIndex == 1){
                cateId = @"2";
                [weakSelf getLableHttpData];
            }else{
                cateId = @"3";
                [weakSelf getLableHttpData];
            }
            
            weakSelf.titleLab.hidden = YES;
            weakSelf.titleLab.frame = CGRectMake(16, 126, 62, 44);
            
            [weakSelf.styleArr removeAllObjects];
            [weakSelf.spaceArr removeAllObjects];
            [weakSelf.categoryArr removeAllObjects];
            [weakSelf.sourceArr removeAllObjects];
            
            [weakSelf.floatArr removeAllObjects];
            
            [weakSelf.titles removeAllObjects];
            [weakSelf.serLabCollectionView reloadData];
            
            if (self.titles.count == 0) {
                [UIView animateWithDuration:0.5 animations:^{
                    weakSelf.tableView.frame = CGRectMake(0, TABHEI1 , weakSelf.tableView.frame.size.width, self.frame.size.height -TABHEI1);
                    weakSelf.serLabCollectionView.frame = CGRectMake(60, TABHEI1 , weakSelf.tableView.frame.size.width-60, self.frame.size.height -TABHEI1 );
                }];
            }
            
        };
        
    

        _floatArr = [[NSMutableArray alloc] init];
        _styleArr = [[NSMutableArray alloc] init];
        _spaceArr = [[NSMutableArray alloc] init];
        _categoryArr =[[NSMutableArray alloc] init];
        _sourceArr = [[NSMutableArray alloc] init];
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(16, 120, 60, 44)];
        titleLab.text = @"筛选：";
        titleLab.hidden = YES;
        _titleLab = titleLab;
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.textColor = UIColorFromHex(0x00abf2);
        titleLab.font = [UIFont systemFontOfSize:16];
        [self addSubview:titleLab];
        

    }
    
    
    return self;
}

-(void)initHttpParam
{
    //默认
    self.paramModel.page = @"1";
    self.paramModel.order = @"view_amount";
    self.paramModel.ordername = @"desc";
    self.paramModel.keyword = @"";
    self.paramModel.style = @"";
    self.paramModel.space = @"";
    self.paramModel.category = @"";
    self.paramModel.source = @"";
    self.paramModel.pagenum = @"";
    
}

static NSString *cateId = @"1";

-(void)getLableHttpData
{
    NSDictionary *dict=@{@"cateid":cateId};
    
    HttpRequestCalss *httpRequest = [[HttpRequestCalss alloc] init];

    [httpRequest postHttpDataWithParam:dict url:GETTYPE success:^(NSDictionary *dict, BOOL success) {
        
        [_dataSoure removeAllObjects];
        
        if ([[dict objectForKey:@"data"] objectForKey:@"category"]) {
            [_dataSoure addObject:[[dict objectForKey:@"data"] objectForKey:@"category"]];
        }
        if ([[dict objectForKey:@"data"] objectForKey:@"style"]) {
           [_dataSoure addObject:[[dict objectForKey:@"data"] objectForKey:@"style"]];
        }
        if ([[dict objectForKey:@"data"] objectForKey:@"space"]) {
            [_dataSoure addObject:[[dict objectForKey:@"data"] objectForKey:@"space"]];
        }
        if ([[dict objectForKey:@"data"] objectForKey:@"source"]) {
            NSDictionary *brand = @{@"name":@"品牌",@"data":[[[dict objectForKey:@"data"] objectForKey:@"source"] objectForKey:@"data"]};
            [_dataSoure addObject:brand];
        }
        
        [_tableView reloadData];
        
        if (_dataSoure.count!=0) {
            [_tableView setContentOffset:CGPointMake(0,0) animated:YES];
        }
        
    } fail:^(NSError *error) {
        
    }];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return _dataSoure.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (self.selfReturn.hidden == YES) {
        
        if (indexPath.section == 0) {
            
            if ([cateId integerValue] == 3) {
                
                return [self indexPath:indexPath];
                
            }else{
                
                _CateoryTbCell = [tableView dequeueReusableCellWithIdentifier:@"cellId1"];
                _CateoryTbCell.delegate = self;
                tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                _CateoryTbCell.width = _tableView.frame.size.width;
                _CateoryTbCell.data = [_dataSoure[indexPath.section] objectForKey:@"data"];
                
                return _CateoryTbCell;
            }
            
        }else{
            
            return [self indexPath:indexPath];
        }

    }else{
        
        return [self indexPath:indexPath];
    }
    
}
-(UITableViewCell*)indexPath:(NSIndexPath*)indexPath
{
    YSKJ_DetailTbCell *_cell = [_tableView dequeueReusableCellWithIdentifier:@"cellId"];
    _detailTbCell = _cell;
    _cell.delegate = self;
    NSDictionary *dict = _dataSoure[indexPath.section];
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    NSArray *dataArr = [dict objectForKey:@"data"];
    for (NSDictionary *dict in dataArr) {
        [temp addObject:[dict objectForKey:@"display_name"]];
    }
    _cell.titles = temp;
    _cell.width = _tableView.frame.size.width-30;
    _cell.backgroundColor = UIColorFromHex(0x354048);
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    return _cell;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 18, 120, 22)];
    view.backgroundColor = UIColorFromHex(0x354048);
    titleLab.textColor = UIColorFromHex(0xb1c0c8);
    titleLab.font = [UIFont systemFontOfSize:16];
    titleLab.text = [_dataSoure[section] objectForKey:@"name"];
    [view addSubview:titleLab];
    return view;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.section == 2 ) {
        if (self.selfReturn.hidden == NO) {
            _detailTbCell.heigth = 100;
            return _detailTbCell.heigth;
        }else{
            _detailTbCell.heigth = 65;
            return _detailTbCell.heigth ;
        }
        
    }else if (indexPath.section ==0){
        
        if (self.selfReturn.hidden == YES) {
            
            if ([cateId integerValue]!=3) {
                
                _CateoryTbCell.data = [_dataSoure[indexPath.section] objectForKey:@"data"];
                if (_CateoryTbCell.data.count%3!=0) {
                    _CateoryTbCell.heigth = _CateoryTbCell.data.count/3*100+100+50;
                }else{
                    _CateoryTbCell.heigth = _CateoryTbCell.data.count/3*100+50;
                }
                return _CateoryTbCell.heigth;
                
            }else{
                return 110;
            }
        }else{
            return 200;
        }
        
    }else{
        if ([cateId integerValue] == 2) {
            if (indexPath.section == 1) {
                _detailTbCell.heigth = 65;
                return _detailTbCell.heigth;
            }else{
                _detailTbCell.heigth = 110;
                return _detailTbCell.heigth;
            }
        }else{
            _detailTbCell.heigth = 110;
            return _detailTbCell.heigth;
        }
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 40;
}

#pragma mark  UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark YSKJ_SerLayoutDelegate

-(NSArray*)serchLabelLayoutTitlesForLabel{

    return self.titles;
}

#pragma mark UICollectionViewDataSource,UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.titles.count;
}

static float _originY = 0.0;

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YSKJ_SerLabCollectionViewCell *_cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    
    _cell.layer.cornerRadius = 5;
    _cell.layer.masksToBounds = YES;
    
    [_cell setTitle:[NSString stringWithFormat:@"   %@",self.titles[indexPath.item]]];
    
    [_cell.deleteItem addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _originY = _cell.frame.origin.y;
    
    [_floatArr addObject:[NSString stringWithFormat:@"%f",_originY]];
    
    NSNumber *maxY = [_floatArr valueForKeyPath:@"@max.floatValue"];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        if (self.selfReturn.hidden == YES) {
            
            _tableView.frame = CGRectMake(0, TABHEI1 + [maxY floatValue] + 54, _tableView.frame.size.width, self.frame.size.height -( _originY + 54 + TABHEI1));
        }else{
            _tableView.frame = CGRectMake(0, TABHEI2  + [maxY floatValue] + 54, _tableView.frame.size.width, self.frame.size.height -(TABHEI2 + _originY + 54));
        }
        
        _serResultView.frame = CGRectMake(0, _tableView.frame.origin.y, _tableView.frame.size.width, _tableView.frame.size.height);
        
        _serResultView.collViewHei = self.frame.size.height - _tableView.frame.origin.y;
        
        _loadListView.frame = CGRectMake((self.frame.size.width - 95)/2, _serResultView.frame.origin.y + 30, 95, 30);
        
    }];
    
    _cell.deleWidth = 26;
    
    if (([self.titles containsObject:@"家具中心"] && ([self.titles containsObject:@"饰品中心"]||[self.titles containsObject:@"生活物件"]))|| ([self.titles containsObject:@"饰品中心"] && [self.titles containsObject:@"生活物件"]))
    {
        [_dataSoure removeAllObjects];
        [_tableView reloadData];
    }
    
    
    return _cell;
}


-(void)deleteAction:(UIButton*)sender
{
    UICollectionViewCell *cell1 = (UICollectionViewCell*)sender.superview;
    NSIndexPath *indexPath = [self.serLabCollectionView indexPathForCell:cell1];
    
    if ([_styleArr containsObject:self.titles[indexPath.item]]) {
        [_styleArr removeObject:self.titles[indexPath.item]];
    }
    if ([_spaceArr containsObject:self.titles[indexPath.item]]) {
        [_spaceArr removeObject:self.titles[indexPath.item]];
    }
    if ([_categoryArr containsObject:self.titles[indexPath.item]]) {
        [_categoryArr removeObject:self.titles[indexPath.item]];
    }
    if ([_sourceArr containsObject:self.titles[indexPath.item]]) {
        [_sourceArr removeObject:self.titles[indexPath.item]];
    }
    
    [_floatArr removeAllObjects];
    
    if ([self.titles containsObject:self.titles[indexPath.item]]) {
        [self.titles removeObjectAtIndex:indexPath.item];
    }
    [_serLabCollectionView reloadData];

    if (self.titles.count == 0) {
        [UIView animateWithDuration:0.5 animations:^{
            if (self.selfReturn.hidden == YES) {
                _tableView.frame = CGRectMake(0, TABHEI1 , _tableView.frame.size.width, self.frame.size.height -TABHEI1);
                self.serLabCollectionView.frame = CGRectMake(60, TABHEI1 , _tableView.frame.size.width-60, self.frame.size.height -TABHEI1 );
            }else{
                _tableView.frame = CGRectMake(0, TABHEI2 , _tableView.frame.size.width, self.frame.size.height - TABHEI2 );
                self.serLabCollectionView.frame = CGRectMake(60, TABHEI2 , _tableView.frame.size.width-60, self.frame.size.height - TABHEI2 );
            }
            _serResultView.frame = CGRectMake(0, _tableView.frame.origin.y, _tableView.frame.size.width, self.frame.size.height -TABHEI1);
             _serResultView.collViewHei = self.frame.size.height -( _originY + 54 + TABHEI1);
        }];
        
        _titleLab.hidden = YES;
    }else{
        _titleLab.hidden = NO;
    }
    
}

#pragma mark  DetailTbDelegate

-(void)getItem:(NSString*)item section:(NSInteger)section;
{
    if (![self.titles containsObject:item]) {
      
        if (self.selfReturn.hidden == NO) {
            
            [_categoryArr addObject:item];
        }else{
            if ([[_dataSoure[section] objectForKey:@"name"] isEqualToString:@"风格"]) {
                [_styleArr addObject:item];
                
            }else if ([[_dataSoure[section] objectForKey:@"name"] isEqualToString:@"空间"]){
                [_spaceArr addObject:item];
                
            }else if ([[_dataSoure[section] objectForKey:@"name"] isEqualToString:@"品牌"]){
                [_sourceArr addObject:item];
            }
        }
        
        [self.titles addObject:item];
        [self.serLabCollectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:self.titles.count - 1 inSection:0]]];
        
    }
    
    if (self.titles.count!=0) {
        _titleLab.hidden = NO;
    }else{
        _titleLab.hidden = YES;
    }
    if (self.selfReturn.hidden == YES) {
        _titleLab.frame = CGRectMake(16, 126, 62, 44);
    }else{
        _titleLab.frame = CGRectMake(16, 84, 62, 44);
    }
    
}


#pragma mark YSKJ_CateoryTbCellDelegate

-(void)getCateoryDict:(NSDictionary*)dict;
{
    self.selfReturn.hidden = NO;
    _seg.hidden = YES;
    _tableView.frame = CGRectMake(0, TABHEI2 , _tableView.frame.size.width, self.frame.size.height -74 );
    self.serLabCollectionView.frame = CGRectMake(60, TABHEI2 , _tableView.frame.size.width-60, self.frame.size.height - TABHEI2 );
    [_serLabCollectionView reloadData];
    [UIView animateWithDuration:0.3 animations:^{
        self.serchTextf.sd_layout
        .leftSpaceToView(self,50)
        .widthIs(_tableView.frame.size.width-140);
        [self.serchTextf updateLayout];
    }];
    [_dataSoure removeAllObjects];
    [_dataSoure addObject:@{
                           @"name":[dict objectForKey:@"display_name"],
                           @"data":[dict objectForKey:@"data"]
                           }];
    [_tableView reloadData];
    
    if (self.titles.count!=0) {
        _titleLab.hidden = NO;
        _titleLab.frame = CGRectMake(16, 84, 62, 44);
    }
    
    
}

-(void)backAction
{
    _seg.hidden = NO;
    self.selfReturn.hidden = YES;
    _tableView.frame = CGRectMake(0, TABHEI1, _tableView.frame.size.width, self.frame.size.height -TABHEI1);
    self.serLabCollectionView.frame = CGRectMake(60, TABHEI1 , _tableView.frame.size.width-60, self.frame.size.height - TABHEI1 );
    [_serLabCollectionView reloadData];
    [UIView animateWithDuration:0.3 animations:^{
        self.serchTextf.sd_layout
        .leftSpaceToView(self,16)
        .widthIs(_tableView.frame.size.width-106);
        [self.serchTextf updateLayout];
    }];
    
    [self getLableHttpData];
    
    if (self.titles.count!=0) {
        _titleLab.hidden = NO;
        _titleLab.frame = CGRectMake(16, 126, 62, 44);
    }else{
        _titleLab.hidden = YES;
    }
    
}

#pragma mark 得到商品列表

-(void)sureSerch
{
    UIView *view = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - 95)/2, _tableView.frame.origin.y + 30, 95, 30)];
    _loadListView = view;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:view.bounds];
    NSURL *localUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"loadlist" ofType:@"gif"]];
    imageView= [AnimatedGif getAnimationForGifAtUrl:localUrl];
    [view addSubview:imageView];
    [self addSubview:view];
    
    [self backAction];
    
    [self.serchTextf resignFirstResponder];
    
    self.serResultView.hidden = NO;
    
    _serResultView.frame = CGRectMake(0, _tableView.frame.origin.y, _tableView.frame.size.width, _tableView.frame.size.height);
    
    _serResultView.collViewHei = self.frame.size.height -_tableView.frame.origin.y;
    
    self.serResultView.removeAllObj = 1;
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [view removeFromSuperview];
        
        NSString *styleStr = [_styleArr componentsJoinedByString:@","];
        NSString *spaceStr = [_spaceArr componentsJoinedByString:@","];
        NSString *catoryStr = [_categoryArr componentsJoinedByString:@","];
        NSString *soureStr = [_sourceArr componentsJoinedByString:@","];
        
        NSDictionary *paramdict=@{
                                  @"cateid":cateId,
                                  @"page":self.paramModel.page,
                                  @"order":self.paramModel.order,
                                  @"ordername":self.paramModel.ordername,
                                  @"keyword":_serchTextf.text,
                                  @"style":styleStr,
                                  @"space":spaceStr,
                                  @"category":catoryStr,
                                  @"source":soureStr,
                                  @"pagenum":@"40",
                                  @"userid":[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]
                                  };
        
        self.serResultView.paramDict = paramdict;
        
    });
    
}



@end
