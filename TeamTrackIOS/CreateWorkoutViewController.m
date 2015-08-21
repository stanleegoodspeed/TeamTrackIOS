//
//  CreateWorkoutViewController.m
//  TeamTrackIOS
//
//  Created by Colin Cole on 8/14/15.
//  Copyright (c) 2015 Colin Cole. All rights reserved.
//

#import "CreateWorkoutViewController.h"

@interface CreateWorkoutViewController ()

@end

@implementation CreateWorkoutViewController

- (id)init
{
    self = [super init];
    if (self) {

        CGRect frame = CGRectMake(0, 0, 400, 44);
        UILabel *label = [[UILabel alloc] initWithFrame:frame];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:21];
        label.textColor = [UIColor blackColor];
        label.text = @"Create Workout";
        [[self navigationItem]setTitleView:label];
    }
    
    return self;
}

- (void)viewDidLoad {
    
// TODO ** add circular iOS8 button style
//
//    CGFloat buttonSize = 50;
//    CGRect buttonRect = CGRectMake(100.0,
//                                   100.0,
//                                   buttonSize,
//                                   buttonSize);
//    MRoundedButton *button = [[MRoundedButton alloc] initWithFrame:buttonRect
//                                                       buttonStyle:MRoundedButtonSubtitle
//                                              appearanceIdentifier:@"3"];
//    button.textLabel.text = @"Start";
//    button.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:10];
//    //button.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:button];
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nextButtonPressed:(id)sender
{
    //NSURL *url = [NSURL URLWithString:@"http://himrod.home/~Colin/TeamTrack/api/index.php/postrace"];
    NSString *queryStr = @"postrace";
    NSMutableDictionary *dataDictionary = [NSMutableDictionary dictionaryWithCapacity:1];
    [dataDictionary setObject:workoutNameInput.text forKey:@"workoutName"];
    [dataDictionary setObject:eventNameInput.text forKey:@"eventName"];
    
    PostToServer *postToServer = [PostToServer sharedStore];
    postToServer.delegate = self;
    [postToServer postDataToServer:dataDictionary withQuery:queryStr];
}

#pragma mark - PostToServer Delegate

- (void)didCompletePost:(BOOL)status withData:(NSString *)data withDict:(NSDictionary *)dataDict
{
    // Receive and set new data
    NSInteger tmp = [data integerValue];
    raceID = [NSNumber numberWithInteger:tmp];
    
    // Push View Controller
    AthleteSelectViewController *athleteSelectViewController = [[AthleteSelectViewController alloc]initWithRaceID:raceID];
    [[self navigationController] pushViewController:athleteSelectViewController animated:YES];
}

#pragma mark - NSURLConnection Delegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"data returned: %@",dataStr);
    NSInteger tmp = [dataStr integerValue];
    raceID = [NSNumber numberWithInteger:tmp];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
{
    NSLog(@"finished!");
    AthleteSelectViewController *athleteSelectViewController = [[AthleteSelectViewController alloc]initWithRaceID:raceID];
    [[self navigationController] pushViewController:athleteSelectViewController animated:YES];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"error: %@",[error localizedDescription]);
}


@end
