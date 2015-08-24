//
//  MyRacesViewController.h
//  TeamTrackIOS
//
//  Created by Colin Cole on 8/21/15.
//  Copyright (c) 2015 Colin Cole. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostToServer.h"

@interface MyRacesViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, PostToServerDelegate>
{
    NSMutableArray *allRaces;
    NSURLConnection *connection;
    NSMutableArray *myAthletes;
    BOOL flag;
    
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
