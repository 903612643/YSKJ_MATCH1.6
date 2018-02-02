//
//  AllPersonViewController.m
//  YSKJ
//
//  Created by YSKJ on 16/11/4.
//  Copyright © 2016年 5164casa.com. All rights reserved.
//


#import <Foundation/Foundation.h>

#import <AFNetworking/AFNetworking.h>

#import "AFHTTPSessionManager.h"

#import <CommonCrypto/CommonDigest.h>


@class HttpRequestCalss;

//Block
#define kTimeOutInterval 30 // 请求超时的时间
typedef void (^SuccessBlock)(NSDictionary *dict, BOOL success); // 访问成功block
typedef void (^AFNErrorBlock)(NSError *error); // 访问失败block


@interface HttpRequestCalss : NSObject

@property (nonatomic, strong) AFNetworkReachabilityManager *netManger;

//单例
+(HttpRequestCalss *)sharnInstance;

//get方法
- (void)getHttpDataWithParam:(NSDictionary *)param url:(NSString*)url  Success:(SuccessBlock)success fail:(AFNErrorBlock)fail;

//post
- (void)postHttpDataWithParam:(NSDictionary *)param url:(NSString*)url success:(SuccessBlock)success fail:(AFNErrorBlock)fail;

-(AFHTTPSessionManager *)manager;

- (void)judgeNet:(void (^)(NSInteger statusIndex))block;



@end
