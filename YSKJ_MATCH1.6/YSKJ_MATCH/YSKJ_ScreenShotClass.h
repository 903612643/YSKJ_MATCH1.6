//
//  YSKJ_ScreenShotClass.h
//  YSKJ_MATCH
//
//  Created by YSKJ on 18/1/19.
//  Copyright © 2018年 com.yskj. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

#define API_DOMAIN @"www.5164casa.com/api/assist" //正式服务器

#define GETTOKEN @"http://"API_DOMAIN@"/sysconfig/gettoken" //得到token

typedef void (^successBlock)(NSString *key);

typedef void (^failBlock)() ;

@interface YSKJ_ScreenShotClass : NSObject

+(void)screenShotView:(UIView*)view  CGRect:(CGRect)rect CGSize:(CGSize)size key:(NSString*)key  bucket:(NSString*)bucket  successBlock:(successBlock)successBlock failBlock:(failBlock)failBlock;

@end
