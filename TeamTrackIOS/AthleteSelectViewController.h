//
//  AthleteSelectViewController.h
//  TeamTrackIOS
//
//  Created by Colin Cole on 8/11/15.
//  Copyright (c) 2015 Colin Cole. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Athlete.h"
#import "AthleteSelectViewCell.h"
#import "ViewController.h"

@interface AthleteSelectViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSURLConnectionDelegate>
{
    __weak IBOutlet UIButton *nextBtn;
    __weak IBOutlet UIButton *fetchButton;
    
    NSMutableData *jsonData;
    NSURLConnection *connection;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *allAthletes;
@property (nonatomic, retain) NSMutableArray *selectedAthletes;

- (IBAction)nextBtnPressed:(id)sender;
- (IBAction)fetchData:(id)sender;

@end
