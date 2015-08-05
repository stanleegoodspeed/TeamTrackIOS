//
//  ViewController.h
//  TeamTrackIOS
//
//  Created by Colin Cole on 8/3/15.
//  Copyright (c) 2015 Colin Cole. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Timer.h"
#import "Athelete.h"


@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    
}


@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIButton *startButton;
@property (nonatomic, retain) NSMutableArray *athelets;
@property (nonatomic, retain) NSMutableArray *timers;

- (IBAction)startButtonPressed:(id)sender;
- (IBAction)updateButtonPressed:(id)sender;


@end


