//
//  StartUpViewController.m
//  AutoAngel
//
//  Created by Derek Doherty on 23/05/2015.
//  Copyright (c) 2015 Derek Doherty. All rights reserved.
//

#import "StartUpViewController.h"

@interface StartUpViewController ()

@end

@implementation StartUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSLog(@"Initial View did appear: %d", animated);
    
    
    // A non nil nickName will indicate a valid user name which has been registered
//    if(![_contactList nickName]) {
//        [self performSegueWithIdentifier:@"Registration" sender:self];
//    } else {
        [self performSegueWithIdentifier:@"GoToCrashView" sender:self];
//    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
//    if ([segue.identifier isEqualToString:@"GoToCrashView"]) {
//        UINavigationController * nav = (UINavigationController *)segue.destinationViewController;
        
        // This gives a handle to first viewcontroller that the nav controller handles
//        ContactsTableViewController * ctvc = (ContactsTableViewController *)nav.topViewController;
        
//        ctvc.contactList = self.contactList;
//    } else if ([segue.identifier isEqualToString:@"Registration"]) {
//        LoginViewController * livc = (LoginViewController *)segue.destinationViewController;
//        livc.contactList = self.contactList;
//    }
}

@end
