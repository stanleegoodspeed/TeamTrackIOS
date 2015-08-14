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

- (id)init
{
    self = [super init];
    if (self) {
        [[self navigationItem]setTitle:@"Stopwatch"];
    }
    
    return self;
}

- (id)initWithSelectedAthletes:(NSArray *)selectedAthletes
{
    self = [super init];
    if (self) {
        self.atheletes = [[NSArray alloc]initWithArray:selectedAthletes];
        [[self navigationItem]setTitle:@"Stopwatch"];
    }
    
    return self;
}

- (void)viewDidLoad {
    
    // Create Timer objects for selected athletes
    [self createTimers];
    
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
    
    //cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
    
    return cell;
}



#pragma mark - IBActions


- (IBAction)startButtonPressed:(id)sender
{
    for (Timer *aTimer in self.timers) {
        [aTimer startTimer];
    }
    
    [self.tableView reloadData];
}

- (IBAction)saveButtonPressed:(id)sender
{
    Athlete *myAthlete = [self.atheletes objectAtIndex:0];
    NSMutableDictionary *projectDictionary = [NSMutableDictionary dictionaryWithCapacity:1];
    [projectDictionary setObject:myAthlete.runInRaceID forKey:@"runInRaceID"];
    [projectDictionary setObject:myAthlete.finishTime forKey:@"finishTime"];
    
    NSError *jsonSerializationError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:projectDictionary options:NSJSONWritingPrettyPrinted error:&jsonSerializationError];
    
    if(!jsonSerializationError) {
        NSString *serJSON = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"Serialized JSON: %@", serJSON);
    } else {
        NSLog(@"JSON Encoding Failed: %@", [jsonSerializationError localizedDescription]);
    }
    
    NSURL *url = [NSURL URLWithString:@"http://himrod.home/~Colin/TeamTrack/api/index.php/postrunnertime"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:90];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody: jsonData];
    
    connection = [[NSURLConnection alloc]initWithRequest:request delegate:self startImmediately:YES];
}

#pragma mark - NSURLConnection Delegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"data str: %@",dataStr);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
{
    NSLog(@"finished!");
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"error: %@",[error localizedDescription]);
}

#pragma mark - Helpers

- (void)createTimers
{
    self.timers = [[NSMutableArray alloc]init];
    
    // Create 5 rows with Athelete and Timer
    for (int i = 0; i < self.atheletes.count; i++) {
        
        Timer *myTimer = [[Timer alloc]init];
        myTimer.delegate = self;
        myTimer.index = i; // used for saving splits later (see saveSplit:)
        [self.timers addObject:myTimer];
    }

}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
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
    [[self.timers objectAtIndex:[[self.tableView indexPathForCell:timerCell] row]] stopTimer];
}

- (void)timerDidPressSplit:(TimerViewCell *)timerCell
{
    [[self.timers objectAtIndex:[[self.tableView indexPathForCell:timerCell] row]] triggerSplit];
}



@end
