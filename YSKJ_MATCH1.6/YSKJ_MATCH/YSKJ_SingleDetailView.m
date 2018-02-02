//
//  YSKJ_SingleDetailView.m
//  YSKJ_MATCH
//
//  Created by YSKJ on 17/11/9.
//  Copyright © 2017年 com.yskj. All rights reserved.
//

#import "YSKJ_SingleDetailView.h"

#import "YSKJ_SingleCollCell.h"

#import "YSKJ_SampleCollCell.h"

#import "ToolClass.h"

#import "YSKJ_drawModel.h"

#import <MJExtension/MJExtension.h>

#import "HttpRequestCalss.h"
#import <SDWebImage/UIButton+WebCache.h>
#import <SDWebImage/UIImageView+WebCache.h>

#define UIColorFromHex(s)  [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1]

#define API_DOMAIN @"www.5164casa.com/api/assist"                  //正式服务器

#define DETAIL @"http://"API_DOMAIN@"/store/detail"  //商品详情

#define PICURL @"http://odso4rdyy.qnssl.com"                    //图片固定地址

#import "YSKJ_DrawData.h"

@implementation YSKJ_SingleDetailView

-(id)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        
        UIView *sigleList = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        sigleList.backgroundColor = UIColorFromHex(0x354048);
        [self addSubview:sigleList];
        
        UITableView *detaileTab = [[UITableView alloc] initWithFrame:sigleList.bounds];
        detaileTab.backgroundColor = UIColorFromHex(0x354048);
        _tableView = detaileTab;
        detaileTab.delegate = self;
        detaileTab.dataSource = self;
        detaileTab.separatorStyle = UITableViewCellSeparatorStyleNone;
        [sigleList addSubview:detaileTab];
        _dataSource = [[NSMutableArray alloc] init];
        collcellHei = (self.frame.size.width -16*5)/4;
        
        UIView *view = [[UIView alloc] initWithFrame:sigleList.frame];
        view.backgroundColor = UIColorFromHex(0x354048);
        view.hidden = YES;
        
        _noneView = view;
        [sigleList addSubview:view];
        UIImageView *none = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width-200)/2, 235, 200, 200)];
        none.image = [UIImage imageNamed:@"noMessage"];
        [view addSubview:none];
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 235+200+40, self.frame.size.width, 20)];
        _tipLab = title;
        title.font = [UIFont systemFontOfSize:14];
        title.text = @"没有相关信息，请先点击右侧画布中的单品！";
        title.textAlignment = NSTextAlignmentCenter;
        title.textColor = UIColorFromHex(0xb1c0c8);
        [view addSubview:title];
        
        _selectIndex = 0;
        
        _showTag = NO;
        
        
        _hositroyArr = [[NSMutableArray alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(favUpdate) name:@"favUpdaeNotification" object:nil];
        
    }
    return self;
}

