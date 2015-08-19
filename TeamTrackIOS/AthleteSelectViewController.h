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
    //__weak IBOutlet UIButton *nextButton;
    int counter;
    
    NSMutableData *jsonData;
    NSURLConnection *connection;
    NSNumber *raceID;
    NSMutableArray *selectedAthletesWithID;
    NSMutableDictionary *athleteDict;
    NSMutableArray *selectedAthletes;
    NSMutableArray *allAthletes;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (id)initWithRaceID:(NSNumber *)raceID;

@end
