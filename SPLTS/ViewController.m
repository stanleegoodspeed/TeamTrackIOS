//
//  ViewController.m
//  TeamTrackIOS
//
//  Created by Colin Cole on 8/3/15.
//  Copyright (c) 2015 Colin Cole. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (id)initWithSelectedAthletes:(NSArray *)selectedAthletes
{
    self = [super init];
    if (self) {
        
        NSString *titleText = @"Stopwatch";
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
        
        UIBarButtonItem *saveButton= [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonPressed:)];
        self.navigationItem.rightBarButtonItem = saveButton;
        
        UIBarButtonItem *backToStartButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"home_icon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToStartButtonPressed:)];
        self.navigationItem.leftBarButtonItem = backToStartButton;
        
        // Var init
        self.atheletes = [[NSArray alloc]initWithArray:selectedAthletes];
        counter = 0;
        stopPressedCount = 0;
    }
    
    return self;
}

- (void)viewDidLoad {
    
    // Create Timer objects for selected athletes
    [self createTimers];
    
    // Disable tableView until user pressses start
    self.tableView.userInteractionEnabled = FALSE;

    // Disable the save button until all stop buttons have been pressed
    self.navigationItem.rightBarButtonItem.enabled = FALSE;
    self.navigationItem.leftBarButtonItem.enabled = FALSE;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.timers.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIden = @"myCell";
    Timer *myTimer = [self.timers objectAtIndex:indexPath.row];
    Athlete *myAthelete = [self.atheletes objectAtIndex:indexPath.row];
    
    TimerViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIden];
    cell.delegate = self;
    
    if(!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"TimerViewCell" bundle:nil ]forCellReuseIdentifier:cellIden];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIden];
    }
    
    cell.nameLabel.text = myAthelete.firstName;
    cell.timeLabel.text = [myTimer getCurrentTime];
    cell.tag = indexPath.row;
    
    return cell;
}



#pragma mark - IBActions

- (IBAction)startButtonPressed:(id)sender
{
    // disable start button once pressed
    startButton.userInteractionEnabled = FALSE;
    startButton.backgroundColor = [UIColor grayColor];
    
    // Enable tableview
    self.tableView.userInteractionEnabled = TRUE;
    
    for (Timer *aTimer in self.timers) {
        [aTimer startTimer];
    }
    
    [self.tableView reloadData];
}

- (IBAction)backToStartButtonPressed:(id)sender
{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Are you sure you want to go Home?"
                                  message:@"You are in the middle of a workout and have not not saved the results yet."
                                  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"Yes"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [self dismissViewControllerAnimated:YES completion:nil];
                             [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
                         }];
    [alert addAction:ok];
    UIAlertAction* no = [UIAlertAction
                         actionWithTitle:@"Cancel"
                         style:UIAlertActionStyleCancel
                         handler:^(UIAlertAction * action)
                         {
                             [self dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    [alert addAction:no];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (IBAction)saveButtonPressed:(id)sender
{
    splitCount = 0; // used to get total count of all splits stored - used in didCompletePost()
    
    for (Athlete *myAthlete in self.atheletes) {
        
        // Save finishTime
        NSString *queryStr = @"postWorkoutTime";
        NSMutableDictionary *dataDictionary = [NSMutableDictionary dictionaryWithCapacity:1];
        [dataDictionary setObject:myAthlete.runInRaceID forKey:@"runInRaceID"];
        [dataDictionary setObject:myAthlete.finishTime forKey:@"finishTime"];
        
        //PostToServer *postToServer = [[PostToServer alloc]init];
        PostToServer *postToServer = [PostToServer sharedStore];
        postToServer.delegate = self;
        [postToServer postDataToServer:dataDictionary withQuery:queryStr];
        
        // For each athlete, save all splits
        for (Split *mySplit in myAthlete.splits) {
            splitCount++;
            NSString *queryStr2 = @"postSplit";
            NSMutableDictionary *dataDictionary2 = [NSMutableDictionary dictionaryWithCapacity:1];
            [dataDictionary2 setObject:myAthlete.runInRaceID forKey:@"fk_runInRaceID"];
            [dataDictionary2 setObject:mySplit.splitNumber forKey:@"splitNumber"];
            [dataDictionary2 setObject:mySplit.splitTime forKey:@"splitTime"];
            
            [postToServer postDataToServer:dataDictionary2 withQuery:queryStr2];
        }
    }
}


#pragma mark - Helpers

- (void)createTimers
{
    self.timers = [[NSMutableArray alloc]init];

    for (int i = 0; i < self.atheletes.count; i++) {
        
        Timer *myTimer = [[Timer alloc]init];
        myTimer.delegate = self;
        myTimer.index = i; // used for saving splits later (see saveSplit:)
        [self.timers addObject:myTimer];
    }

}

#pragma mark - PostToServer Delegate

- (void)didCompletePost:(NSDictionary *)dataDict
{
    counter ++;
    if(counter == (splitCount + self.atheletes.count))
    {
        // Push View Controller
        ResultsViewController *resultsViewController = [[ResultsViewController alloc]initWithAthletes:self.atheletes];
        [[self navigationController] pushViewController:resultsViewController animated:YES];
    }
}

#pragma mark - Timer Delegate

- (void)timerDidUpdate:(Timer *)timer
{
    [self.tableView reloadData];
}

- (void)saveSplit:(Timer *)timer withObject:(Split *)split
{
    // Save split object to athelete split array
    [[[self.atheletes objectAtIndex:timer.index] splits] addObject:split];
}

- (void)saveFinishTime:(Timer *)timer withFinishTime:(NSTimeInterval)finishTime
{
    NSNumber *tmpNumber = [[NSNumber alloc]initWithDouble:finishTime];
    [[self.atheletes objectAtIndex:timer.index] setFinishTime:tmpNumber];
}

#pragma mark - Timer Cell Delegate

- (void)timerDidPressStop:(TimerViewCell *)timerCell
{
    stopPressedCount++;
    [[self.timers objectAtIndex:[[self.tableView indexPathForCell:timerCell] row]] stopTimer];
    if(stopPressedCount == self.timers.count)
    {
        // all timers have stopped, save button should now be available
        self.navigationItem.rightBarButtonItem.enabled = TRUE;
        self.navigationItem.leftBarButtonItem.enabled = TRUE;
    }
}

- (void)timerDidPressSplit:(TimerViewCell *)timerCell
{
    [[self.timers objectAtIndex:[[self.tableView indexPathForCell:timerCell] row]] triggerSplit:TRUE];
}



@end
