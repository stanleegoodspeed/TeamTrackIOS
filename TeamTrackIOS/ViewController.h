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


@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, TimerDelegate, TimerCellDelegate, NSURLConnectionDelegate>
{
    
    __weak IBOutlet UIButton *saveButton;
    NSURLConnection *connection;
}


@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIButton *startButton;
@property (nonatomic, retain) NSArray *atheletes;
@property (nonatomic, retain) NSMutableArray *timers;

- (IBAction)startButtonPressed:(id)sender;
- (IBAction)saveButtonPressed:(id)sender;


- (id)initWithSelectedAthletes:(NSArray *)selectedAthletes;


@end


