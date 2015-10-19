//
//  CreateWorkoutViewController.m
//  TeamTrackIOS
//
//  Created by Colin Cole on 8/14/15.
//  Copyright (c) 2015 Colin Cole. All rights reserved.
//

#import "CreateWorkoutViewController.h"
#import "KeychainWrapper.h"

@interface CreateWorkoutViewController ()

@end

@implementation CreateWorkoutViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Set and center title
        NSString *titleText = @"Create Workout";
        UIFont* titleFont = [UIFont fontWithName:@"Helvetica" size:30];
        CGSize requestedTitleSize = [titleText sizeWithAttributes:@{NSFontAttributeName: titleFont}];
        CGFloat titleWidth = MIN(400, requestedTitleSize.width);
        CGRect frame = CGRectMake(0, 0, titleWidth, 44);
        UILabel *label = [[UILabel alloc] initWithFrame:frame];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:21];
        label.textColor = [UIColor whiteColor];
        label.text = titleText;
        [[self navigationItem]setTitleView:label];
        
        UIBarButtonItem *backToStartButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"home_icon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToStartButtonPressed:)];
        self.navigationItem.leftBarButtonItem = backToStartButton;

        
    }
    
    return self;
}

- (void)viewDidLoad {
    
    // init arrays for picker
    //eventList = [[NSMutableArray alloc]init];
    
    self.pickerView = [[UIPickerView alloc] init];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.pickerView.showsSelectionIndicator = YES;
    self.eventNameInput.inputView = self.pickerView;
    self.eventNameInput.delegate = self;
    self.typeNameInput.delegate = self;
    self.typeNameInput.inputView = self.pickerView;
    
    eventList = [[NSMutableArray alloc]init];
    typeList = [[NSMutableArray alloc]init];

    
   
    
    // Add TapRecognizer to auto-close keyboard when clicked outside of zone
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    workoutNameInput.layer.cornerRadius=8.0f;
    workoutNameInput.layer.masksToBounds=YES;
    workoutNameInput.layer.borderColor=[[UIColor whiteColor]CGColor];
    workoutNameInput.layer.borderWidth= 1.0f;
    
    self.eventNameInput.layer.cornerRadius=8.0f;
    self.eventNameInput.layer.masksToBounds=YES;
    self.eventNameInput.layer.borderColor=[[UIColor whiteColor]CGColor];
    self.eventNameInput.layer.borderWidth= 1.0f;
    
    self.typeNameInput.layer.cornerRadius=8.0f;
    self.typeNameInput.layer.masksToBounds=YES;
    self.typeNameInput.layer.borderColor=[[UIColor whiteColor]CGColor];
    self.typeNameInput.layer.borderWidth= 1.0f;
    
    nextBtn.layer.cornerRadius=8.0f;
    nextBtn.layer.masksToBounds=YES;
    nextBtn.layer.borderColor=[[UIColor whiteColor]CGColor];
    nextBtn.layer.borderWidth= 1.0f;

    // Build dropdown picker
    [self fetchTypes];

    [self fetchEvents];
    
    
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

- (void)fetchEvents
{
    NSString *queryStr = @"getEvents";
    PostToServer *postToServer = [PostToServer sharedStore];
    postToServer.delegate = self;
    [postToServer getDataFromServer:queryStr];
}

- (void)fetchTypes
{
    NSString *queryStr = @"getTypes";
    PostToServer *postToServer = [PostToServer sharedStore];
    postToServer.delegate = self;
    [postToServer getDataFromServer:queryStr];
}

- (IBAction)backToStartButtonPressed:(id)sender
{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    //[[self navigationController] popToRootViewControllerAnimated:YES];
}

#pragma mark - IBAction

- (IBAction)nextButtonPressed:(id)sender
{
    if(workoutNameInput.text.length == 0 || eventPickedVal == nil || typePickedVal == nil)
    {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Whoops!"
                                      message:@"Workout Name, Event, and Type are required fields."
                                      preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [self dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        [alert addAction:ok];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
    // Pull userID from keychain
    KeychainWrapper *keychainItem = [[KeychainWrapper alloc] init];
    NSNumber *userID = [keychainItem myObjectForKey:(__bridge id)(kSecAttrService)];
    
    NSString *queryStr = @"createWorkout";
    
    NSMutableDictionary *dataDictionary = [NSMutableDictionary dictionaryWithCapacity:1];
    [dataDictionary setObject:workoutNameInput.text forKey:@"raceName"];
    [dataDictionary setObject:eventPickedVal forKey:@"fk_eventID"];
    [dataDictionary setObject:userID forKey:@"createdBy"];
    [dataDictionary setObject:typePickedVal forKey:@"fk_typeID"];
    
    PostToServer *postToServer = [PostToServer sharedStore];
    postToServer.delegate = self;
    [postToServer postDataToServer:dataDictionary withQuery:queryStr];
    }
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
    return currentList.count;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[currentList objectAtIndex:row] myDescription];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(currentTextField == self.eventNameInput)
    {
        self.eventNameInput.text = [[currentList objectAtIndex:row] myDescription];
        eventPickedVal = [[currentList objectAtIndex:row] myCode];
    }
    else
    {
        self.typeNameInput.text = [[currentList objectAtIndex:row] myDescription];
        typePickedVal = [[currentList objectAtIndex:row] myCode];
    }
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
{
    currentTextField = textField;
    if (textField == self.eventNameInput)
    {
        //[self.eventNameInput becomeFirstResponder];
        currentList = eventList;
        [self.pickerView reloadAllComponents];
        //[self animatePickerViewIn];
        //return NO;
    }
    else if(textField == self.typeNameInput)
    {
        //[self.typeNameInput becomeFirstResponder];
        currentList = typeList;
        [self.pickerView reloadAllComponents];
        //[self animatePickerViewIn];
        //return NO;
    }
    
    return YES;
}

#pragma mark - PostToServer Delegate

- (void)didCompletePost:(NSDictionary *)dataDict
{
    // Receive and set new data
    NSInteger tmp = [[dataDict objectForKey:@"insertId"] intValue];
    raceID = [NSNumber numberWithInteger:tmp];
    
    
    // Push View Controller
    AthleteSelectViewController *athleteSelectViewController = [[AthleteSelectViewController alloc]initWithRaceID:raceID];
    [[self navigationController] pushViewController:athleteSelectViewController animated:YES];
}

- (void)didCompleteGet:(NSDictionary *)data
{
    NSMutableArray *localDropdownArr = [[NSMutableArray alloc]init];
    NSArray *tmpArr = [data valueForKey:@"data"];
    
    for (int i = 0; i < tmpArr.count; i++) {
        Dropdown *myDropdown = [[Dropdown alloc]init];
        myDropdown.myCode = [tmpArr[i] valueForKey:@"myCode"];
        myDropdown.myDescription = [tmpArr[i] valueForKey:@"myDescription"];
        [localDropdownArr addObject:myDropdown];
    }
    
    if([[data valueForKey:@"message"] isEqualToString:@"Events"])
    {
        eventList = localDropdownArr;
    }
    else
    {
        typeList = localDropdownArr;
    }
}



@end
