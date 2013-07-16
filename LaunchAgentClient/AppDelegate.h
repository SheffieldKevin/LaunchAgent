// @import Cocoa;
#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSTextField *idleTime;
@property (assign) IBOutlet NSTextField *randomNumber;

- (IBAction)updateIdleTime:(id)sender;
- (IBAction)updateKeepAlive:(id)sender;
- (IBAction)getRandomNumber:(id)sender;

@end
