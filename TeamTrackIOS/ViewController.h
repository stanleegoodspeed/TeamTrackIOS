//
//  ViewController.h
//  TeamTrackIOS
//
//  Created by Colin Cole on 8/3/15.
//  Copyright (c) 2015 Colin Cole. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *myArray;
}


@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIButton *startButton;


- (IBAction)startButtonPressed:(id)sender;


@end


