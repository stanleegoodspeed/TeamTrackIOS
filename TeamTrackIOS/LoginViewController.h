//
//  LoginViewController.h
//  TeamTrackIOS
//
//  Created by Colin Cole on 9/22/15.
//  Copyright (c) 2015 Colin Cole. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "PostToServer.h"
#import "HomeViewController.h"
#import "KeychainWrapper.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate, PostToServerDelegate>
{
    NSString *localUsername;
    NSString *localPassword;
    BOOL autoLoginFlag;
}

@property (weak, nonatomic) IBOutlet UITextField *emailInput;
@property (weak, nonatomic) IBOutlet UITextField *passwordInput;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

- (IBAction)loginPressed:(id)sender;
- (id)initWithCreds:(NSString *)username andPassword:(NSString *)password;

@end
