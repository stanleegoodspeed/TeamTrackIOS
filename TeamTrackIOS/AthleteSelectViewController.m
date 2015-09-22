//
//  AthleteSelectViewController.m
//  TeamTrackIOS
//
//  Created by Colin Cole on 8/11/15.
//  Copyright (c) 2015 Colin Cole. All rights reserved.
//

#import "AthleteSelectViewController.h"

@interface AthleteSelectViewController ()

@end

@implementation AthleteSelectViewController

- (id)initWithRaceID:(NSNumber *)race_ID
{
    self = [super init];
    if (self) {
        // Navbar setup
        CGRect frame = CGRectMake(0, 0, 300, 44);
        UILabel *label = [[UILabel alloc] initWithFrame:frame];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:21];
        label.textColor = [UIColor whiteColor];
        label.text = @"Select Athletes";
        [[self navigationItem]setTitleView:label];
        self.navigationItem.hidesBackButton = YES;
        
        //self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        UIBarButtonItem *nextButton = [[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(nextBtnPressed)];
        self.navigationItem.rightBarButtonItem = nextButton;
        
        UIBarButtonItem *backToStartButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(backToStartButtonPressed:)];
        self.navigationItem.leftBarButtonItem = backToStartButton;
        
        // Init
        selectedAthletes = [[NSMutableArray alloc]init];
        selectedAthletesWithID = [[NSMutableArray alloc]init];
        athleteDict = [[NSMutableDictionary alloc]init];
        allAthletes = [[NSMutableArray alloc]init];
        checkedData = [[NSMutableArray alloc]init];
        raceID = race_ID;
        counter = 0;
    }
    
    return self;
}

- (void)viewDidLoad {
    
    // Fetch runner list
    [self fetchData];
        
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return allAthletes.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIden = @"myCell";
    AthleteSelectViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIden];
    Athlete *myAthelete = [allAthletes objectAtIndex:indexPath.row];
    
    if(!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"AthleteSelectViewCell" bundle:nil ]forCellReuseIdentifier:cellIden];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIden];
    }
    
    cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@",myAthelete.firstName, myAthelete.lastName];
    
    return cell;

}

#pragma mark - UITableDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    if (newCell.accessoryType == UITableViewCellAccessoryNone) {
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        [selectedAthletes addObject:[allAthletes objectAtIndex:indexPath.row]];
    }else {
        newCell.accessoryType = UITableViewCellAccessoryNone;
        [selectedAthletes removeObject:[allAthletes objectAtIndex:indexPath.row]];
    }
    
    [self.tableView reloadData];    
}

#pragma mark - IBAction

- (IBAction)nextBtnPressed
{
    NSString *queryStr = @"addAthleteToWorkout";
    NSMutableDictionary *dataDictionary = [NSMutableDictionary dictionaryWithCapacity:1];
    
    for (Athlete *myAthlete in selectedAthletes) {
        
        [dataDictionary setObject:raceID forKey:@"fk_raceID"];
        [dataDictionary setObject:myAthlete.runnerID forKey:@"fk_runnerID"];
        
        //PostToServer *postToServer = [[PostToServer alloc]init];
        PostToServer *postToServer = [PostToServer sharedStore];
        postToServer.delegate = self;
        [postToServer postDataToServer:dataDictionary withQuery:queryStr];
    }
}

- (IBAction)backToStartButtonPressed:(id)sender
{
    [[self navigationController] popToRootViewControllerAnimated:YES];
}
                                              

#pragma mark - PostToServer Delegate

- (void)didCompletePost:(BOOL)status withData:(NSString *)data withDict:(NSDictionary *)dataDict
{
    counter++;
    id myRunnerID = [dataDict valueForKey:@"runnerID"];
    id myRunInRaceID = [dataDict valueForKey:@"runInRaceID"];
    
    Athlete *myAthleteObject = [athleteDict objectForKey:myRunnerID];
    myAthleteObject.runInRaceID = (NSNumber *)myRunInRaceID;
    [selectedAthletesWithID addObject:myAthleteObject];
    
    if(counter == selectedAthletes.count)
    {
        // Push View Controller
        ViewController *timerViewController = [[ViewController alloc] initWithSelectedAthletes:selectedAthletesWithID];
        [[self navigationController] pushViewController:timerViewController animated:YES];
    }
}

#pragma mark - NSURLConnection Delegate

//- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
//{
//    [jsonData appendData:data];
//}
//
//- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
//{
//    NSError *error = nil;
//    NSArray *athleteArray = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
//    
//    for (int i = 0; i < athleteArray.count; i++) {
//        Athlete *myAthlete = [[Athlete alloc]init];
//        myAthlete.firstName = [athleteArray[i] valueForKey:@"firstName"];
//        myAthlete.lastName = [athleteArray[i] valueForKey:@"lastName"];
//        myAthlete.runnerID = [athleteArray[i] valueForKey:@"runnerID"];
//        [allAthletes addObject:myAthlete];
//        [athleteDict setObject:myAthlete forKey:myAthlete.runnerID];
//    }
//    
//    [self.tableView reloadData];
//}
//
//- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
//{
//    NSLog(@"error: %@",[error localizedDescription]);
//}

#pragma mark - Helpers

- (void)fetchData
{
//    jsonData = [[NSMutableData alloc]init];
//    NSURL *url = [NSURL URLWithString:@"http://192.168.1.3:4444/getAthletes/1"];
//    
//    NSURLRequest *req = [NSURLRequest requestWithURL:url];
//    connection = [[NSURLConnection alloc]initWithRequest:req delegate:self startImmediately:YES];
    
    NSString *queryStr = [NSString stringWithFormat:@"%@%i",@"getAthletes/",1]; /*HARDCODED - NEED TO FIX !!!! */
    PostToServer *postToServer = [PostToServer sharedStore];
    postToServer.delegate = self;
    [postToServer getDataFromServer:queryStr];
}

#pragma mark - PostToServer Delegate

- (void)didCompleteGet:(BOOL)status withData:(NSMutableData *)data
{
    NSError *error = nil;
    NSArray *athleteArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    for (int i = 0; i < athleteArray.count; i++) {
        Athlete *myAthlete = [[Athlete alloc]init];
        myAthlete.firstName = [athleteArray[i] valueForKey:@"firstName"];
        myAthlete.lastName = [athleteArray[i] valueForKey:@"lastName"];
        myAthlete.runnerID = [athleteArray[i] valueForKey:@"runnerID"];
        [allAthletes addObject:myAthlete];
        [athleteDict setObject:myAthlete forKey:myAthlete.runnerID];
    }

    [self.tableView reloadData];

}

@end
