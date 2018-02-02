//
//  YSKJ_DrawData.h
//  YSKJ_MATCH
//
//  Created by YSKJ on 17/12/1.
//  Copyright © 2017年 com.yskj. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YSKJ_drawModel.h"

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,objType)
{
    product = 1,
    spacebg = 2,
};

typedef  void (^DrawDataBlock)(YSKJ_drawModel *model);

@interface YSKJ_DrawData : NSObject

+(void)getDrawDataJsonDict:(NSDictionary*)image  objType:(objType)objType WithBlock:(DrawDataBlock)block;


@end
