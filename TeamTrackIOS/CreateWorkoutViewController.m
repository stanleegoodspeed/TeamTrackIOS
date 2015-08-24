//
//  CreateWorkoutViewController.m
//  TeamTrackIOS
//
//  Created by Colin Cole on 8/14/15.
//  Copyright (c) 2015 Colin Cole. All rights reserved.
//

#import "CreateWorkoutViewController.h"

@interface CreateWorkoutViewController ()

@end

@implementation CreateWorkoutViewController

- (id)init
{
    self = [super init];
    if (self) {

        CGRect frame = CGRectMake(0, 0, 400, 44);
        UILabel *label = [[UILabel alloc] initWithFrame:frame];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:21];
        label.textColor = [UIColor blackColor];
        label.text = @"Create Workout";
        [[self navigationItem]setTitleView:label];
        [[self navigationItem]setHidesBackButton:YES];
        
        // Var set
        eventTypes = [[NSMutableArray alloc]init];
        [eventTypes addObject:@"5K"];
        [eventTypes addObject:@"800"];
        [eventTypes addObject:@"400"];
    }
    
    return self;
}

- (void)viewDidLoad {
    
    UIPickerView *myPicker = [[UIPickerView alloc] init];
    myPicker.delegate = self;
    myPicker.dataSource = self;
    myPicker.showsSelectionIndicator = YES;
    self.eventNameInput.inputView = myPicker;
        
    // Add TapRecognizer to auto-close keyboard when clicked outside of zone
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helpers

-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

#pragma mark - IBAction

- (IBAction)nextButtonPressed:(id)sender
{
    NSNumber *coachID = [NSNumber numberWithInt:1]; // ***** FAKE!! - need to change **//
    NSNumber *typeID = [NSNumber numberWithInt:2]; // ***** FAKE!! - need to change **//
    NSString *queryStr = @"postrace";
    
    NSMutableDictionary *dataDictionary = [NSMutableDictionary dictionaryWithCapacity:1];
    [dataDictionary setObject:workoutNameInput.text forKey:@"workoutName"];
    [dataDictionary setObject:self.eventNameInput.text forKey:@"eventName"];
    [dataDictionary setObject:coachID forKey:@"createdBy"];
    [dataDictionary setObject:typeID forKey:@"type"];
    
    PostToServer *postToServer = [PostToServer sharedStore];
    postToServer.delegate = self;
    [postToServer postDataToServer:dataDictionary withQuery:queryStr];
}

#pragma mark - UIPickerViewDataSource
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return eventTypes.count;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [eventTypes objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.eventNameInput.text = [eventTypes objectAtIndex:row];
}

#pragma mark - UITextFieldDelegate

- (BOOL) textFieldShouldBeginEditing:(UITextView *)textView
{
    //[self.eventNameInput becomeFirstResponder];
    return YES;
}

#pragma mark - PostToServer Delegate

- (void)didCompletePost:(BOOL)status withData:(NSString *)data withDict:(NSDictionary *)dataDict
{
    // Receive and set new data
    NSInteger tmp = [data integerValue];
    raceID = [NSNumber numberWithInteger:tmp];
    
    // Push View Controller
    AthleteSelectViewController *athleteSelectViewController = [[AthleteSelectViewController alloc]initWithRaceID:raceID];
    [[self navigationController] pushViewController:athleteSelectViewController animated:YES];
}

#pragma mark - NSURLConnection Delegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSInteger tmp = [dataStr integerValue];
    raceID = [NSNumber numberWithInteger:tmp];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
{
    NSLog(@"finished!");
    AthleteSelectViewController *athleteSelectViewController = [[AthleteSelectViewController alloc]initWithRaceID:raceID];
    [[self navigationController] pushViewController:athleteSelectViewController animated:YES];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"error: %@",[error localizedDescription]);
}


@end
