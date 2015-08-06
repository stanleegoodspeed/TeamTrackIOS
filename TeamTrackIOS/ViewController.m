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
    return self.timers.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIden = @"myCell";
    Timer *myTimer = [self.timers objectAtIndex:indexPath.row];
    Athelete *myAthelete = [self.atheletes objectAtIndex:indexPath.row];
    
    TimerViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIden];
    cell.delegate = self;
    
    if(!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"TimerViewCell" bundle:nil ]forCellReuseIdentifier:cellIden];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIden];
    }
    
    cell.nameLabel.text = myAthelete.name;
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

- (IBAction)updateButtonPressed:(id)sender
{
    [self.tableView reloadData];
}


#pragma mark - Helpers


- (void)test_populateArray
{
    NSString *nameStr = @"Colin ";
    self.atheletes = [[NSMutableArray alloc]init];
    self.timers = [[NSMutableArray alloc]init];
    
    // Create 5 rows with Athelete and Timer
    for (int i = 0; i < 5; i++) {
        
        Athelete *myAthelete = [[Athelete alloc]init];
        myAthelete.name =  [nameStr stringByAppendingString:[NSString stringWithFormat:@"%i", i]];
        [self.atheletes addObject:myAthelete];
        
        Timer *myTimer = [[Timer alloc]init];
        myTimer.delegate = self;
        [self.timers addObject:myTimer];
    }

}

#pragma mark - Timer Delegate

- (void)timerDidUpdate:(Timer *)timer
{
    [self.tableView reloadData];
}

- (void)splitTrigger:(Timer *)timer
{
    
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
