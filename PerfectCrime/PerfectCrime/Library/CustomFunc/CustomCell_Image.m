//
//  CustomCell_Image.m
//  hpwifiShop
//
//  Created by wangxiaoqin on 14-7-18.
//  Copyright (c) 2014年 perter/xuhaiyuan. All rights reserved.
//

#import "CustomCell_Image.h"

@implementation CustomCell_Image
+ (UIImage*)getImage:(UIImage*)_image{
    _image =[_image resizableImageWithCapInsets:UIEdgeInsetsMake( 20,
                                                                 20,
                                                                 20,
                                                                 20) resizingMode:UIImageResizingModeTile];
    return _image;
}
@end
