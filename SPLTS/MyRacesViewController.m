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
#import "KeychainWrapper.h"

@interface MyRacesViewController ()

@end

@implementation MyRacesViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Navbar setup
        NSString *titleText = @"My Races";
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
    
    // Pull userID from keychain
    KeychainWrapper *keychainItem = [[KeychainWrapper alloc] init];
    NSNumber *userID = [keychainItem myObjectForKey:(__bridge id)(kSecAttrService)];
    
    NSString *queryStr = [NSString stringWithFormat:@"%@%@",@"getWorkoutsCoach/",userID];
    
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
    NSString *queryStr = [NSString stringWithFormat:@"%@%i",@"getAthletesWithSplits/",[myRace.raceID intValue]];
    PostToServer *postToServer = [PostToServer sharedStore];
    postToServer.delegate = self;
    [postToServer getDataFromServer:queryStr];

}

- (IBAction)backToStartButtonPressed:(id)sender
{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}


#pragma mark - PostToServer Delegate

- (void)didCompleteGet:(NSDictionary *)data
{
    // Fetch Races
    if(flag)
    {
        for(NSDictionary *myDict in data)
        {
            Race *myRace = [[Race alloc]init];
            myRace.raceID = [myDict valueForKey:@"raceID"];
            myRace.raceName = [myDict valueForKey:@"raceName"];
            myRace.raceDate = [myDict valueForKey:@"raceDate"];
            [allRaces addObject:myRace];
        }

        [self.tableView reloadData];
    }
    // Fetch Runners
    else
    {
        // Loop through all dictionary entries and extract all of the runInRaceID's (there will be dups, that is ok)
        NSMutableArray *matches = [[NSMutableArray alloc]init];
        for(NSDictionary *myDict in data)
        {
            [matches addObject:[myDict valueForKey: @"runInRaceID"]];
        }
        
        // Get unique set of runInRaceIDs from the extracted set
        NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:matches];
        NSSet *uniqueStates = [orderedSet set];
        
        // Iterate through unique set of IDs, pulling out the individual split times
        for (NSString *match in uniqueStates) {
            Athlete *myAthlete = [[Athlete alloc]init];
            NSMutableArray *localSplits = [[NSMutableArray alloc]init];
            for(NSDictionary *myDict in data) {
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
