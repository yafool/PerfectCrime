//
//  RoomCollectionViewCell.h
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/6/19.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoomCollectionViewCell : UICollectionViewCell
@property (nonatomic ,copy) NSMutableDictionary *roomDict;

@property (nonatomic ,copy) NSString    *roomId;
@property (nonatomic ,copy) NSString    *passwd;
@property (nonatomic ,copy) NSString    *grade;
@property (nonatomic ,copy) NSString    *roomName;
@property (nonatomic ,copy) NSString    *speed;
@property (nonatomic ,copy) NSString    *userId;
@property (nonatomic ,copy) NSString    *limit;

-(void)initCellwithDictionary:(NSDictionary*)m_dict;

@end
