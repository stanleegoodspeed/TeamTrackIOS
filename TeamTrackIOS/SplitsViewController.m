//
//  SplitsViewController.m
//  TeamTrackIOS
//
//  Created by Colin Cole on 8/21/15.
//  Copyright (c) 2015 Colin Cole. All rights reserved.
//

#import "SplitsViewController.h"

@interface SplitsViewController ()

@end

@implementation SplitsViewController

- (id)initWithSplits:(NSArray *)mySplits;
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
        label.text = @"Splits";
        [[self navigationItem]setTitleView:label];
                
        // Var init
        splits = [[NSArray alloc]initWithArray:mySplits];
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return splits.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIden = @"myCell";
    SplitsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIden];
    Split *mySplit = [splits objectAtIndex:indexPath.row];
    
    if(!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"SplitsTableViewCell" bundle:nil ]forCellReuseIdentifier:cellIden];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIden];
    }
    
    double elapsed = [mySplit.splitTime doubleValue];
    int mins = (int) (elapsed / 60.0);
    elapsed -= mins * 60;
    int secs = (int) (elapsed);
    elapsed -= secs;
    int fraction = elapsed * 10.0;
    
    cell.splitTimeLabel.text = [NSString stringWithFormat:@"%u:%02u.%u",mins,secs,fraction];
    
    return cell;
    
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
