//
//  YSKJ_MyLoadProduct.m
//  YSKJ_MATCH
//
//  Created by YSKJ on 17/12/18.
//  Copyright © 2017年 com.yskj. All rights reserved.
//

#import "YSKJ_MyLoadProduct.h"

#import "YSKJ_HeaderView.h"

#import "YSKJ_CanvasLoading.h"


#define UIColorFromHex(s)  [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1]

@implementation YSKJ_MyLoadProduct

-(id)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        
        UIView *uility = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        uility.backgroundColor = UIColorFromHex(0x354048);
        [self addSubview:uility];
        
        input = [[YSKJ_UploadInput alloc] initWithFrame:CGRectMake(30, 50, 446, 281)];
        input.hidden = YES;
        [input.cancleBtn addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
        [input.upLoadBtn addTarget:self action:@selector(uploadAction) forControlEvents:UIControlEventTouchUpInside];
        [input.faceBtn addTarget:self action:@selector(upfaceAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:input];
        
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake((uility.frame.size.width  - 64)/3, 187);
        UICollectionView *loadCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 54, uility.frame.size.width, uility.frame.size.height - 54) collectionViewLayout:layout];
        _colletionView= loadCollectionView;
        loadCollectionView.dataSource = self;
        loadCollectionView.delegate = self;
        loadCollectionView.backgroundColor = UIColorFromHex(0x354048);
        [loadCollectionView registerClass:[YSKJ_LoadCollCell class] forCellWithReuseIdentifier:@"cellId"];
        [uility addSubview:loadCollectionView];
        
        UICollectionViewFlowLayout * favlayout = [[UICollectionViewFlowLayout alloc]init];
        favlayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        favlayout.itemSize = CGSizeMake((uility.frame.size.width  - 64)/3, 187);
        UICollectionView *favCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 54, uility.frame.size.width, uility.frame.size.height - 54) collectionViewLayout:favlayout];
        _favColletionView= favCollectionView;
        favCollectionView.dataSource = self;
        favCollectionView.delegate = self;
        favCollectionView.hidden = YES;
        favCollectionView.backgroundColor = UIColorFromHex(0x354048);
        [favCollectionView registerClass:[YSKJ_FavCollCell class] forCellWithReuseIdentifier:@"cellId1"];
        [uility addSubview:favCollectionView];
        [self httpFavData];
        
        
        _none = [[YSKJ_NoneDataView alloc] initWithFrame:CGRectMake(0, 0, _colletionView.frame.size.width, _colletionView.frame.size.height)];
        _none.title = @"抱歉，您还没有上传单品！";
        [_colletionView addSubview:_none];
        
        _favNone = [[YSKJ_NoneDataView alloc] initWithFrame:CGRectMake(0, 0, _favColletionView.frame.size.width, _favColletionView.frame.size.height)];
        _favNone.title =  @"抱歉，您还没有收藏单品！";
        [_favColletionView addSubview:_favNone];
  
        YSKJ_HeaderView *headerView = [[YSKJ_HeaderView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 54)];
        headerView.backgroundColor = UIColorFromHex(0x354048);
        _headerView = headerView;
        [headerView.addBtn addTarget:self action:@selector(upLoad:) forControlEvents:UIControlEventTouchUpInside];
        [headerView.editList addTarget:self action:@selector(editPlan:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:headerView];
        
        headerView.selectBlock = ^(NSInteger selectIndex)
        {
            if (selectIndex == 0) {
                _headerView.addBtn.hidden = NO;
                _headerView.editList.hidden = NO;
                _colletionView.hidden = NO;
                _favColletionView.hidden = YES;
                if (input.hidden==YES) {
                    _headerView.addBtn.enabled = YES;
                }
                [self httpData];
            }else
            {
                _headerView.addBtn.hidden = YES;
                _headerView.editList.hidden = YES;
                input.hidden = YES;
                _colletionView.hidden = YES;
                _favColletionView.hidden = NO;
                [self httpFavData];
            }
        };
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(favUpdate) name:@"favUpdaeCell" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(favUpdate) name:@"favUpdaeToFavCell" object:nil];
    }
    
    return self;
}

