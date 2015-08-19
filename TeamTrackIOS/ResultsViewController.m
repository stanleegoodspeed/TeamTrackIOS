//
//  ResultsViewController.m
//  TeamTrackIOS
//
//  Created by Colin Cole on 8/17/15.
//  Copyright (c) 2015 Colin Cole. All rights reserved.
//

#import "ResultsViewController.h"

@interface ResultsViewController ()

@end

@implementation ResultsViewController

- (id)init
{
    self = [super init];
    if (self) {
        [[self navigationItem]setTitle:@"Results"];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        self.expandedCells = [[NSMutableArray alloc]init];
    }
    
    return self;
}

- (id)initWithAthletes:(NSArray *)myAthletes
{
    self = [super init];
    if (self) {
        [[self navigationItem]setTitle:@"Results"];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        self.expandedCells = [[NSMutableArray alloc]init];
        athletes = [[NSArray alloc]initWithArray:myAthletes];
    }
    
    return self;
}

- (void)viewDidLoad {
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
    return athletes.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIden = @"myCell";
    ResultParentViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIden];
    Athlete *myAthelete = [athletes objectAtIndex:indexPath.row];
    
    if(!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"ResultParentViewCell" bundle:nil ]forCellReuseIdentifier:cellIden];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIden];
    }
    
    double elapsed = [myAthelete.finishTime doubleValue];
    int mins = (int) (elapsed / 60.0);
    elapsed -= mins * 60;
    int secs = (int) (elapsed);
    elapsed -= secs;
    int fraction = elapsed * 10.0;
    
    cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@",myAthelete.firstName, myAthelete.lastName];
    cell.finishTimeLabel.text = [NSString stringWithFormat:@"%u:%02u.%u",mins,secs,fraction];
    
    return cell;
    
}


#pragma mark - UITableDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.expandedCells containsObject:indexPath])
    {
        [self.expandedCells removeObject:indexPath];
    }
    else
    {
        [self.expandedCells addObject:indexPath];
    }
    [tableView beginUpdates];
    [tableView endUpdates];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat kExpandedCellHeight = 150;
    CGFloat kNormalCellHeigh = 50;
    
    if ([self.expandedCells containsObject:indexPath])
    {
        return kExpandedCellHeight; // It's not necessary a constant, though
    }
    else
    {
        return kNormalCellHeigh; // Again not necessary a constant
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
