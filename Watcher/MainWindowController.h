//
//  MainWindowController.h
//  Watcher
//
//  Created by junlei on 2019/2/24.
//  Copyright © 2019 Hp. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainWindowController : NSWindowController
@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSButton *serverBtn;


- (void)adddata:(NSString *)source des:(NSString *)des;


@end

NS_ASSUME_NONNULL_END
