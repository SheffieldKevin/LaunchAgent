// @import Foundation;
#import <Foundation/Foundation.h>
#import "Interfaces.h"

@interface LaunchAgentExample : NSObject <NSXPCListenerDelegate, Agent>
{
	BOOL keepAlive;
	NSInteger idleTime;
	NSTimer *killTimer;
}

@end
