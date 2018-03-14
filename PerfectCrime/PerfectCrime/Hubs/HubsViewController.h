//
//  HubsViewController.h
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/6/14.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FatherViewController.h"

@class HubsViewController;
/**
 *  Need to be implemented this methods for custom UI of segment button
 */
@protocol SlideSegmentDataSource <NSObject>
@required

- (NSInteger)slideSegment:(UICollectionView *)segmentBar
   numberOfItemsInSection:(NSInteger)section;

- (UICollectionViewCell *)slideSegment:(UICollectionView *)segmentBar
                cellForItemAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (NSInteger)numberOfSectionsInslideSegment:(UICollectionView *)segmentBar;

@end

@protocol SlideSegmentDelegate <NSObject>
@optional
- (void)slideSegment:(UICollectionView *)segmentBar didSelectedViewController:(UIViewController *)viewController;

- (BOOL)slideSegment:(UICollectionView *)segmentBar shouldSelectViewController:(UIViewController *)viewController;
@end

@interface HubsViewController : FatherViewController
/**
 *  分段选择
 */
@property (nonatomic, strong, readonly) UICollectionView *segmentBar;

/**
 *  滑动视图容器
 */
@property (nonatomic, strong, readonly) UIScrollView *slideView;

/**
 *  指示器
 */
@property (nonatomic, strong, readonly) UIView *indicator;

/**
 *  当前选择的index
 */
@property (nonatomic, assign, readonly) NSInteger selectedIndex;

/**
 *  当前选择的viewController
 */
@property (nonatomic, weak,   readonly) UIViewController *selectedViewController;


/**
 *  Child viewControllers of SlideSegmentController
 */
@property (nonatomic,   copy) NSArray *viewControllers;

/**
 *  指示器UIEdgeInsets
 */
@property (nonatomic, assign) UIEdgeInsets indicatorInsets;

/**
 *  item宽度
 */
@property (nonatomic, assign) CGFloat itemWidth;

/**
 *  分段器栏高度
 */
@property (nonatomic, assign) CGFloat segmentBarHeight;


/**
 *  By default segmentBar use viewController's title for segment's button title
 *  You should implement JYSlideSegmentDataSource & JYSlideSegmentDelegate instead of segmentBar delegate & datasource
 */
@property (nonatomic, weak) id <SlideSegmentDelegate> delegate;
@property (nonatomic, weak) id <SlideSegmentDataSource> dataSource;

// - (instancetype)initWithViewControllers:(NSArray *)viewControllers;

- (void)scrollToViewWithIndex:(NSInteger)index animated:(BOOL)animated;

@end
