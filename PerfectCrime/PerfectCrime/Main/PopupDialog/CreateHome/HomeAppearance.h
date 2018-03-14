//
//  PlayerAppearance.h
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/8/10.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import "DlgAppearance.h"

#define  kHomeSpeed_quick   @"快速"
#define  kHomeSpeed_normal  @"正常"
#define  kHomeSpeed_slow    @"慢速"

#define kHomeGrade_rookie   @"菜鸟"
#define kHomeGrade_master   @"高手"

@interface HomeAppearance : DlgAppearance

- (NSDictionary*)getHomeInfo;
- (void)clearHomeInfo;

- (void)setUserId:(NSString*)str;
- (void)setName:(NSString*)str;
- (void)setGrade:(NSString*)str;
- (void)setSpeed:(NSString*)str;
- (void)setLimit:(NSString*)str;
- (void)setPasswd:(NSString*)str;

- (void)setCreateValid:(BOOL)valid;
- (BOOL)isCreateValid;

- (NSString*) speedKeyWithValue:(NSString*)value;
- (NSString*) gradeKeyWithValue:(NSString*)value;
@end
