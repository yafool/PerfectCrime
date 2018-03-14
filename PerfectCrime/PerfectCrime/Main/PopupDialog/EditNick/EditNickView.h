//
//  EditNickView.h
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/8/25.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import "DlgView.h"


// 投票结束
typedef void(^EditNickSucessBlock)(NSDictionary*);
typedef void(^EditNickCancelBlock)(void);

@interface EditNickView : DlgView

+ (DlgAppearance *)appearances;

+ (void)showWithSucessBlock:(EditNickSucessBlock)sucess andCancelBlock:(EditNickCancelBlock)cancel;
+ (void)showWithRegister:(NSDictionary*)weiAccount andSucessBlock:(EditNickSucessBlock)sucess andCancelBlock:(EditNickCancelBlock)cancel;
@end
