//
//  PlayerListCell.h
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/7/1.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PlayerListCellDelegate<NSObject>
-(void)OnAddClickWithPlayer:(NSDictionary*)m_dict;
@end

@interface PlayerListCell : UITableViewCell
{
    __unsafe_unretained id <PlayerListCellDelegate> _delegate;
}
@property (nonatomic,assign)id <PlayerListCellDelegate> delegate;

-(void)showUI:(NSDictionary*)m_dict;
@end
