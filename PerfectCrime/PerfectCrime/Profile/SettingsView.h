//
//  SettingsView.h
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/6/21.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingsDelegate<NSObject>
-(void)OnClickRemindSetting;
-(void)OnClickSkinSetting;
@end

@interface SettingsView : UIView
{
    __unsafe_unretained id <SettingsDelegate> _delegate;
}
@property (nonatomic,assign)id <SettingsDelegate> delegate;
-(void)setRemided:(NSString*)m_str;
-(void)setSkin:(NSString*)m_str;
@end
