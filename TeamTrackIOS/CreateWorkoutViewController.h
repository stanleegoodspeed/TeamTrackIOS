//
//  CreateWorkoutViewController.h
//  TeamTrackIOS
//
//  Created by Colin Cole on 8/14/15.
//  Copyright (c) 2015 Colin Cole. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AthleteSelectViewController.h"
#import "PostToServer.h"

@interface CreateWorkoutViewController : UIViewController <NSURLConnectionDelegate,PostToServerDelegate>
{
    
    __weak IBOutlet UIButton *nextBtn;
    __weak IBOutlet UITextField *workoutNameInput;
    __weak IBOutlet UITextField *eventNameInput;
    
    NSURLConnection *connection;
    NSNumber *raceID;
}

- (IBAction)nextButtonPressed:(id)sender;

@end
