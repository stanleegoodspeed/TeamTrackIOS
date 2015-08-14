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

- (id)init
{
    self = [super init];
    if (self) {
        // Navbar setup
        [[self navigationItem]setTitle:@"Select Athletes"];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        
        // Init
        self.selectedAthletes = [[NSMutableArray alloc]init];
    }
    
    return self;
}

- (void)viewDidLoad {
    
    // Test
    //[self test_populateArray];
    [self fetchData:nil];
        
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
    return self.allAthletes.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIden = @"myCell";
    AthleteSelectViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIden];
    Athlete *myAthelete = [self.allAthletes objectAtIndex:indexPath.row];
    
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
    [self.selectedAthletes addObject:[self.allAthletes objectAtIndex:indexPath.row]];
}

#pragma mark - IBAction

- (IBAction)nextBtnPressed:(id)sender
{
    ViewController *timerViewController = [[ViewController alloc] initWithSelectedAthletes:self.selectedAthletes];
    [[self navigationController] pushViewController:timerViewController animated:YES];
}

- (IBAction)fetchData:(id)sender
{
    jsonData = [[NSMutableData alloc]init];
    NSURL *url = [NSURL URLWithString:@"http://himrod.home/~Colin/TeamTrack/api/index.php/getrunners"];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    connection = [[NSURLConnection alloc]initWithRequest:req delegate:self startImmediately:YES];
}

#pragma mark - NSURLConnection Delegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [jsonData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
{
    self.allAthletes = [[NSMutableArray alloc]init];
    NSError *error = nil;
    NSArray *athleteArray = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    
    for (int i = 0; i < athleteArray.count; i++) {
        Athlete *myAthlete = [[Athlete alloc]init];
        myAthlete.firstName = [athleteArray[i] valueForKey:@"firstName"];
        myAthlete.lastName = [athleteArray[i] valueForKey:@"lastName"];
        //myAthlete.runInRaceID = [athleteArray[i] valueForKey:@"runnerID"];
        myAthlete.runInRaceID = [NSNumber numberWithInt:3]; // NEEDS TO BE CHANGED!!!!! 8/13/15
        [self.allAthletes addObject:myAthlete];
    }
    
    [self.tableView reloadData];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"error: %@",[error localizedDescription]);
}

#pragma mark - Helpers


- (void)test_populateArray
{
    self.allAthletes = [[NSMutableArray alloc]init];
    
    // Create 5 rows with Athelete and Timer
    for (int i = 0; i < 5; i++) {
        
        Athlete *myAthelete = [[Athlete alloc]init];
        //myAthelete.name =  [nameStr stringByAppendingString:[NSString stringWithFormat:@"%i", i]];
        [self.allAthletes addObject:myAthelete];
    }
    
}

@end
