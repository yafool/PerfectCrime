//
//  PlayerEssentialInfoView.h
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/6/21.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PlayerEssentialInfoDelegate<NSObject>
-(void)OnClickEssentialInfo;
@end

@interface PlayerEssentialInfoView : UIView
{
    __unsafe_unretained id <PlayerEssentialInfoDelegate> _delegate;
}
@property (nonatomic,assign)id <PlayerEssentialInfoDelegate> delegate;
-(void)initEssentialInfo:(NSDictionary*)m_dict;
@end
