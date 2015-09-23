//
//  ViewController.h
//  TeamTrackIOS
//
//  Created by Colin Cole on 8/3/15.
//  Copyright (c) 2015 Colin Cole. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Timer.h"
#import "Athlete.h"
#import "TimerViewCell.h"
#import "PostToServer.h"
#import "ResultsViewController.h"


@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, TimerDelegate, TimerCellDelegate, PostToServerDelegate>
{
    __weak IBOutlet UIButton *startButton;
    NSURLConnection *connection;
    int counter;
    int splitCount;
    int stopPressedCount;
}


@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSArray *atheletes;
@property (nonatomic, retain) NSMutableArray *timers;
@property (weak, nonatomic) IBOutlet UIButton *viewResultsButton;

- (IBAction)startButtonPressed:(id)sender;

- (id)initWithSelectedAthletes:(NSArray *)selectedAthletes;


@end


