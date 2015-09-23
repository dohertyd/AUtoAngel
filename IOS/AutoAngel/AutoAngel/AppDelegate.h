//
//  AppDelegate.h
//  AutoAngel
//
//  Created by Derek Doherty on 23/05/2015.
//  Copyright (c) 2015 Derek Doherty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, readonly) UIStoryboard *storyBoard;

//@property (weak, nonatomic) MsgViewController * mtvc;
//@property (weak, nonatomic) ContactsTableViewController * ctvc;

- (void)setOurId:(NSString *)ourId;


@end

