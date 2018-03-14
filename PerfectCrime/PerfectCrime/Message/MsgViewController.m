//
//  DiscoveryViewController.m
//  PerfectCrime
//
//  Created by 刘亚夫 on 2017/6/14.
//  Copyright © 2017年 com.agency. All rights reserved.
//

#import "MsgViewController.h"

@interface MsgViewController ()

@end

@implementation MsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [CustomColorRGB colorWithHexString:viewBackgroundColor];
    
    [self.navigationItem setItemWithTitle:CustomLocalizedString(@"消息", nil) textColor:[CustomColorRGB colorWithHexString:kNavColor] fontSize:18 itemType:center];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
