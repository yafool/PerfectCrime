//
//  GamesViewController.h
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/6/19.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerListCell.h"

@interface GamesViewController : UIViewController
<
UITableViewDataSource,
UITableViewDelegate,
PlayerListCellDelegate
>
@end
