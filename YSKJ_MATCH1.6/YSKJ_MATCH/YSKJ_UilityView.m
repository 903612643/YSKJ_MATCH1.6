//
//  YSKJ_UilityView.m
//  YSKJ_MATCH
//
//  Created by YSKJ on 17/11/6.
//  Copyright © 2017年 com.yskj. All rights reserved.
//

#import "YSKJ_UilityView.h"

#import "YSKJ_UilityCollCell.h"

#import "YSKJ_spaListCollCell.h"

#import "HttpRequestCalss.h"

#define API_DOMAIN @"www.5164casa.com/api/assist"

#define SPACEBG @"http://"API_DOMAIN@"/solution/getbglist"

#define SPACEBGURL @"http://octjlpudx.qnssl.com/"      //空间背景绝对路径

#define UIColorFromHex(s)  [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1]

@implementation YSKJ_UilityView

-(id)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        
        UIView *uility = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        uility.backgroundColor = UIColorFromHex(0x354048);
        [self addSubview:uility];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(16, 20, 80, 22)];
        title.text = @"辅助效果";
        self.spaTitle = title;
        title.font = [UIFont systemFontOfSize:16];
        title.textColor = UIColorFromHex(0xb1c0c8);
        title.textAlignment = NSTextAlignmentLeft;
        [uility addSubview:title];
        
        UILabel *listTitle = [[UILabel alloc] initWithFrame:CGRectMake(54, 20, 80, 22)];
        listTitle.text = @"空间背景";
        self.listTitle = listTitle;
        listTitle.hidden = YES;
        listTitle.font = [UIFont systemFontOfSize:16];
        listTitle.textColor = UIColorFromHex(0xb1c0c8);
        listTitle.textAlignment = NSTextAlignmentLeft;
        [uility addSubview:listTitle];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 50, 22)];
        button.imageEdgeInsets = UIEdgeInsetsMake(3, 16, 3, 16);
        [button setImage:[UIImage imageNamed:@"backSpa"] forState:UIControlStateNormal];
        self.returnSpa = button;
        button.hidden = YES;
        [button addTarget:self action:@selector(returnAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake((uility.frame.size.width  - 64)/3, 150);
        UICollectionView *uilityColl = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 63, uility.frame.size.width, uility.frame.size.height - 63) collectionViewLayout:layout];
        self.uilityColl = uilityColl;
        uilityColl.dataSource = self;
        uilityColl.delegate = self;
        uilityColl.backgroundColor = UIColorFromHex(0x354048);
        
        [uilityColl registerClass:[YSKJ_UilityCollCell class] forCellWithReuseIdentifier:@"cellId"];
        [uilityColl registerClass:[YSKJ_spaListCollCell class] forCellWithReuseIdentifier:@"listCellId"];
        [uility addSubview:uilityColl];
        
        _dataSoure = [[NSMutableArray alloc] init];
        [_dataSoure addObject:@""];
        showList = NO;
 
    }
    
    return self;
}



#pragma mark UICollectionViewDataSource,UICollectionViewDelegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _dataSoure.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *_cell;
    
    if (showList == NO) {
        
        YSKJ_UilityCollCell *Cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
        _cell = Cell;
        
    }else{
        
        YSKJ_spaListCollCell *Cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"listCellId" forIndexPath:indexPath];
        Cell.url = [NSString stringWithFormat:@"%@",[_dataSoure[indexPath.row] objectForKey:@"url"]];
        
        _cell = Cell;
    }
    

    return _cell;
    
}

static  bool showList = NO;

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (showList == NO) {
        
        showList = YES;
        
        self.spaTitle.hidden = YES;
        self.listTitle.hidden = NO;
        self.returnSpa.hidden = NO;
        
        [_dataSoure removeAllObjects];

        [self httpGetSpacebgList];
        
    }else{
        
        NSLog(@"空间");
    }
    
    
}

//设置元素的的大小框
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets top = {0,16,10,16};
    return top;
}

-(void)returnAction
{
    showList = NO;
    [_dataSoure removeAllObjects];
    [_dataSoure addObject:@""];
    [self.uilityColl reloadData];
    
    self.spaTitle.hidden = NO;
    self.listTitle.hidden = YES;
    self.returnSpa.hidden = YES;
    
}

-(void)httpGetSpacebgList
{
    HttpRequestCalss *httpRequest=[[HttpRequestCalss alloc] init];
    NSDictionary *param=@{
                          
                          @"userid":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],
                          @"type":@"1",
                          @"style":@""
                          };
    [httpRequest postHttpDataWithParam:param url:SPACEBG success:^(NSDictionary *dict, BOOL success) {
        
        _dataSoure = [dict objectForKey:@"data"];
        
        [self.uilityColl reloadData];
        
        
    } fail:^(NSError *error) {
        
    }];
    
}


@end
