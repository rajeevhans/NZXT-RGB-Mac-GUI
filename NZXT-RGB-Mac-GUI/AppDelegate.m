//
//  AppDelegate.m
//  NZXT-RGB-Mac-GUI
//
//  Created by Harrison on 5/17/19.
//  Copyright © 2019 RCX LLC. All rights reserved.
//

// Cannot use app sandbox or you will get "Operation not permitted"
// when sending USB commands

#import "AppDelegate.h"
#import "driver.h"

@interface AppDelegate () <NSMenuDelegate>

@property (weak) IBOutlet NSMenu* barMenu;
@property (nonatomic, strong) NSStatusItem* barItem;

@end

@implementation AppDelegate

- (IBAction)turnRGBOn:(id)sender {
    NSLog(@"rgb on");
    set_lights_on(true);
}

- (IBAction)turnRGBOff:(id)sender {
    NSLog(@"rgb off");
    set_lights_on(false);
}

- (IBAction)quit:(id)sender {
    [NSApp terminate:nil];
}

- (void)setupBarMenu {
    // Icon by Eleonor Wang from www.flaticon.com, licensed under CC-3.0-BY
    
    NSStatusItem* barItem = [[NSStatusBar systemStatusBar]statusItemWithLength:NSSquareStatusItemLength];
    barItem.button.image = [NSImage imageNamed:@"menu-icon"];
    barItem.menu = self.barMenu;
    self.barItem = barItem;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    // must be called ONCE on app launch;
    // if called multiple times, getting device handles will fail
    driver_init();
    
    [self setupBarMenu];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
    driver_teardown();
}


@end
