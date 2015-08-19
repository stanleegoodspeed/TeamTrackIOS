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
        // Navbar setup
        [[self navigationItem]setTitle:@"Create Workout"];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
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

- (IBAction)nextButtonPressed:(id)sender
{
    NSURL *url = [NSURL URLWithString:@"http://himrod.home/~Colin/TeamTrack/api/index.php/postrace"];
    NSMutableDictionary *dataDictionary = [NSMutableDictionary dictionaryWithCapacity:1];
    [dataDictionary setObject:workoutNameInput.text forKey:@"workoutName"];
    [dataDictionary setObject:eventNameInput.text forKey:@"eventName"];
    
    //PostToServer *postToServer = [[PostToServer alloc]init];
    PostToServer *postToServer = [PostToServer sharedStore];
    postToServer.delegate = self;
    [postToServer postDataToServer:dataDictionary withURL:url];
    
//    NSError *jsonSerializationError = nil;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:projectDictionary options:NSJSONWritingPrettyPrinted error:&jsonSerializationError];
//    
//    if(!jsonSerializationError) {
//        NSString *serJSON = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//        NSLog(@"Serialized JSON: %@", serJSON);
//    } else {
//        NSLog(@"JSON Encoding Failed: %@", [jsonSerializationError localizedDescription]);
//    }
//    
//
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:90];
//    [request setHTTPMethod:@"POST"];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [request setHTTPBody: jsonData];
//    
//    connection = [[NSURLConnection alloc]initWithRequest:request delegate:self startImmediately:YES];
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
