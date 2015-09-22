//
//  HomeViewController.m
//  TeamTrackIOS
//
//  Created by Colin Cole on 8/21/15.
//  Copyright (c) 2015 Colin Cole. All rights reserved.
//

#import "HomeViewController.h"
#import "CreateWorkoutViewController.h"
#import "MyRacesViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

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
        label.text = @"Home";
        [[self navigationItem]setTitleView:label];
        [[self navigationItem]setHidesBackButton:YES];
        
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    }
    
    return self;
}

- (id)initWithUserID:(NSNumber *)userID
{
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

#pragma mark - IBActions

- (IBAction)createWorkoutPressed:(id)sender
{
    // Push View Controller
    CreateWorkoutViewController *createWorkoutViewController = [[CreateWorkoutViewController alloc]init];
    [[self navigationController] pushViewController:createWorkoutViewController animated:YES];
}

- (IBAction)viewRacesPressed:(id)sender
{
    // Push View Controller
    MyRacesViewController *myRacesViewController = [[MyRacesViewController alloc]init];
    [[self navigationController] pushViewController:myRacesViewController animated:YES];
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
