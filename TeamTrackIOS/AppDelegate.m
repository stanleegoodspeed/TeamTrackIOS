//
//  AppDelegate.m
//  TeamTrackIOS
//
//  Created by Colin Cole on 8/3/15.
//  Copyright (c) 2015 Colin Cole. All rights reserved.
//

#import "AppDelegate.h"
//#import "CreateWorkoutViewController.h"
//#import "HomeViewController.h"
#import "LoginViewController.h"
#import "KeychainWrapper.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    KeychainWrapper *keychainItem = [[KeychainWrapper alloc] init];
    //[keychainItem resetKeychainItem];
    NSString *password = [keychainItem myObjectForKey:(__bridge id)(kSecValueData)];
    NSString *username = [keychainItem myObjectForKey:(__bridge id)(kSecAttrAccount)];
    
    // Creds must not be stored in keychain yet
    if([password length] == 0 || [username length] == 0)
    {
        // Push LoginViewController so user can enter username/password and store in keychain
        LoginViewController *loginViewController = [[LoginViewController alloc]init];
        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:loginViewController];
        [[UINavigationBar appearance]setTintColor:[UIColor whiteColor]]; // it set color of bar button item text
        [[UINavigationBar appearance]setBarTintColor:[UIColor colorWithRed:51.0/255.0 green:153.0/255.0 blue:255.0/255.0 alpha:1]]; // it set color of navigation
        [[self window] setRootViewController:navController];
    }
    else
    {
        // Send keychain username/password to LoginAuth Helper. Once authenticated, go to Home Screen
        LoginViewController *loginViewController = [[LoginViewController alloc]initWithCreds:username andPassword:password];
        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:loginViewController];
        [[UINavigationBar appearance]setTintColor:[UIColor whiteColor]]; // it set color of bar button item text
        [[UINavigationBar appearance]setBarTintColor:[UIColor colorWithRed:51.0/255.0 green:153.0/255.0 blue:255.0/255.0 alpha:1]]; // it set color of navigation
        [[self window] setRootViewController:navController];
    }
    
//    [[UINavigationBar appearance]setTintColor:[UIColor whiteColor]]; // it set color of bar button item text
//    [[UINavigationBar appearance]setBarTintColor:[UIColor colorWithRed:51.0/255.0 green:153.0/255.0 blue:255.0/255.0 alpha:1]]; // it set color of navigation
//    [[self window] setRootViewController:navController];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
