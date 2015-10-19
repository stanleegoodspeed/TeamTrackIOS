//
//  SplitsViewController.h
//  TeamTrackIOS
//
//  Created by Colin Cole on 8/21/15.
//  Copyright (c) 2015 Colin Cole. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Split.h"
#import "SplitsTableViewCell.h"

@interface SplitsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSArray *splits;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (id)initWithSplits:(NSArray *)mySplits;

@end
