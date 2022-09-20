//
//  AppDelegate.h
//  Watcher
//
//  Created by junlei on 2019/2/24.
//  Copyright © 2019 Hp. All rights reserved.
//

#import <Cocoa/Cocoa.h>


void start();
void stop();
void setFN(void * f);
void hahaha(int cid, void * byte, int len, int dir);

@interface AppDelegate : NSObject <NSApplicationDelegate>


@end

