//
//  WhisperView.h
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/7/13.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataStructure.h"

@protocol WhisperViewDelegate<NSObject>
-(void)OnWhisperViewDidScroll;
@end

@interface WhisperView : UIView
{
    __unsafe_unretained id <WhisperViewDelegate> _delegate;
}
@property (nonatomic,assign)id <WhisperViewDelegate> delegate;

- (void)pillowTalk:(PlayerInfo*)player andWhisper:(NSString*)whisper;
@end
