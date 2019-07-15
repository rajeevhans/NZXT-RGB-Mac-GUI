//
//  AppDelegate.m
//  NZXT-RGB-Mac-GUI
//
//  Created by Harrison White on 5/17/19.
//  Copyright © 2019 Harrison White. All rights reserved.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
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

static dispatch_once_t onceToken;

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
    dispatch_once(&onceToken, ^{
        driver_init();
    });
    
    [self setupBarMenu];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
    driver_teardown();
}

- (void)application:(NSApplication *)application openURLs:(NSArray<NSURL *> *)urls {
    for (NSURL* url in urls) {
        if ([[url scheme]isEqualToString:@"nzxt-rgb-mac"]) {
            // see above note
            dispatch_once(&onceToken, ^{
                driver_init();
            });
            
            BOOL on = [[url resourceSpecifier]isEqualToString:@"on"];
            set_lights_on(on);
        }
    }
}

@end
