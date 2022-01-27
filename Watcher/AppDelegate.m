//
//  AppDelegate.m
//  Watcher
//
//  Created by junlei on 2019/2/24.
//  Copyright © 2019 Hp. All rights reserved.
//https://www.cnblogs.com/Chilam007/p/6973990.html
#import "AppDelegate.h"
#import <Watcher-Swift.h>


void hahaha(int cid, void * byte, int len){
    
    char * p = (char *)byte;
    
    for (int i = 0; i < len; i ++) {
        printf("%c", p[i]);
    }
    
    
    NSLog(@"callback!!!!%d %d %@",cid, len, [NSThread currentThread]);
}

@interface AppDelegate ()

@property (strong) MainWindowController *windowController;
@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    setFN(hahaha);
    
    self.windowController = [[MainWindowController alloc]init];
    [self.windowController showWindow:self];

    
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
//    if ([self.ssserver started]) {
//        [self.ssserver stop];
//    }
}
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
}

@end