-(void)favUpdate
{
    [self httpFavData];
}


-(void)setHttp:(BOOL)http
{
    _http = http;
    if (http == YES) {
        [self httpData];
    }
}

-(void)upLoad:(UIButton*)sender
{
    if (sender.selected == NO) {
        sender.enabled = NO;
        input.hidden = NO;
    }
}

-(void)cancleAction
{
    _headerView.addBtn.enabled = YES;
    input.hidden = YES;
    _proImage = nil;
}

-(void)editPlan:(UIButton*)sender
{
    if (sender.selected == NO) {
        sender.selected = YES;
        [sender setTitleColor:UIColorFromHex(0x00ABF2)  forState:UIControlStateNormal];
        [sender setTitle:@"完成" forState:UIControlStateNormal];
        NSMutableArray *tempDataArr = [[NSMutableArray alloc] init];
        for (int i=0; i<_data.count; i++) {
            NSDictionary *dict = _data[i];
            NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] initWithDictionary:dict];
            [tempDict setObject:@1 forKey:@"edit"];
            [tempDataArr addObject:tempDict];
        }
        _data = tempDataArr;
        [_colletionView reloadData];
        
    }else{
        sender.selected = NO;
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sender setTitle:@"编辑" forState:UIControlStateNormal];
        NSMutableArray *tempDataArr = [[NSMutableArray alloc] init];
        for (int i=0; i<_data.count; i++) {
            NSDictionary *dict = _data[i];
            NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] initWithDictionary:dict];
            [tempDict setObject:@0 forKey:@"edit"];
            [tempDataArr addObject:tempDict];
        }
        _data = tempDataArr;
        [_colletionView reloadData];
        
    }
}
-(void)uploadAction
{
    [input.proName resignFirstResponder];

    if (input.proName.text.length!=0) {

        if (_proImage!=nil) {

            dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

                // 上传图片到七牛
                [self getToken:[self getDesignPath]];

            });

            dispatch_async(dispatch_get_main_queue(), ^{

                [input removeFromSuperview];

                _headerView.addBtn.enabled = YES;

                [YSKJ_CanvasLoading showNotificationViewWithText:@"正在上传..." loadType:loading];
                
            });

        }else{
            
            [YSKJ_CanvasLoading showNotificationViewWithText:@"请选择上传的图片" loadType:onlyText];
        }

    }else{

        [YSKJ_CanvasLoading showNotificationViewWithText:@"请填写单品名称" loadType:onlyText];
    }
}

#pragma mark 获取token

-(void)getToken:(NSString*)filePath
{
    HttpRequestCalss *requset=[[HttpRequestCalss alloc ] init];
    
    NSDictionary *param=
    @{
      @"bucket":@"mall"
      };
    
    [requset postHttpDataWithParam:param url:GETTOKEN  success:^(NSDictionary *dict, BOOL success) {
        
        NSDictionary *tokenDict=[dict objectForKey:@"data"];
        
        [self saveToQiniuServer:[tokenDict objectForKey:@"token"] filePath:filePath key:[NSString stringWithFormat:@"%@/p%@",@"store",[self stringKey]]];


    } fail:^(NSError *error) {
        
        [YSKJ_CanvasLoading showNotificationViewWithText:nil loadType:done];
        
        [YSKJ_CanvasLoading showNotificationViewWithText:@"正在失败" loadType:fail];
        
    }];
    
}

