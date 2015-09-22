//
//  MyRacesViewController.m
//  TeamTrackIOS
//
//  Created by Colin Cole on 8/21/15.
//  Copyright (c) 2015 Colin Cole. All rights reserved.
//

#import "MyRacesViewController.h"
#import "RacesTableViewCell.h"
#import "Race.h"
#import "ResultsViewController.h"

@interface MyRacesViewController ()

@end

@implementation MyRacesViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Navbar setup
        CGRect frame = CGRectMake(0, 0, 400, 44);
        UILabel *label = [[UILabel alloc] initWithFrame:frame];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:21];
        label.textColor = [UIColor whiteColor];
        label.text = @"My Races";
        [[self navigationItem]setTitleView:label];
        
        allRaces = [[NSMutableArray alloc]init];
        myAthletes = [[NSMutableArray alloc]init];
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [self fetchRaces];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return allRaces.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIden = @"myCell";
    RacesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIden];
    Race *myRace = [allRaces objectAtIndex:indexPath.row];
    
    if(!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"RacesTableViewCell" bundle:nil ]forCellReuseIdentifier:cellIden];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIden];
    }
    
    cell.raceNameLabel.text = myRace.raceName;
    cell.raceDateLabel.text = myRace.raceDate;
    
    return cell;
}

#pragma mark -UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self fetchRunnersForRace:indexPath.row];
}


#pragma mark - Helpers

- (void)fetchRaces
{
    // Flag used for PostToServer delegate
    flag = TRUE;
    
    // *** HARDCODED CoachID *** // need to change!
    NSString *queryStr = [NSString stringWithFormat:@"%@%i",@"getWorkoutsCoach/",1];
    
    PostToServer *postToServer = [PostToServer sharedStore];
    postToServer.delegate = self;
    [postToServer getDataFromServer:queryStr];
}

- (void)fetchRunnersForRace:(NSInteger)index
{
    // Flag used for PostToServer delegate
    flag = FALSE;
    
    Race *myRace = [allRaces objectAtIndex:index];
    
    // Get Runners Per Race
    NSString *queryStr = [NSString stringWithFormat:@"%@%i",@"getrunnerswithsplits/",[myRace.raceID intValue]];
    PostToServer *postToServer = [PostToServer sharedStore];
    postToServer.delegate = self;
    [postToServer getDataFromServer:queryStr];

}


#pragma mark - PostToServer Delegate

- (void)didCompleteGet:(BOOL)status withData:(NSMutableData *)data
{
    NSError *error = nil;
    NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    // Fetch Races
    if(flag)
    {
        for (int i = 0; i < dataArray.count; i++) {
            Race *myRace = [[Race alloc]init];
            myRace.raceID = [dataArray[i] valueForKey:@"raceID"];
            myRace.raceName = [dataArray[i] valueForKey:@"raceName"];
            myRace.raceDate = [dataArray[i] valueForKey:@"raceDate"];
            [allRaces addObject:myRace];
        }
        
        [self.tableView reloadData];
    }
    // Fetch Runners
    else
    {
        // Get unique set of RunInRaceIDs
        NSArray *matches = [dataArray valueForKey: @"runInRaceID"];
        NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:matches];
        NSSet *uniqueStates = [orderedSet set];
        
        // Iterate through unique set of IDs, pulling out the individual split times
        for (NSString *match in uniqueStates) {
            // Var init
            Athlete *myAthlete = [[Athlete alloc]init];
            NSMutableArray *localSplits = [[NSMutableArray alloc]init];
            
            for (NSDictionary *myDict in dataArray) {
                if([myDict valueForKey:@"runInRaceID"] == match)
                {
                    // Set general properties (try to move this outside of inner loop)
                    myAthlete.firstName = [myDict valueForKey:@"firstName"];
                    myAthlete.lastName = [myDict valueForKey:@"lastName"];
                    myAthlete.runInRaceID = [myDict valueForKey:@"runInRaceID"];
                    myAthlete.finishTime = [myDict valueForKey:@"finishTime"];
                    
                    // Build splits objects
                    Split *mySplit = [[Split alloc]init];
                    mySplit.splitNumber = [myDict valueForKey:@"splitIndex"];
                    mySplit.splitTime = [myDict valueForKey:@"splitTime"];
                    [localSplits addObject:mySplit];
                    
                }
            }
            
            // Add complete Athlete object to holding array
            myAthlete.splits = localSplits;
            [myAthletes addObject:myAthlete];
        }
        
        // Call ResultViewController
        ResultsViewController *resultsViewController = [[ResultsViewController alloc]initWithAthletes:myAthletes];
        [[self navigationController] pushViewController:resultsViewController animated:YES];

    }
}



@end
