//
//  YSKJ_SerReslutView.m
//  YSKJ_MATCH
//
//  Created by YSKJ on 17/11/3.
//  Copyright © 2017年 com.yskj. All rights reserved.
//

#import "YSKJ_SerReslutView.h"

#import "HttpRequestCalss.h"

#import <MJRefresh/MJRefresh.h>

#import "YSKJ_ProModel.h"

#import "YSKJ_DrawData.h"

#define UIColorFromHex(s)  [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1]

@implementation YSKJ_SerReslutView

-(id)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        
        self.backgroundColor = UIColorFromHex(0x354048);
        
        UILabel *tilte = [[UILabel alloc] initWithFrame:CGRectMake(24, 0, 80, 30)];
        tilte.text = @"搜索结果";
        tilte.textAlignment = NSTextAlignmentLeft;
        tilte.textColor = UIColorFromHex(0xb1c0c8);
        tilte.font = [UIFont systemFontOfSize:16];
        [self addSubview:tilte];
        
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        layout.itemSize = CGSizeMake((self.frame.size.width -16*4)/3, 187);
        
        _collect = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 30, self.frame.size.width, self.frame.size.height-30) collectionViewLayout:layout];
        _collect.delegate=self;
        _collect.dataSource=self;
        _collect.backgroundColor = UIColorFromHex(0x354048);
        [_collect registerClass:[YSKJ_SerResCollCell class] forCellWithReuseIdentifier:@"cellid"];
        [self addSubview:_collect];
        
        //下拉刷新
        _collect.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(mj_header)];
        
        _data  = [[NSMutableArray alloc] init];
        
        
        _none = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - 150)/2, self.frame.size.height - 225 - 180, 150, 166)];
        _none.image = [UIImage imageNamed:@"error"];
        _none.hidden = YES;
        [_collect addSubview:_none];
        
        _noneTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, _none.frame.origin.y + 166+40, self.frame.size.width, 20)];
        _noneTitle.hidden = YES;
        _noneTitle.font = [UIFont systemFontOfSize:14];
        _noneTitle.text = @"抱歉，没有找到符合的商品，请重试！";
        _noneTitle.textAlignment = NSTextAlignmentCenter;
        _noneTitle.textColor = UIColorFromHex(0xb1c0c8);
        [_collect addSubview:_noneTitle];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(favUpdate:) name:@"favUpdaeToList" object:nil];
        
    }
    return self;
}

-(void)favUpdate:(NSNotification*)notificationInfo
{
    for (NSDictionary *proInfo in _data) {
        if ([[proInfo objectForKey:@"id"] integerValue] == [[notificationInfo.userInfo objectForKey:@"id"] integerValue]) {
            [proInfo setValue:[notificationInfo.userInfo objectForKey:@"fav"] forKey:@"isFav"];
            [_collect reloadData];
        }
    }
}

#pragma mark UICollectionViewDataSource,UICollectionViewDelegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _data.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YSKJ_SerResCollCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
    
    cell.delegate = self;
    
    YSKJ_ProModel *model=[YSKJ_ProModel mj_objectWithKeyValues:_data[indexPath.row]];
    
    cell.url = model.thumb_file;
    
    cell.title = model.name;
    
    cell.money = model.price;
    
    cell.objDict = _data[indexPath.row];

    if (_data.count-indexPath.row<6) {
        if (ishttpagain==YES) {
            if (ishttpData==YES) {
                page++;
                [self httpData];
            }
            ishttpagain=NO;
        }
        
    }
    
    return cell;
    
}


//设置元素的的大小框
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets top = {0,16,10,16};
    return top;
}


static int page = 1;

-(void)mj_header
{
    page=1;
    
    [self httpData];
    
}

static bool ishttpData=NO;         //是否还继续预加载

static bool ishttpagain=NO;        //等上一页加载完再进行下一页

-(void)httpData
{
    NSMutableDictionary *temp = [[NSMutableDictionary alloc] initWithDictionary:_paramDict];
    
    [temp setValue:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    
     _paramDict = temp;

    HttpRequestCalss *httpRequest=[[HttpRequestCalss alloc] init];
    
    [httpRequest postHttpDataWithParam:self.paramDict url:SHOPLISTURL success:^(NSDictionary *dict, BOOL success) {
        
        NSMutableArray *lineArr=[dict objectForKey:@"data"];
        
        ishttpagain=YES;    //是否继续预加载
        
        if (lineArr.count<40) {
            
            ishttpData=NO;
            
        }else{
            
            ishttpData=YES;
        }
        
        if (page == 1) {
            [_data removeAllObjects];
            _data=lineArr;
        }else{
            [_data addObjectsFromArray:lineArr];
        }
        
        if (_data.count!= 0) {
            _none.hidden = YES;
            _noneTitle.hidden = YES;
        }else{
            _none.hidden = NO;
            _noneTitle.hidden = NO;
        }
        
        [_collect reloadData];
        
        [_collect.mj_header endRefreshing];
        
    } fail:^(NSError *error) {
        
    }];
}


-(void)setParamDict:(NSDictionary *)paramDict
{
    _paramDict = paramDict;

    page = 1;
    
    [self httpData];
}


#pragma mark YSKJ_SerResCollCellDelegate

-(void)getRow:(NSInteger)row;
{
    NSDictionary *obj = _data[row];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    //获取网络图片的Size
    [imageView sd_setImageWithPreviousCachedImageWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",[obj objectForKey:@"thumb_file"]]] placeholderImage:nil options:(SDWebImageRetryFailed) progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        if (image==nil) {
            return ;
        }
        [YSKJ_DrawData getDrawDataJsonDict:@{@"image":image,
                                             @"src":[obj objectForKey:@"thumb_file"],
                                             @"pid":[obj objectForKey:@"id"]
                                             }  objType:(product) WithBlock:^(YSKJ_drawModel *model) {
        
             NSDictionary *userInfo = @{
                                        @"model":model,
                                        };
             [[NSNotificationCenter defaultCenter] postNotificationName:@"addToCanvasNotification" object:nil userInfo:userInfo];
            
        }];
      
     
    }];
    
}


-(void)fav:(NSInteger)row boolFav:(BOOL)fav;
{

    if (fav == YES) {
        
        NSDictionary *obj = _data[row];
        
        [obj setValue:@"Y" forKey:@"isFav"];
        
    }else{
        NSDictionary *obj = _data[row];
        
        [obj setValue:@"NO" forKey:@"isFav"];
    }
    
}

-(void)setCollViewHei:(float)collViewHei
{
    _collViewHei = collViewHei;
    _collect.frame = CGRectMake(0, 30, self.frame.size.width, self.frame.size.height - 30);
}

-(void)setRemoveAllObj:(int)removeAllObj
{
    _none.hidden = YES;
    _noneTitle.hidden = YES;
    _removeAllObj =removeAllObj;
    [_data removeAllObjects];
    [_collect reloadData];
}


@end