-(void)saveToQiniuServer:(NSString*)token filePath:(NSString*)filePath key:(NSString *)key
{
    //国内https上传
    BOOL isHttps = TRUE;
    QNZone * httpsZone = [[QNAutoZone alloc] initWithHttps:isHttps dns:nil];
    QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
        builder.zone = httpsZone;
    }];
    
    QNUploadManager *upManager = [[QNUploadManager alloc] initWithConfiguration:config];
    [upManager putFile:filePath key:key token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        if(info.ok)
        {
            for (UIView *subView in [UIApplication sharedApplication].keyWindow.subviews) {
                if (subView.tag == 2017) {
                    [subView removeFromSuperview];
                }
            }
            
            _proImage = nil;
            //添加单品
            HttpRequestCalss *requset=[[HttpRequestCalss alloc ] init];
            NSRange range;
            range.location = 6 ; range.length=19;
            
            NSDictionary *param=
            @{
              @"userid":[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"],
              @"name":input.proName.text,
              @"p_no":[key substringWithRange:range],
              @"thumb_file":key
              };
            
            [requset postHttpDataWithParam:param url:ADDPRO  success:^(NSDictionary *dict, BOOL success) {
                
                [YSKJ_CanvasLoading showNotificationViewWithText:@"上传成功" loadType:finishing];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    for (UIView *subView in [UIApplication sharedApplication].keyWindow.subviews) {
                        
                        if (subView.tag == 2017) {
                            [subView removeFromSuperview];
                        }
                    }
                });
                
                [self httpData];
                
            } fail:^(NSError *error) {
                
                [YSKJ_CanvasLoading showNotificationViewWithText:nil loadType:done];
                
                [YSKJ_CanvasLoading showNotificationViewWithText:@"正在失败" loadType:fail];
                
            }];
            
        }else{
         
            [YSKJ_CanvasLoading showNotificationViewWithText:nil loadType:done];
            
            [YSKJ_CanvasLoading showNotificationViewWithText:@"正在失败" loadType:fail];
            
        }}option:nil];
    
}


-(NSString *)stringKey
{
    //当前时间
    NSDate *date=[NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddhhmmss";
    NSString *dateStr = [formatter stringFromDate:date];
    
    NSArray *changeArray = [[NSArray alloc] initWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9", nil];//存放十个数，以备随机取
    NSMutableString * getStr = [[NSMutableString alloc] initWithCapacity:9];
    NSString *changeString = [[NSMutableString alloc] initWithCapacity:10];
    for (int i = 0; i<10; i++) {
        NSInteger index = arc4random()%([changeArray count]-1);
        getStr = changeArray[index];
        changeString = (NSMutableString *)[changeString stringByAppendingString:getStr];
    }
    NSString *md5PassStr=[changeString md5String];
    
    NSString *key=[NSString stringWithFormat:@"%@1111/%@.png",dateStr,md5PassStr];
    
    return key;
}


-(NSString*)getDesignPath
{
    YSKJ_SaveWebImageClass *save = [[YSKJ_SaveWebImageClass alloc] init];
    
    [save SaveShopPicFloder:@"design" p_no:@"photo" imageUrl:nil SaveFileName:@"design" SaveFileType:@"png" image:_proImage size:CGSizeMake(_proImage.size.width, _proImage.size.height)];
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    
    NSString *imagePath=[NSString stringWithFormat:@"%@/%@/%@",path,@"design",@"photo"];
    
    NSString *fullPath = [imagePath stringByAppendingPathComponent:@"design.png"];
    
    return fullPath;
}

-(void)upfaceAction
{
    [input.proName resignFirstResponder];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //选择相册模式
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [imagePicker.view.superview bringSubviewToFront:imagePicker.view];
        NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
        [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
        imagePicker.mediaTypes = mediaTypes;
        imagePicker.delegate = self;
        
        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        popover.popoverContentSize = CGSizeMake(600, 800);//弹出视图的大小
        [popover presentPopoverFromRect:CGRectMake(self.frame.size.width-60, 200, 60, 44) inView:self permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    });
    
}

#pragma mark UICollectionViewDataSource,UICollectionViewDelegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (collectionView == _colletionView) {
         return _data.count;
    }else{
         return _favData.count;
    }
   
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView == _colletionView) {
        
        cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
        
        cell.delegate = self;
        
        YSKJ_ProModel *model=[YSKJ_ProModel mj_objectWithKeyValues:_data[indexPath.row]];
        
        cell.url = model.thumb_file;
        
        cell.title = model.name;
        
        cell.money = model.price;
        
        cell.objDict = _data[indexPath.row];
        
        cell.fav = model.isFav;
        
        cell.edit = model.edit;
        
        [cell.favBtn addTarget:self action:@selector(favAction:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;

        
    }else{
        
        _favCell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId1" forIndexPath:indexPath];
        
        _favCell.delegate = self;
        
        YSKJ_ProModel *model=[YSKJ_ProModel mj_objectWithKeyValues:_favData[indexPath.row]];

        _favCell.url = model.thumb_file;
        
        _favCell.title = model.name;
        
        _favCell.money = model.price;
        
        _favCell.objDict = _favData[indexPath.row];
        
        _favCell.fav = model.isFav;
       
        [_favCell.favBtn addTarget:self action:@selector(favListFavAction:) forControlEvents:UIControlEventTouchUpInside];
        
        return _favCell;

    }
      
}

//设置元素的的大小框
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets top = {20,16,10,16};
    return top;
}

