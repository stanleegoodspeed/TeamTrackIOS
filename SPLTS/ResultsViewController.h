//
//  ResultsViewController.h
//  TeamTrackIOS
//
//  Created by Colin Cole on 8/17/15.
//  Copyright (c) 2015 Colin Cole. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResultParentViewCell.h"
#import "Athlete.h"
#import "SplitsViewController.h"

@interface ResultsViewController : UIViewController <UITableViewDataSource, UITableViewDataSource>
{
    NSArray *athletes;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
//@property (strong, nonatomic) NSMutableArray *expandedCells;

- (id)initWithAthletes:(NSArray *)athletes;

@end
