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
        [[self navigationItem]setTitle:@"Select Athletes"];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        
        // Init
        selectedAthletes = [[NSMutableArray alloc]init];
        selectedAthletesWithID = [[NSMutableArray alloc]init];
        athleteDict = [[NSMutableDictionary alloc]init];
        allAthletes = [[NSMutableArray alloc]init];
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
    
    cell.nameLabel.text = myAthelete.firstName;
    
    return cell;

}

#pragma mark - UITableDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Add selection to array
    [selectedAthletes addObject:[allAthletes objectAtIndex:indexPath.row]];
}

#pragma mark - IBAction

- (IBAction)nextBtnPressed:(id)sender
{
    NSURL *url = [NSURL URLWithString:@"http://himrod.home/~Colin/TeamTrack/api/index.php/postrunnerinrace"];
    NSMutableDictionary *dataDictionary = [NSMutableDictionary dictionaryWithCapacity:1];
    
    for (Athlete *myAthlete in selectedAthletes) {
        
        [dataDictionary setObject:raceID forKey:@"fkRaceID"];
        [dataDictionary setObject:myAthlete.runnerID forKey:@"fkRunnerID"];
        
        //PostToServer *postToServer = [[PostToServer alloc]init];
        PostToServer *postToServer = [PostToServer sharedStore];
        postToServer.delegate = self;
        [postToServer postDataToServer:dataDictionary withURL:url];
    }
}

#pragma mark - PostToServer Delegate

- (void)didCompletePost:(BOOL)status withData:(NSString *)data withDict:(NSDictionary *)dataDict
{
    counter++;
    NSLog(@"data string is: %@", data);
    id myRunnerID = [dataDict valueForKey:@"runnerID"];
    id myRunInRaceID = [dataDict valueForKey:@"runInRaceID"];
    
    Athlete *myAthleteObject = [athleteDict valueForKey:myRunnerID];
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

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [jsonData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
{
    NSError *error = nil;
    NSArray *athleteArray = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    
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

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"error: %@",[error localizedDescription]);
}

#pragma mark - Helpers

- (void)fetchData
{
    jsonData = [[NSMutableData alloc]init];
    NSURL *url = [NSURL URLWithString:@"http://himrod.home/~Colin/TeamTrack/api/index.php/getrunners"];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    connection = [[NSURLConnection alloc]initWithRequest:req delegate:self startImmediately:YES];
}

- (void)test_populateArray
{
    
    
    // Create 5 rows with Athelete and Timer
    for (int i = 0; i < 5; i++) {
        
        Athlete *myAthelete = [[Athlete alloc]init];
        //myAthelete.name =  [nameStr stringByAppendingString:[NSString stringWithFormat:@"%i", i]];
        [allAthletes addObject:myAthelete];
    }
    
}

@end