-(void)favUpdate
{
    if (_model.pid!=nil) {
        [self getProDuctDetail:_model.pid];
    }
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *cellId;
    
    UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:cellId];
    
    if (cellId==nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = UIColorFromHex(0x354048);
        
        if (indexPath.section==0) {
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(16, 10, self.frame.size.width-32, 343)];
            view.layer.cornerRadius = 4;
            view.layer.masksToBounds = YES;
            view.backgroundColor = [UIColor whiteColor];
            [cell addSubview:view];
            
            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(161, 10, 283, 283)];
            bgView.backgroundColor = UIColorFromHex(0xf2f2f2);
            bgView.layer.cornerRadius = 4;
            bgView.layer.masksToBounds = YES;
            [view addSubview:bgView];
            
            UIButton *proBut = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 283-40, 283-40)];
            _proBut = proBut;
            [bgView addSubview:proBut];
            UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
            [proBut addGestureRecognizer:pan];
            
            UIButton *addToCanvasBut = [[UIButton alloc] initWithFrame:CGRectMake(235, 12, 36, 36)];
            addToCanvasBut.backgroundColor = [UIColor whiteColor];
            addToCanvasBut.layer.cornerRadius = 5;
            addToCanvasBut.layer.masksToBounds = YES;
            [addToCanvasBut setImage:[UIImage imageNamed:@"AddTo"] forState:UIControlStateNormal];
            [addToCanvasBut addTarget:self action:@selector(addToCanvas:) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:addToCanvasBut];
            
            UIButton *favBut = [[UIButton alloc] initWithFrame:CGRectMake(12, 12, 36, 36)];
            favBut.backgroundColor = [UIColor whiteColor];
            favBut.layer.cornerRadius = 5;
            favBut.layer.masksToBounds = YES;
            [favBut addTarget:self action:@selector(favAction:) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:favBut];
            if ([[_proInfoDict objectForKey:@"isFav"] isEqualToString:@"Y"]) {
                [favBut setImage:[UIImage imageNamed:@"isFav1"] forState:UIControlStateNormal];
                favBut.selected = YES;
                
            }else{
                [ favBut  setImage:[UIImage imageNamed:@"isFav"] forState:UIControlStateNormal];
                favBut.selected = NO;
            }
            
            
            UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
            layout.scrollDirection = UICollectionViewScrollDirectionVertical;
            
            layout.itemSize = CGSizeMake(collcellHei, collcellHei);
    
            NSArray *_data = [_dataSource[indexPath.section] objectForKey:@"data"];
            NSInteger count;
            if (_data.count%4!=0) {
                count = _data.count/4+1;
            }else{
                count = _data.count/4;
            }
            
            UICollectionViewFlowLayout *lay = [[UICollectionViewFlowLayout alloc]init];
            lay.scrollDirection = UICollectionViewScrollDirectionVertical;
            lay.itemSize = CGSizeMake(63, 63);
            UICollectionView *sampleCollView = [[UICollectionView alloc]initWithFrame:CGRectMake(50, 0, 63, view.frame.size.height) collectionViewLayout:lay];
            self.sampleCellView = sampleCollView;
            sampleCollView.delegate=self;
            sampleCollView.dataSource=self;
            sampleCollView.backgroundColor = [UIColor whiteColor];
            [sampleCollView registerClass:[YSKJ_SampleCollCell class] forCellWithReuseIdentifier:@"sampleCellId"];
            [view addSubview:sampleCollView];
            
            if (_sampleData.count==0) {
                bgView.frame = CGRectMake((view.frame.size.width - 283)/2, 10, 283, 283);
                sampleCollView.hidden = YES;
            }else{
                bgView.frame = CGRectMake(161, 10, 283, 283);
                sampleCollView.hidden = NO;
            }
            
            UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(55, 353-48, 355, 48)];
            _name = name;
            name.textColor = UIColorFromHex(0x333333);
            name.font = [UIFont systemFontOfSize:16];
            [cell addSubview:name];
            
            UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(355, 353-48, view.frame.size.width-355, 48)];
            _price = price;
            price.textColor = UIColorFromHex(0x00abf2);
            price.font = [UIFont systemFontOfSize:14];
            [cell addSubview:price];
            
            
        }else{
            
            UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
            layout.scrollDirection = UICollectionViewScrollDirectionVertical;
            
            layout.itemSize = CGSizeMake(collcellHei, collcellHei);
            
            NSArray *_data = [_dataSource[indexPath.section] objectForKey:@"data"];
            NSInteger count;
            if (_data.count/4!=0) {
                count = _data.count/4+1;
            }else{
                count = _data.count/4;
            }
            if (_data.count>1) {
                _singleCellView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, collcellHei*count + (count+1)*10) collectionViewLayout:layout];
            }else{
                _singleCellView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, collcellHei+10) collectionViewLayout:layout];
            }
            
            _singleCellView.delegate=self;
            _singleCellView.dataSource=self;
            _singleCellView.backgroundColor = UIColorFromHex(0x354048);
            [_singleCellView registerClass:[YSKJ_SingleCollCell class] forCellWithReuseIdentifier:@"cellid"];
            [cell addSubview:_singleCellView];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width-150)/2, 0, 150, 150)];
            imageView.hidden = YES;
            _noSameImageView = imageView;
            imageView.image = [UIImage imageNamed:@"noMessage"];
            [cell addSubview:imageView];
            
            UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 190, self.frame.size.width, 20)];
            title.hidden = YES;
            _noSameTitleLab = title;
            title.font = [UIFont systemFontOfSize:14];
            title.text = @"该商品无相似单品！";
            title.textAlignment = NSTextAlignmentCenter;
            title.textColor = UIColorFromHex(0xb1c0c8);
            [cell addSubview:title];
            
            if (_data.count==0) {
                _noSameImageView.hidden = NO;
                _noSameTitleLab.hidden = NO;
            }else{
                _noSameTitleLab.hidden = YES;
                _noSameImageView.hidden = YES;
            }
            

        }
    }
    if (indexPath.section==0) {
        
        NSURL *url;
        
        NSDictionary *dict = [_dataSource[indexPath.row] objectForKey:@"dict"];
        
        _name.text = [dict objectForKey:@"name"];
        
        _price.text = [NSString stringWithFormat:@"¥%@",[dict objectForKey:@"price"]];
        
        if (_sampleData.count!=0) {
            
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",PICURL,[NSString stringWithFormat:@"%@",_sampleData[_selectIndex]]]];
        }else{
            url = [NSURL URLWithString:[_proInfoDict objectForKey:@"thumb_file"]];
        }
        
        [_proBut sd_setImageWithURL:url forState:UIControlStateNormal placeholderImage:nil];
        
        //获取网络图片的Size
        [self.proBut.imageView sd_setImageWithPreviousCachedImageWithURL:url placeholderImage:[UIImage imageNamed:@"loading1"] options:(SDWebImageRetryFailed) progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
        } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            
            float imageW=283-40;
            float scaleW;
            if (image.size.width>=image.size.height) {
                scaleW=imageW/image.size.width;
            }else{
                scaleW=imageW/image.size.height;
            }
            
            panImage = image;
            
            if (image.size.width>0 && image.size.height>0) {
                self.proBut.imageEdgeInsets=UIEdgeInsetsMake((self.proBut.frame.size.height-scaleW*(image.size.height) )/2, (self.proBut.frame.size.width-scaleW*(image.size.width))/2, (self.proBut.frame.size.height-scaleW*(image.size.height))/2, (self.proBut.frame.size.width-scaleW*(image.size.width))/2);
            }
            
        }];

    }
    
    return cell;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 18, 120, 22)];
    view.backgroundColor = UIColorFromHex(0x354048);
    titleLab.textColor = UIColorFromHex(0xb1c0c8);
    titleLab.font = [UIFont systemFontOfSize:16];
    titleLab.text = [_dataSource[section] objectForKey:@"title"];
    [view addSubview:titleLab];
    
    if (section==0) {
        UIButton *arrow = [[UIButton alloc] initWithFrame:CGRectMake(4, 9, 44, 44)];
        _retArrow = arrow;
        if (_showTag==YES) {
            _retArrow.hidden= NO;
        }else{
            _retArrow.hidden= YES;
        }
        [arrow setImage:[UIImage imageNamed:@"retArr"] forState:UIControlStateNormal];
        [arrow addTarget:self action:@selector(retArrowAction) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:arrow];
    }
    
    return view;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.section==0) {
        
        return 353;
        
    }else{
        
        NSArray *_data = [_dataSource[indexPath.section] objectForKey:@"data"];
        if (_data.count%4!=0) {
            NSInteger count = _data.count/4+1;
            return collcellHei*count + (count+1)*10;
        }else{
            NSInteger count = _data.count/4;
            return collcellHei*count + (count+1)*10;
        }
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 52;
}

