//
//  YSKJ_ListData.h
//  YSKJ_MATCH
//
//  Created by YSKJ on 18/1/19.
//  Copyright © 2018年 com.yskj. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^listDataBlock) (NSMutableArray *array);

@interface YSKJ_ListData : NSObject

@property (nonatomic,copy)listDataBlock block;

+(void)listDataArray:(NSMutableArray*)proIdArr detailArr:(NSMutableArray *)detailArr Block:(listDataBlock)listDataBlock;

@end
