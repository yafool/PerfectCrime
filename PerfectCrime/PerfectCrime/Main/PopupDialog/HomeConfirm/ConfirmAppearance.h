//
//  ConfirmAppearance.h
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/8/24.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import "DlgAppearance.h"

@interface ConfirmAppearance : DlgAppearance
-(void)initConfirm:(NSDictionary*)m_dict;
-(NSString*)getHomeName;
-(void)setInputPwd:(NSString*)pwd;
-(BOOL)isConfirm;
@end
