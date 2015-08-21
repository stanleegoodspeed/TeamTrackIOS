//
//  HomeViewController.h
//  TeamTrackIOS
//
//  Created by Colin Cole on 8/21/15.
//  Copyright (c) 2015 Colin Cole. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController
{
    
    __weak IBOutlet UIButton *viewRacesButton;
    __weak IBOutlet UIButton *createWorkoutButton;
    __weak IBOutlet UILabel *welcomeLabel;
}

- (IBAction)createWorkoutPressed:(id)sender;
- (IBAction)viewRacesPressed:(id)sender;

@end
