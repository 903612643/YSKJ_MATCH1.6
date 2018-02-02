//
//  YSKJ_ListData.m
//  YSKJ_MATCH
//
//  Created by YSKJ on 18/1/19.
//  Copyright © 2018年 com.yskj. All rights reserved.
//

#import "YSKJ_ListData.h"

#import "ToolClass.h"

@implementation YSKJ_ListData

+(void)listDataArray:(NSMutableArray*)proIdArr detailArr:(NSMutableArray *)detailArr Block:(listDataBlock)listDataBlock;
{
    NSDictionary *dic=[self statisticsArrayCountDict:proIdArr];   //统计数组相同元素的个数
    
    NSArray *allKeys=[dic allKeys];
    
    NSMutableDictionary *theDict=[[NSMutableDictionary alloc] init];
    
    for (NSString *key in allKeys) {
        
        for (NSDictionary *proDict in detailArr) {
            
            NSDictionary *prosubDict=[proDict objectForKey:@"data"];
            
            if ([[prosubDict objectForKey:@"id"] integerValue]==[key integerValue]) {
                
                [theDict setValue:prosubDict forKey:key];
            }
        }
    }
    
    NSArray *allValue=[theDict allValues];

    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *valueDict in allValue) {
        
        [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            
            if ([[NSString stringWithFormat:@"%@",key] isEqualToString:[NSString stringWithFormat:@"%@",[valueDict objectForKey:@"id"]]]) {
                
                NSMutableDictionary *proInfoDict = [[NSMutableDictionary alloc] init];
                
                NSDictionary *dict = [ToolClass dictionaryWithJsonString:[valueDict objectForKey:@"attributes"]];
                
                NSArray *styleArr = [dict objectForKey:@"风格"];
                
                NSArray *spaceArr = [dict objectForKey:@"空间"];
                
                [proInfoDict setValue:@"1" forKey:@"check"];
                
                [proInfoDict setObject:[valueDict objectForKey:@"thumb_file"] forKey:@"thumb_file"];
                
                [proInfoDict setValue:[valueDict objectForKey:@"name"] forKey:@"name"];
                
                [proInfoDict setValue:[dict objectForKey:@"品牌"] forKey:@"pinpai"];
                
                [proInfoDict setValue:[dict objectForKey:@"品类"] forKey:@"pinlei"];
                
                [proInfoDict setValue:[spaceArr componentsJoinedByString:@","] forKey:@"space"];
                
                [proInfoDict setValue:[styleArr componentsJoinedByString:@","] forKey:@"style"];
                
                [proInfoDict setValue:@"" forKey:@"beizhu"];
                
                [proInfoDict setValue:[valueDict objectForKey:@"price"] forKey:@"price"];
                
                [proInfoDict setValue:@"0" forKey:@"edit"];
                
                [proInfoDict setValue:obj forKey:@"count"];
                
                [tempArray addObject:proInfoDict];
                
            }
        }];
        
    }
    
    listDataBlock(tempArray);

}


+(NSDictionary *)statisticsArrayCountDict:(NSMutableArray *)array
{
    //统计数组相同元素的个数
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    //需要统计的数组
    NSSet *set = [NSSet setWithArray:array];
    
    for (NSString *setstring in set) {
        
        //需要去掉的元素数组
        NSMutableArray *filteredArray = [[NSMutableArray alloc]initWithObjects:setstring, nil];
        
        NSMutableArray *dataArray = array;
        
        NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",filteredArray];
        //过滤数组
        NSArray * reslutFilteredArray = [dataArray filteredArrayUsingPredicate:filterPredicate];
        
        int number = (int)(dataArray.count-reslutFilteredArray.count);
        
        [dic setObject:[NSString stringWithFormat:@"%d",number] forKey:setstring];
    }
    
    return dic;
    
}

@end
