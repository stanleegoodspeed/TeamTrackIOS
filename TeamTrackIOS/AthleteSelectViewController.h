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
#import "PostToServer.h"

@interface AthleteSelectViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSURLConnectionDelegate, PostToServerDelegate>
{
    __weak IBOutlet UIButton *nextButton;
    
    NSMutableData *jsonData;
    NSURLConnection *connection;
    NSNumber *raceID;
    
    int counter;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *allAthletes;
@property (nonatomic, retain) NSMutableArray *selectedAthletes;

- (IBAction)nextBtnPressed:(id)sender;

- (id)initWithRaceID:(NSNumber *)raceID;

@end
