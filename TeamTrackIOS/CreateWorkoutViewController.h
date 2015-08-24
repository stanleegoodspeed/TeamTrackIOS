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

@interface CreateWorkoutViewController : UIViewController <NSURLConnectionDelegate,PostToServerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>
{
    
    __weak IBOutlet UIButton *nextBtn;
    __weak IBOutlet UITextField *workoutNameInput;
    __weak IBOutlet UITextField *typeInput;
    
    NSURLConnection *connection;
    NSNumber *raceID;
    NSMutableArray *eventTypes;
}

@property (weak, nonatomic) IBOutlet UITextField *eventNameInput;
@property (weak, nonatomic) UIActionSheet *actionSheet;

- (IBAction)nextButtonPressed:(id)sender;

@end