-(void)favAction:(UIButton*)sender
{
    UICollectionViewCell *theCell = (UICollectionViewCell*)sender.superview;
    
    NSIndexPath *indexPath = [(UICollectionView*)theCell.superview indexPathForCell:theCell];
    
    NSDictionary *infoDict = _data[indexPath.row];
    
    HttpRequestCalss *httpRequest=[[HttpRequestCalss alloc] init];
    
    NSDictionary *param = @{@"userid":[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"],@"id":[_data[indexPath.row] objectForKey:@"id"]};
    
    
    if (sender.selected == NO) {
        
        sender.selected = YES;
        
        [httpRequest postHttpDataWithParam:param url:ADDFAV success:^(NSDictionary *dict, BOOL success) {
            
            [infoDict setValue:@"Y" forKey:@"isFav"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"favUpdaeNotification" object:nil userInfo:nil];
            
            [_colletionView reloadData];
            
        } fail:^(NSError *error) {
            
        }];
        
    }else{
        
        sender.selected = NO;
        
        [httpRequest postHttpDataWithParam:param url:DELFAV success:^(NSDictionary *dict, BOOL success) {
    
            [infoDict setValue:@"N" forKey:@"isFav"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"favUpdaeNotification" object:nil userInfo:nil];
            
            [_colletionView reloadData];
            
        } fail:^(NSError *error) {
            
        }];
        
    }
    
}

-(void)favListFavAction:(UIButton*)sender
{
    UICollectionViewCell *theCell = (UICollectionViewCell*)sender.superview;
    
    NSIndexPath *indexPath = [(UICollectionView*)theCell.superview indexPathForCell:theCell];
    
    NSDictionary *infoDict = _favData[indexPath.row];
    
    HttpRequestCalss *httpRequest=[[HttpRequestCalss alloc] init];
    
    NSDictionary *param = @{@"userid":[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"],@"id":[infoDict objectForKey:@"id"]};
    
    if (sender.selected == NO) {
        
        sender.selected = YES;
        
        [httpRequest postHttpDataWithParam:param url:ADDFAV success:^(NSDictionary *dict, BOOL success) {
            

            [sender setImage:[UIImage imageNamed:@"isFav1"] forState:UIControlStateNormal];
            
            [infoDict setValue:@"Y" forKey:@"isFav"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"favUpdaeNotification" object:nil userInfo:nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"favUpdaeToList" object:nil userInfo:@{@"id":[infoDict objectForKey:@"id"],@"fav":@"Y"}];
            
        } fail:^(NSError *error) {
            
        }];
        
    }else{
        
        sender.selected = NO;
        
        [httpRequest postHttpDataWithParam:param url:DELFAV success:^(NSDictionary *dict, BOOL success) {
            
            [infoDict setValue:@"N" forKey:@"isFav"];
            
             [sender setImage:[UIImage imageNamed:@"isFav"] forState:UIControlStateNormal];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"favUpdaeNotification" object:nil userInfo:nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"favUpdaeToList" object:nil userInfo:@{@"id":[infoDict objectForKey:@"id"],@"fav":@"N"}];
            
        } fail:^(NSError *error) {
            
        }];
        
    }
}



#pragma mark YSKJ_LoadCollCellDelegate

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

-(void)deleteRow:(NSInteger)row;
{
    [YSKJ_AlertView showAlertTitle:@"您确定删除此单品" content:nil cancleBlock:^{
        
    } finishBlock:^{
        
        NSDictionary *obj = _data[row];
        NSDictionary *param = @{
                                @"userid":[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"],
                                @"id":[obj objectForKey:@"id"]
                                };
        
        HttpRequestCalss *httpRequest=[[HttpRequestCalss alloc] init];
        
        [httpRequest postHttpDataWithParam:param url:DELPRO success:^(NSDictionary *dict, BOOL success) {
            
            [self httpData];
            
        } fail:^(NSError *error) {
            
        }];
        
    }];
    
}

#pragma mark YSKJ_FavCollCellDelegate

-(void)favGetRow:(NSInteger)row
{
    NSDictionary *obj = _favData[row];
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


-(void)httpData
{
        NSDictionary *param = @{
                                @"userid":[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]
                                };
        
        HttpRequestCalss *httpRequest=[[HttpRequestCalss alloc] init];
        
        [httpRequest postHttpDataWithParam:param url:UPLOADLIST success:^(NSDictionary *dict, BOOL success) {
            
            _data=[dict objectForKey:@"data"];
            
            NSMutableArray *tempDataArr = [[NSMutableArray alloc] init];
            for (int i=0; i<_data.count; i++) {
                NSDictionary *dict = _data[i];
                NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] initWithDictionary:dict];
                if (_headerView.editList.selected == NO) {
                    [_headerView.editList setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [_headerView.editList setTitle:@"编辑" forState:UIControlStateNormal];
                    [tempDict setObject:@0 forKey:@"edit"];
                }else{
                    [_headerView.editList setTitleColor:UIColorFromHex(0x00ABF2) forState:UIControlStateNormal];
                    [_headerView.editList setTitle:@"完成" forState:UIControlStateNormal];
                    [tempDict setObject:@1 forKey:@"edit"];
                }
                
                [tempDataArr addObject:tempDict];
            }
            _data = tempDataArr;

            if (_data.count==0) {
                _none.hidden = NO;
            }else{
                _none.hidden = YES;
            }
            
            [_colletionView reloadData];

        } fail:^(NSError *error) {
            
        }];
    
}

-(void)httpFavData
{
    NSDictionary *param = @{
                            @"userid":[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]
                            };
    
    HttpRequestCalss *httpRequest=[[HttpRequestCalss alloc] init];
    
    [httpRequest postHttpDataWithParam:param url:FAVLIST success:^(NSDictionary *dict, BOOL success) {
        
        _favData=[dict objectForKey:@"data"];
        
        for (NSDictionary *dict in _favData) {
            [dict setValue:@"Y" forKey:@"isFav"];
        }

        if (_favData.count==0) {
            _favNone.hidden = NO;
        }else{
            _favNone.hidden = YES;
        }
    
        [_favColletionView reloadData];
     

    } fail:^(NSError *error) {
        
    }];
    
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:^() {
        
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        
        NSData *imageData = UIImageJPEGRepresentation(portraitImg, 1);

        if (portraitImg.size.width>100) {
            
            if (portraitImg.size.height>100) {
                
                if ((imageData.length/1000.0/1024.0)<10) {
                    
                    _proImage = portraitImg;
                    [input.faceBtn setImage:portraitImg forState:UIControlStateNormal];
                    
                } else {
                    YSKJ_TipViewCalss *tip = [[YSKJ_TipViewCalss alloc] init];
                    tip.title = @"图片不能大于10M";
                }
            } else {
                YSKJ_TipViewCalss *tip = [[YSKJ_TipViewCalss alloc] init];
                tip.title = @"图片高度不能小于100像素";
            }
            
        }else{
            YSKJ_TipViewCalss *tip = [[YSKJ_TipViewCalss alloc] init];
            tip.title = @"图片宽度不能小于100像素";
        }

    }];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}


@end
