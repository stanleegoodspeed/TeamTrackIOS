//
//  ViewController.m
//  TeamTrackIOS
//
//  Created by Colin Cole on 8/3/15.
//  Copyright (c) 2015 Colin Cole. All rights reserved.
//

#import "ViewController.h"
#import "TableViewCell.h"

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
    Athelete *myAthelete = [self.athelets objectAtIndex:indexPath.row];
    
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIden];
    
    if(!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil ]forCellReuseIdentifier:cellIden];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIden];
    }
    
    cell.nameLabel.text = myAthelete.name;
    cell.timeLabel.text = [myTimer getCurrentTime];
    
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
    self.athelets = [[NSMutableArray alloc]init];
    self.timers = [[NSMutableArray alloc]init];
    
    // Create 5 rows with Athelete and Timer
    for (int i = 0; i < 5; i++) {
        
        Athelete *myAthelete = [[Athelete alloc]init];
        myAthelete.name =  [nameStr stringByAppendingString:[NSString stringWithFormat:@"%i", i]];
        [self.athelets addObject:myAthelete];
        
        Timer *myTimer = [[Timer alloc]init];
        [self.timers addObject:myTimer];
    }

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
