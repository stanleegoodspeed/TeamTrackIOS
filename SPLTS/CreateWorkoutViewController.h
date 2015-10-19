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
#import "Dropdown.h"

@interface CreateWorkoutViewController : UIViewController <NSURLConnectionDelegate,PostToServerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>
{
    
    __weak IBOutlet UIButton *nextBtn;
    __weak IBOutlet UITextField *workoutNameInput;
    
    NSURLConnection *connection;
    NSNumber *raceID;
    NSMutableArray *eventList;
    NSMutableArray *typeList;
    NSMutableArray *currentList;
    UITextField *currentTextField;
    NSNumber *eventPickedVal;
    NSNumber *typePickedVal;
}

@property (strong, nonatomic) IBOutlet UITextField *eventNameInput;
@property (strong, nonatomic) IBOutlet UITextField *typeNameInput;
@property (strong, nonatomic) UIPickerView *pickerView;

- (IBAction)nextButtonPressed:(id)sender;

@end
