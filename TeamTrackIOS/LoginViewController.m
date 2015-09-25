//
//  LoginViewController.m
//  TeamTrackIOS
//
//  Created by Colin Cole on 9/22/15.
//  Copyright (c) 2015 Colin Cole. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithCreds:(NSString *)username andPassword:(NSString *)password
{
    self = [super init];
    if (self) {
        
        localUsername = username;
        localPassword = password;
    }
    
    // Auto Login
    [self loginWithStoredCred:username andPassword:password];
    
    return self;
}

- (void)viewDidLoad {
    
    // Add TapRecognizer to auto-close keyboard when clicked outside of zone
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    // set text field border color
    self.emailInput.layer.cornerRadius=8.0f;
    self.emailInput.layer.masksToBounds=YES;
    self.emailInput.layer.borderColor=[[UIColor whiteColor]CGColor];
    self.emailInput.layer.borderWidth= 1.0f;
    self.passwordInput.layer.cornerRadius=8.0f;
    self.passwordInput.layer.masksToBounds=YES;
    self.passwordInput.layer.borderColor=[[UIColor whiteColor]CGColor];
    self.passwordInput.layer.borderWidth= 1.0f;
    self.loginButton.layer.cornerRadius=8.0f;
    self.loginButton.layer.masksToBounds=YES;
    self.loginButton.layer.borderColor=[[UIColor whiteColor]CGColor];
    self.loginButton.layer.borderWidth= 1.0f;
    
    //self.navigationController.navigationBar.hidden = TRUE;
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActtions

- (IBAction)loginPressed:(id)sender
{
    autoLoginFlag = FALSE;
    NSString *queryStr = @"mobilelogin";
    
    NSMutableDictionary *dataDictionary = [NSMutableDictionary dictionaryWithCapacity:1];
    [dataDictionary setObject:self.emailInput.text forKey:@"email"];
    [dataDictionary setObject:self.passwordInput.text forKey:@"password"];
    
    PostToServer *postToServer = [PostToServer sharedStore];
    postToServer.delegate = self;
    [postToServer postDataToServer:dataDictionary withQuery:queryStr];
}

#pragma mark - PostToServer Delegate

- (void)didCompletePost:(NSDictionary *)dataDict
{
    // Login Success
    if([[dataDict objectForKey:@"status"] doubleValue] == 200 ) {
        
        if(autoLoginFlag)
        {
            // do nothing, if its authenticated via keychain stores, just continue on to home screen
        }
        else
        {
            // Set items in keychain for the first time
            NSNumber *userID = [NSNumber numberWithInteger:[[dataDict objectForKey:@"userID"] intValue]];
            
            KeychainWrapper *keychainItem = [[KeychainWrapper alloc] init];
            [keychainItem mySetObject:self.emailInput.text forKey:(__bridge id)kSecAttrAccount];
            [keychainItem mySetObject:self.passwordInput.text forKey:(__bridge id)kSecValueData];
            [keychainItem mySetObject:userID forKey:(__bridge id)kSecAttrService];
        }
        
        // Send to home controller
        HomeViewController *homeViewController = [[HomeViewController alloc]init];
        [[self navigationController]pushViewController:homeViewController animated:YES];
        
    // Login failed
    }else{
        NSString *errorMsg = (NSString *)[dataDict objectForKey:@"message"];
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Whoops!"
                                      message:errorMsg
                                      preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [self dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        [alert addAction:ok];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}

#pragma mark - UITextFieldDelegate

- (BOOL) textFieldShouldBeginEditing:(UITextView *)textView
{
    //[self.eventNameInput becomeFirstResponder];
    return YES;
}

#pragma mark - Helpers

-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)loginWithStoredCred:(NSString *)username andPassword:(NSString *)password
{
    autoLoginFlag = TRUE;
    NSString *queryStr = @"mobilelogin";
    NSMutableDictionary *dataDictionary = [NSMutableDictionary dictionaryWithCapacity:1];
    [dataDictionary setObject:username forKey:@"email"];
    [dataDictionary setObject:password forKey:@"password"];
    
    PostToServer *postToServer = [PostToServer sharedStore];
    postToServer.delegate = self;
    [postToServer postDataToServer:dataDictionary withQuery:queryStr];
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
