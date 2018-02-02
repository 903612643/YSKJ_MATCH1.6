//
//  YSKJ_ScreenShotClass.m
//  YSKJ_MATCH
//
//  Created by YSKJ on 18/1/19.
//  Copyright © 2018年 com.yskj. All rights reserved.
//

#import "YSKJ_ScreenShotClass.h"

#import "YSKJ_SaveWebImageClass.h"

#import "HttpRequestCalss.h"

#import "NSString+MD5.h"

#import <Qiniu/QiniuSDK.h>

#define FLODER @"design" //文件夹

#define SUBFLODER @"photo"  //子文件夹

#define FILENAME @"design" //文件名

#define FILETYLE @"png"  //文件类型

@implementation YSKJ_ScreenShotClass

+(void)screenShotView:(UIView*)view  CGRect:(CGRect)rect CGSize:(CGSize)size key:(NSString*)key  bucket:(NSString*)bucket  successBlock:(successBlock)successBlock failBlock:(failBlock)failBlock;
{
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 1);
    [view drawViewHierarchyInRect:rect afterScreenUpdates:NO];
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    YSKJ_SaveWebImageClass *save = [[YSKJ_SaveWebImageClass alloc] init];
    [save SaveShopPicFloder:FLODER p_no:SUBFLODER imageUrl:nil SaveFileName:FILENAME SaveFileType:FILETYLE image:snapshot size:size];
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    
    NSString *imagePath=[NSString stringWithFormat:@"%@/%@/%@",path,FLODER,SUBFLODER];
    
    NSString *fullPath = [imagePath stringByAppendingPathComponent:@"design.png"];
    
    HttpRequestCalss *requset=[[HttpRequestCalss alloc ] init];
    
    NSDictionary *param=
    @{
      @"bucket":bucket
      };
    
    [requset postHttpDataWithParam:param url:GETTOKEN  success:^(NSDictionary *dict, BOOL success) {
        
        NSDictionary *tokenDict=[dict objectForKey:@"data"];
        
        //国内https上传
        BOOL isHttps = TRUE;
        QNZone * httpsZone = [[QNAutoZone alloc] initWithHttps:isHttps dns:nil];
        QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
            builder.zone = httpsZone;
        }];
        
        QNUploadManager *upManager = [[QNUploadManager alloc] initWithConfiguration:config];
        [upManager putFile:fullPath key:[NSString stringWithFormat:@"%@/%@",key,[self stringKey]] token:[tokenDict objectForKey:@"token"] complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            if(info.ok)
            {
                successBlock(key);
                
            }else{
                failBlock();
                
            }}option:nil];

        
    } fail:^(NSError *error) {
        failBlock();
    }];
    
}

+(NSString *)stringKey
{
    //当前时间
    NSDate *date=[NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMdd";
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
    
    NSString *key=[NSString stringWithFormat:@"%@/%@.jpg",dateStr,[md5PassStr substringToIndex:16]];
    
    return key;
}


@end
