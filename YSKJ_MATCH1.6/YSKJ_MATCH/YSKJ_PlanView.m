//
//  YSKJ_PlanView.m
//  YSKJ_MATCH
//
//  Created by YSKJ on 17/11/6.
//  Copyright © 2017年 com.yskj. All rights reserved.
//

#import "YSKJ_PlanView.h"

#import "YSKJ_plancollcell.h"

#import "YSKJ_AlertView.h"

#import "HttpRequestCalss.h"

#import "YSKJ_PlanLIstModel.h"

#import <MJExtension/MJExtension.h>

#import "YSKJ_CanvasLoading.h"

#define API_DOMAIN @"www.5164casa.com/api/assist"                  //正式服务器

#define GETPLANLIST @"http://"API_DOMAIN@"/solution/getlist" //得到方案列表

#define DELPLAN @"http://"API_DOMAIN@"/solution/del" //删除方案

#define UPDATEPLAN @"http://"API_DOMAIN@"/solution/edit" //修改方案

#define UIColorFromHex(s)  [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1]

@implementation YSKJ_PlanView

-(id)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        
        UIView *list = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        list.backgroundColor = UIColorFromHex(0x354048);
        [self addSubview:list];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(16, 20, 80, 22)];
        title.text = @"我的方案";
        title.font = [UIFont systemFontOfSize:16];
        title.textColor = UIColorFromHex(0xb1c0c8);
        title.textAlignment = NSTextAlignmentLeft;
        [list addSubview:title];
        
        UIButton *addPlan = [[UIButton alloc] initWithFrame:CGRectMake(list.frame.size.width-70, 10, 44, 44)];
        [addPlan setImage:[UIImage imageNamed:@"addPlan"] forState:UIControlStateNormal];
        [addPlan addTarget:self action:@selector(addPlan) forControlEvents:UIControlEventTouchUpInside];
        addPlan.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        [list addSubview:addPlan];
        
        UIButton *editPlan = [[UIButton alloc] initWithFrame:CGRectMake(list.frame.size.width-120, 10, 44, 44)];
        [editPlan setTitle:@"编辑" forState:UIControlStateNormal];
        _editBtn = editPlan;
        [editPlan setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
        editPlan.titleLabel.font = [UIFont systemFontOfSize:16];
        [editPlan addTarget:self action:@selector(editPlan:) forControlEvents:UIControlEventTouchUpInside];
        editPlan.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        [list addSubview:editPlan];
        
        
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake((list.frame.size.width  - 48)/2, 190);
        UICollectionView *listColl = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 63, list.frame.size.width, list.frame.size.height - 63) collectionViewLayout:layout];
        self.listColl = listColl;
        listColl.dataSource = self;
        listColl.delegate = self;
        listColl.backgroundColor = UIColorFromHex(0x354048);
        [listColl registerClass:[YSKJ_plancollcell class] forCellWithReuseIdentifier:@"cellId"];
        [list addSubview:listColl];
        
        UIImageView *nonePlan = [[UIImageView alloc] initWithFrame:CGRectMake((list.frame.size.width - 290)/2, 160, 290, 200)];
        _nonePlan = nonePlan;
        nonePlan.hidden = YES;
        nonePlan.image = [UIImage imageNamed:@"nonePlan"];
        [listColl addSubview:nonePlan];
        
        UILabel *noneTitle =[[UILabel alloc] initWithFrame:CGRectMake(0, nonePlan.frame.origin.y + nonePlan.frame.size.height + 40, list.frame.size.width, 20)];
        noneTitle.text = @"抱歉，您还没有创建方案！";
        _noTitle = noneTitle;
        noneTitle.hidden = YES;
        noneTitle.textAlignment = NSTextAlignmentCenter;
        noneTitle.textColor = UIColorFromHex(0xb1c0c8);
        noneTitle.font = [UIFont systemFontOfSize:14];
        [listColl addSubview:noneTitle];
        
        _dataSource = [[NSMutableArray alloc] init];
     
    }
    
    return self;
}

-(void)addPlan
{
    [YSKJ_AlertView showAlertTitle:@"新建方案前请保存当前方案" content:@"新建新方案将清空当前画布"  cancleBlock:^{
        
    } finishBlock:^{
        
        if (self.delegate!=nil && [self.delegate respondsToSelector:@selector(addPlan)]) {
            [self.delegate addPlan];
        }
        
    }];
}

-(void)editAction:(UIButton *)sender
{
    [YSKJ_AlertView showAlertTitle:@"编辑方案前请保存当前方案" content:@"编辑新方案将清空当前画布"  cancleBlock:^{

    } finishBlock:^{
        
        UICollectionViewCell *cell =(UICollectionViewCell*)sender.superview;
        
        NSIndexPath *indexPath = [_listColl indexPathForCell:cell];
        
        NSDictionary *dict = _dataSource[indexPath.row];
        
        if (self.delegate!=nil && [self.delegate respondsToSelector:@selector(editPlan:)]) {
            [self.delegate editPlan:dict];
        }
        
    }];
}

