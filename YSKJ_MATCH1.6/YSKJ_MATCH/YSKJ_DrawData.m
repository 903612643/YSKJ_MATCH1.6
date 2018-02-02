//
//  YSKJ_DrawData.m
//  YSKJ_MATCH
//
//  Created by YSKJ on 17/12/1.
//  Copyright © 2017年 com.yskj. All rights reserved.
//

#import "YSKJ_DrawData.h"

#import <MJExtension/MJExtension.h>

static YSKJ_DrawData *stance=nil;

@implementation YSKJ_DrawData

+(void)getDrawDataJsonDict:(NSDictionary*)objDict  objType:(objType)objType WithBlock:(DrawDataBlock)block
{
                           
    UIImage *theImage =[objDict objectForKey:@"image"];
    
    float centerX = 600;
    float centerY = 150;
    float x=centerX-(theImage.size.width*0.2)/2 ;
    float y=centerY-(theImage.size.height*0.2)/2 ;
    
    NSString *type;
    
    if (objType == product) {
        
        type = @"product";
        
    }else if (objType == spacebg)
    {
        type = @"spacebg";
        
    }else{
        type = @"";
    }
    
    NSDictionary *jsonDict = @{
                               @"x":[NSString stringWithFormat:@"%0.2f",centerX],
                               @"y":[NSString stringWithFormat:@"%0.2f",centerY],
                               @"scaleX":@0.2,
                               @"scaleY":@0.2,
                               @"rotation":@0,
                               @"objtype":type,
                               @"mirror":@0,
                               @"src":[objDict objectForKey:@"src"],
                               @"lock":@0,
                               @"pid":[objDict objectForKey:@"pid"],
                               @"naturew":[NSString stringWithFormat:@"%f",theImage.size.width],
                               @"natureh":[NSString stringWithFormat:@"%f",theImage.size.height],
                               @"originX":[NSString stringWithFormat:@"%f",x],
                               @"originY":[NSString stringWithFormat:@"%f",y],
                               @"w":[NSString stringWithFormat:@"%f",theImage.size.width*0.2],
                               @"h":[NSString stringWithFormat:@"%f",theImage.size.height*0.2]
                               };
    
    YSKJ_drawModel *model = [YSKJ_drawModel mj_objectWithKeyValues:jsonDict];
    
    block(model);

}


@end
