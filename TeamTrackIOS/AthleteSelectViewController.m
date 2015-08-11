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

- (void)viewDidLoad {
    
    // Test
    [self test_populateArray];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
    Athelete *myAthelete = [self.allAthletes objectAtIndex:indexPath.row];
    
    if(!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"AthleteSelectViewCell" bundle:nil ]forCellReuseIdentifier:cellIden];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIden];
    }
    
    cell.nameLabel.text = myAthelete.name;
    
    return cell;

}

#pragma mark - IBAction

- (IBAction)nextBtnPressed:(id)sender
{
    ViewController *timerViewController = [[ViewController alloc] init];
    [[self navigationController] pushViewController:timerViewController animated:YES];
}


#pragma mark - Helpers


- (void)test_populateArray
{
    NSString *nameStr = @"Johnny ";
    self.allAthletes = [[NSMutableArray alloc]init];
    
    // Create 5 rows with Athelete and Timer
    for (int i = 0; i < 5; i++) {
        
        Athelete *myAthelete = [[Athelete alloc]init];
        myAthelete.name =  [nameStr stringByAppendingString:[NSString stringWithFormat:@"%i", i]];
        [self.allAthletes addObject:myAthelete];
    }
    
}

@end