-(void)delePlan:(UIButton *)sender
{
    [YSKJ_AlertView showAlertTitle:@"您确定删除方案" content:nil cancleBlock:^{
        
    } finishBlock:^{
        
        UICollectionViewCell *cell =(UICollectionViewCell*)sender.superview;
        NSIndexPath *indexPath = [_listColl indexPathForCell:cell];

        NSDictionary *dict = _dataSource[indexPath.row];
        
        HttpRequestCalss *requset=[[HttpRequestCalss alloc ] init];
        
        NSDictionary *param=
        @{
          @"userid":[[NSUserDefaults standardUserDefaults ]objectForKey:@"userId"],
          @"id":[dict objectForKey:@"id"]
          };
        
        [YSKJ_CanvasLoading showNotificationViewWithText:@"正在删除..." loadType:loading];
        
        [requset postHttpDataWithParam:param url:DELPLAN  success:^(NSDictionary *dict, BOOL success) {
            
            for (UIView *subView in [UIApplication sharedApplication].keyWindow.subviews) {
                if (subView.tag == 2017) {
                    [subView removeFromSuperview];
                }
            }
            
            if (self.delegate!=nil && [self.delegate respondsToSelector:@selector(deletePlan:)]) {
                [self.delegate deletePlan:_dataSource[indexPath.row]];
            }
            
            [_dataSource removeObjectAtIndex:indexPath.row];
            
            if (_dataSource.count==0) {
                _noTitle.hidden = NO;
                _nonePlan.hidden = NO;
            }else{
                _noTitle.hidden = YES;
                _nonePlan.hidden = YES;
            }
            
            [self.listColl reloadData];
            
           
        }fail:^(NSError *error) {
            
        }];

        
    }];
    
}

-(void)editPlan:(UIButton*)sender
{
    if (sender.selected == NO) {
        sender.selected = YES;
        [sender setTitleColor:UIColorFromHex(0x00ABF2)  forState:UIControlStateNormal];
        [sender setTitle:@"完成" forState:UIControlStateNormal];
        NSMutableArray *tempDataArr = [[NSMutableArray alloc] init];
        for (int i=0; i<_dataSource.count; i++) {
            NSDictionary *dict = _dataSource[i];
            NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] initWithDictionary:dict];
            [tempDict setObject:@1 forKey:@"edit"];
            [tempDataArr addObject:tempDict];
        }
        _dataSource = tempDataArr;
        [self.listColl reloadData];

    }else{
        sender.selected = NO;
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sender setTitle:@"编辑" forState:UIControlStateNormal];
        NSMutableArray *tempDataArr = [[NSMutableArray alloc] init];
        for (int i=0; i<_dataSource.count; i++) {
            NSDictionary *dict = _dataSource[i];
            NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] initWithDictionary:dict];
            [tempDict setObject:@0 forKey:@"edit"];
            [tempDataArr addObject:tempDict];
        }
        _dataSource = tempDataArr;
        [self.listColl reloadData];

    }
}

#pragma mark UICollectionViewDataSource,UICollectionViewDelegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _dataSource.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YSKJ_plancollcell *Cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    
    YSKJ_PlanLIstModel *model = [YSKJ_PlanLIstModel mj_objectWithKeyValues:_dataSource[indexPath.row]];
    
    [Cell.delBtn addTarget:self action:@selector(delePlan:) forControlEvents:UIControlEventTouchUpInside];
    
    [Cell.editBtn addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    
    Cell.name =model.name;
    
    Cell.dateStr = model.last_time;
    
    Cell.dataInfo = model.data_info;
    
    Cell.edit = model.edit;
    
    return Cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    

}

//设置元素的的大小框
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets top = {0,16,10,16};
    return top;
}

-(void)setUpdata:(NSString *)updata
{
    _updata = updata;
    
    [self httpGetPlanListData];
}

-(void)httpGetPlanListData
{
    [_dataSource removeAllObjects];
    
    HttpRequestCalss *requset=[[HttpRequestCalss alloc ] init];
    
    NSDictionary *param=
    @{@"userid":[[NSUserDefaults standardUserDefaults ]objectForKey:@"userId"]};
    
    [requset postHttpDataWithParam:param url:GETPLANLIST  success:^(NSDictionary *dict, BOOL success) {
        
        if ([[dict objectForKey:@"total"] integerValue]!=0) {
        
            _dataSource = [[NSMutableArray alloc] initWithArray:[dict objectForKey:@"data"]];
            
            NSMutableArray *tempDataArr = [[NSMutableArray alloc] init];
            for (int i=0; i<_dataSource.count; i++) {
                NSDictionary *dict = _dataSource[i];
                NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] initWithDictionary:dict];
                if (_editBtn.selected == NO) {
                    [_editBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
                    [tempDict setObject:@0 forKey:@"edit"];
                }else{
                    [_editBtn setTitleColor:UIColorFromHex(0x00ABF2) forState:UIControlStateNormal];
                    [_editBtn setTitle:@"完成" forState:UIControlStateNormal];
                    [tempDict setObject:@1 forKey:@"edit"];
                }

                [tempDataArr addObject:tempDict];
            }
            _dataSource = tempDataArr;

            if (_dataSource.count==0) {
                _noTitle.hidden = NO;
                _nonePlan.hidden = NO;
            }else{
                _noTitle.hidden = YES;
                _nonePlan.hidden = YES;
            }
        }else{
            _noTitle.hidden = NO;
            _nonePlan.hidden = NO;
        }

        [_listColl  reloadData];
        
    }fail:^(NSError *error) {
        
 
    }];
    
}


@end