-(void)favAction:(UIButton*)sender
{

    HttpRequestCalss *httpRequest=[[HttpRequestCalss alloc] init];
    
    NSDictionary *param = @{@"userid":[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"],@"id":[_proInfoDict objectForKey:@"id"]};
    
    if (sender.selected == NO) {
        
        sender.selected = YES;
        
        [httpRequest postHttpDataWithParam:param url:ADDFAV success:^(NSDictionary *dict, BOOL success) {
            
            [sender setImage:[UIImage imageNamed:@"isFav1"] forState:UIControlStateNormal];
            
            NSDictionary *infoDict = [_dataSource[0] objectForKey:@"dict"];
            
            [infoDict setValue:@"Y" forKey:@"isFav"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"favUpdaeToList" object:nil userInfo:@{@"id":_model.pid,@"fav":@"Y"}];
            
             [[NSNotificationCenter defaultCenter] postNotificationName:@"favUpdaeToFavCell" object:nil userInfo:nil];

        } fail:^(NSError *error) {
            
        }];
        
    }else{
        
        sender.selected = NO;
        
        [httpRequest postHttpDataWithParam:param url:DELFAV success:^(NSDictionary *dict, BOOL success) {
            
            [sender setImage:[UIImage imageNamed:@"isFav"] forState:UIControlStateNormal];
            
            NSDictionary *infoDict = [_dataSource[0] objectForKey:@"dict"];
            
            [infoDict setValue:@"N" forKey:@"isFav"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"favUpdaeToList" object:nil userInfo:@{@"id":_model.pid,@"fav":@"N"}];
            
             [[NSNotificationCenter defaultCenter] postNotificationName:@"favUpdaeToFavCell" object:nil userInfo:nil];

            
        } fail:^(NSError *error) {
            
        }];
        
    }
    
}


-(void)addToCanvas:(UIButton *)sender
{
    NSString *urlStr ;
    if (_sampleData.count!=0) {
        urlStr = [NSString stringWithFormat:@"%@/%@",PICURL,_sampleData[_selectIndex]];
    }else{
        urlStr = [_proInfoDict objectForKey:@"thumb_file"];
    }
    
    NSURL *url = [NSURL URLWithString:urlStr];
    [sender.imageView sd_setImageWithPreviousCachedImageWithURL:url placeholderImage:[UIImage imageNamed:@"loading1"] options:(SDWebImageRetryFailed) progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        if (image==nil) {
            return ;
        }
        [YSKJ_DrawData getDrawDataJsonDict:@{@"image":image,
                                             @"src":urlStr,
                                             @"pid":[_proInfoDict objectForKey:@"id"]
                                             }  objType:(product) WithBlock:^(YSKJ_drawModel *model) {
         NSDictionary *userInfo = @{
                                    @"model":model,
                                    };
         [[NSNotificationCenter defaultCenter] postNotificationName:@"addToCanvasNotification" object:nil userInfo:userInfo];
                                                 
        }];
    }];

}

-(void)pan:(UIPanGestureRecognizer*)ges
{
    UIButton *button = (UIButton *)ges.view;
    
    button.frame = CGRectMake(0, 0, _proBut.frame.size.width, _proBut.frame.size.height);
    if (panImage.size.width>=panImage.size.height) {
        panScale = (button.frame.size.width - 150)/panImage.size.width;
    }else{
        panScale = (button.frame.size.width - 150)/panImage.size.height;
    }
    
    button.imageEdgeInsets=UIEdgeInsetsMake((button.frame.size.height-panScale*(panImage.size.height))/2, (button.frame.size.width-panScale*(panImage.size.width))/2, (button.frame.size.height-panScale*(panImage.size.height))/2, (button.frame.size.width-panScale*(panImage.size.width))/2);
    
    NSString *urlStr;
    if (_sampleData.count!=0) {
        urlStr = [NSString stringWithFormat:@"%@/%@",PICURL,_sampleData[_selectIndex]];
    }else{
        urlStr = [_proInfoDict objectForKey:@"thumb_file"];
    }
    NSDictionary *dict = @{@"ges":ges,
                           @"button":ges.view,
                           @"dict":@{
                                     @"thumb_file":urlStr,
                                     @"id":[_proInfoDict objectForKey:@"id"]
                                     }
                           };
    [[NSNotificationCenter defaultCenter] postNotificationName:@"panNotification" object:nil userInfo:dict];
    
    if (ges.state == UIGestureRecognizerStateBegan) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"beganPanNotification" object:nil userInfo:dict];
    }
    
    if (ges.state == UIGestureRecognizerStateEnded || ges.state == UIGestureRecognizerStateFailed){
        
        UIImageView *imageView = [[UIImageView alloc] init];
        //获取网络图片的Size
        [imageView sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:nil options:(SDWebImageRetryFailed) progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
        } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            
            NSDictionary *dict = @{@"ges":ges,
                                   @"button":ges.view,
                                   @"dict":@{
                                           @"thumb_file":urlStr,
                                           @"id":[_proInfoDict objectForKey:@"id"],
                                           @"netW":[NSString stringWithFormat:@"%f",image.size.width],
                                           @"netH":[NSString stringWithFormat:@"%f",image.size.height]
                                           }
                                   };
            [[NSNotificationCenter defaultCenter] postNotificationName:@"endPanNotification" object:nil userInfo:dict];
            
        }];
        
        
    }
    
}


