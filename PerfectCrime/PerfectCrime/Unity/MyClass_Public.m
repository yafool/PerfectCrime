//
//  MyClass_Public.m
//  hpwifiShop
//
//  Created by wangxiaoqin on 14-7-24.
//  Copyright (c) 2014年 perter/xuhaiyuan. All rights reserved.
//

#import "MyClass_Public.h"
static MyClass_Public * _MyClass_Public=nil;
@implementation MyClass_Public
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        _userDict         = [[NSMutableDictionary alloc]init];
        _fnSpotlightDict  = [[NSDictionary alloc]init];
        _m_notification   = [[NSDictionary alloc]init];
        _serviceDict      = [[NSDictionary alloc]init];
    }
    return self;
}
+(MyClass_Public *)getInstance{
    
    @synchronized(self){
        
        if (_MyClass_Public==nil) {
            _MyClass_Public = [[MyClass_Public alloc] init];
            
        }
        return _MyClass_Public;
        
    }
}
@end
