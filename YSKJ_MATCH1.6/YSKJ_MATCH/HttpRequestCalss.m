//
//  AllPersonViewController.h
//  YSKJ
//
//  Created by YSKJ on 16/11/4.
//  Copyright © 2016年 5164casa.com. All rights reserved.
//


#import "HttpRequestCalss.h"

static HttpRequestCalss *stance=nil;

@implementation HttpRequestCalss

+(HttpRequestCalss *)sharnInstance
{
    if (stance==nil) {
        
        stance=[[HttpRequestCalss alloc] init];
        
    }
    return stance;
}

-(AFHTTPSessionManager *)manager
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 超时时间
    manager.requestSerializer.timeoutInterval = kTimeOutInterval;

    manager.requestSerializer = [AFHTTPRequestSerializer serializer]; // 上传普通格式

    // 声明获取到的数据格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    return manager;
}

//get方法
- (void)getHttpDataWithParam:(NSDictionary *)param url:(NSString*)url  Success:(SuccessBlock)success fail:(AFNErrorBlock)fail
{
    AFHTTPSessionManager *manager = [self manager];
    
    [manager GET:url parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        // 这里可以获取到目前数据请求的进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 请求成功
        if(responseObject){
            
        } else {
            
            success(@{@"msg":@"暂无数据"}, NO);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
   
        fail(error);
    }];
    
}

//post
- (void)postHttpDataWithParam:(NSDictionary *)param url:(NSString*)url success:(SuccessBlock)success fail:(AFNErrorBlock)fail
{
    // 创建请求类
    AFHTTPSessionManager *manager = [self manager];
    
    [manager POST:url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        // 这里可以获取到目前数据请求的进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 请求成功
        if(responseObject){
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            success(dict,YES);
           
            
        } else {
            success(@{@"msg":@"暂无数据"}, NO);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        // 请求失败
        fail(error);
        
    }];
    
}

// 判断网络
-(void)judgeNet:(void (^)(NSInteger statusIndex))block;
{
    self.netManger = [AFNetworkReachabilityManager sharedManager];
    
    __block  NSInteger tempIndex;
    
    [self.netManger setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {

        switch (status) {
                
            case AFNetworkReachabilityStatusNotReachable: {
                
                tempIndex = status;
                
                NSLog(@"网络不可用");
                
              //  [YSKJ_NetStatusNotificationView showNotificationViewWithText:@"当前网络不可用，请检查网络设置"];

                break;
            }
                
            case AFNetworkReachabilityStatusReachableViaWiFi: {
                
                NSLog(@"Wifi已开启");
                
                tempIndex = status;
                
                break;
            }
                
            case AFNetworkReachabilityStatusReachableViaWWAN: {
                
                NSLog(@"你现在使用的流量");
                
                tempIndex = status;
                
                break;
            }
                
            case AFNetworkReachabilityStatusUnknown: {
                
                NSLog(@"你现在使用的未知网络");
                
                //  [YSKJ_NetStatusNotificationView showNotificationViewWithText:@"当前网络不可用，请检查网络设置"];
                
                tempIndex = status;
                
                break;
            }

                
            default:
                break;
        }
        
        block(status);
        
    }];
    
    [self.netManger startMonitoring];
    
}


@end
