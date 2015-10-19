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


- (id)initWithAthletes:(NSArray *)myAthletes
{
    self = [super init];
    if (self) {
        // Navbar setup
        NSString *titleText = @"Results";
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
        
        UIBarButtonItem *saveButton= [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
        self.navigationItem.rightBarButtonItem = saveButton;
        
        UIBarButtonItem *backToStartButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"home_icon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backToStartButtonPressed:)];
        self.navigationItem.leftBarButtonItem = backToStartButton;
        
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
    Athlete *myAthlete = [athletes objectAtIndex:indexPath.row];
    SplitsViewController *splitsViewController = [[SplitsViewController alloc]initWithSplits:myAthlete.splits];
    [[self navigationController] pushViewController:splitsViewController animated:YES];
    
}


#pragma mark - IBActions

- (IBAction)backToStartButtonPressed:(id)sender
{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}


@end