#pragma mark UICollectionViewDataSource,UICollectionViewDelegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.sampleCellView == collectionView) {
        
        return _sampleData.count;
        
    }else{
        
        NSArray *_data = [[NSMutableArray alloc] initWithArray:[_dataSource[1] objectForKey:@"data"]];
        return _data.count;
    }
    
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.sampleCellView == collectionView) {
        
        YSKJ_SampleCollCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"sampleCellId" forIndexPath:indexPath];
        
        cell.url = [NSString stringWithFormat:@"%@/%@",PICURL,_sampleData[indexPath.row]];
       
        [cell.button addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        
        if (_selectIndex == indexPath.row) {
            
            cell.layer.borderColor = UIColorFromHex(0x00abf2).CGColor;
            cell.layer.borderWidth = 1;
            
        }else{
            
            cell.layer.borderColor = [UIColor clearColor].CGColor;
            cell.layer.borderWidth = 1;
            
        }
        
        return cell;
        
    }else{
        
        YSKJ_SingleCollCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
        
        [cell.proBut addTarget:self action:@selector(proBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.panBut addTarget:self action:@selector(proBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.obj = [_dataSource[1] objectForKey:@"data"][indexPath.row];

        return cell;
    }

    
}
-(void)selectAction:(UIButton*)sender
{
    UICollectionViewCell *cell = (UICollectionViewCell*)sender.superview;
    NSIndexPath *indexPath = [_sampleCellView indexPathForCell:cell];
    _selectIndex = indexPath.row;
    [_proBut sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",PICURL,_sampleData[_selectIndex]]] forState:UIControlStateNormal placeholderImage:nil];
    
    _showTag = YES;
    
    [_proBut.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",PICURL,_sampleData[_selectIndex]]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        // 耗时的操作
        float imageW=283 - 40;
        float scaleW;
        if (image.size.width>=image.size.height) {
            scaleW=imageW/image.size.width;
        }else{
            scaleW=imageW/image.size.height;
        }
        if (image.size.width>0&&image.size.height>0) {
            
            _proBut.imageEdgeInsets=UIEdgeInsetsMake((_proBut.frame.size.height-scaleW*(image.size.height))/2, (_proBut.frame.size.width-scaleW*(image.size.width))/2, (_proBut.frame.size.height-scaleW*(image.size.height))/2, (_proBut.frame.size.width-scaleW*(image.size.width))/2);
        }
        
    }];
    [_sampleCellView reloadData];
    
}

-(void)proBtnAction:(UIButton*)sender
{
    UICollectionViewCell *cell = (UICollectionViewCell*)sender.superview;
    
    NSIndexPath *indexPath = [_singleCellView indexPathForCell:cell];
    
    NSDictionary *dict = [_dataSource[1] objectForKey:@"data"][indexPath.row];
    
    _showTag = YES;
    
    [self getProDuctDetail:[dict objectForKey:@"id"]];
}

-(void)retArrowAction
{
    if (_hositroyArr.count>1) {
        
         [_hositroyArr removeLastObject];
        
        _sampleData = [[NSMutableArray alloc] initWithArray:[ToolClass arrayWithJsonString:[[[_hositroyArr lastObject][0] objectForKey:@"dict"] objectForKey:@"desc_model"]]];
        
        _proInfoDict = [[_hositroyArr lastObject][0] objectForKey:@"dict"];
        
        _selectIndex = 0;
        
        for (int i=0; i<_sampleData.count; i++) {
            if ([[self.model.src substringFromIndex:27] isEqualToString:_sampleData[i]]) {
                _selectIndex = i;
            }
        }
        
        _dataSource = [_hositroyArr lastObject];
        
        if (_dataSource.count!=0) {
            [_tableView setContentOffset:CGPointMake(0,0) animated:YES];
        }
        
        [_tableView reloadData];
        
    }else{
        
        _showTag = NO;
        
        [self getProDuctDetail:self.model.pid];
        
    }
    
}

//设置元素的的大小框
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (self.sampleCellView == collectionView) {
        UIEdgeInsets top = {10,0,10,0};
        return top;
    }else{
        UIEdgeInsets top = {0,16,10,16};
        return top;
    }
    
}

-(void)setModel:(YSKJ_drawModel *)model
{
    _model = model;
    
    if (model!=nil && [model.objtype isEqualToString:@"product"]) {
        
        _noneView.hidden = YES;
        
        _showTag = NO;

        [self getProDuctDetail:model.pid];
        
    
    }else{
        _noneView.hidden = NO;
        [_dataSource removeAllObjects];
        [_tableView reloadData];
    }
    
    
}

#pragma mark 获取商品详情

-(void)getProDuctDetail:(NSString *)pid
{
    NSDictionary *dict=@{
                         @"id":pid,
                         @"userid":[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"],
                         };
    
    HttpRequestCalss *httpRequest=[[HttpRequestCalss alloc] init];
    
     dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
         
        [httpRequest postHttpDataWithParam:dict url:DETAIL success:^(NSDictionary *dict, BOOL success) {
            
            if ([[dict objectForKey:@"success"] integerValue] == 1) {
                
                _proInfoDict = [dict objectForKey:@"data"];
                
                _sampleData = [[NSMutableArray alloc] initWithArray:[ToolClass arrayWithJsonString:[[dict objectForKey:@"data"] objectForKey:@"desc_model"]]];
                
                _selectIndex = 0;
                
                for (int i=0; i<_sampleData.count; i++) {
                    if ([[self.model.src substringFromIndex:27] isEqualToString:_sampleData[i]]) {
                        _selectIndex = i;
                    }
                }
                
                _dataSource = [[NSMutableArray alloc] init];
                
                [_dataSource addObject:@{
                                         @"title":@"",
                                         @"data":@[],
                                         @"dict":[dict objectForKey:@"data"]
                                         }];
                
                NSArray *scrArr = [[NSMutableArray alloc] initWithArray:[[dict objectForKey:@"data"] objectForKey:@"same_good"]];
                
                [_dataSource addObject:@{
                                         @"title":@"相似单品",
                                         @"data":scrArr,
                                         @"dict":@{}
                                         }];
                
                if (_showTag==YES) {
                    [_hositroyArr addObject:_dataSource];
                }else{
                    [_hositroyArr removeAllObjects];
                }
                
                if (_dataSource.count!=0) {
            
                    if (scrArr.count>8) {
            
                        [_tableView setContentOffset:CGPointMake(0,0) animated:YES];
                    }
                    
                }
                
            }else{
                
                [_dataSource removeAllObjects];
                
                _noneView.hidden = NO;
                
                _tipLab.text = @"该商品已被删除！";
            }
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [_tableView reloadData];
                
            });


        } fail:^(NSError *error) {
            
        }];
         
    });
         
    
}

-(void)setTipTitle:(NSString *)tipTitle
{
    _tipTitle = tipTitle;
    _tipLab.text = tipTitle;
    _noneView.hidden = NO;
    [_dataSource removeAllObjects];
    [_tableView reloadData];
    
}

@end
