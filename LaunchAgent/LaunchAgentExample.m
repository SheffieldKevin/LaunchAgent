@import Foundation;
#import "LaunchAgentExample.h"

#include <stdlib.h>

static NSXPCListener *theListener;

@interface LaunchAgentExample ()

@property (assign) BOOL keepAlive;
@property (assign) NSInteger idleTime; // When !keepAlive idleTime is time to live
// @property (assign) BOOL activeSinceTimerSet; // If any activity has been set since timer started.
@property (strong) NSTimer *killTimer; // If the timer fires the launch agent could exit.

- (void)exitLaunchAgent:(NSTimer *)theTimer;
- (void)createKillTimer; // Will check keepAlive before creating timer.
- (void)invalidateAndRemoveKillTimer;
- (void)invalidateOldTimerAndCreateNew;

@end

@implementation LaunchAgentExample

-(id)init
{
	self = [super init];
	self.keepAlive = YES;
	self.idleTime = 10; // Default idle time is 10 seconds.
	return self;
}

#pragma mark -
#pragma mark NSXPCConnection method overrides

- (BOOL)listener:(NSXPCListener *)listener shouldAcceptNewConnection:(NSXPCConnection *)newConnection
{
	// This method is called by the NSXPCListener to filter/configure
	// incoming connections.
	theListener = listener;
	newConnection.exportedInterface = [NSXPCInterface interfaceWithProtocol:@protocol(Agent)];
	newConnection.exportedObject = self;
	
	// Start processing incoming messages.
	[newConnection resume];

	return YES;
}

#pragma mark -
#pragma mark Public interface

- (void)exitLaunchAgent:(NSTimer *)killTimer
{
/*
	if (!self.keepAlive && !self.activeSinceTimerSet)
		exit(0);
	
	self.activeSinceTimerSet = NO;
	self.killTimer = NULL;
	[self keepAgentAlive:self.keepAlive];
*/
	exit(0);
}

- (void)createKillTimer
{
	if (!self.keepAlive)
	{
//		self.activeSinceTimerSet = NO;
		dispatch_async(dispatch_get_main_queue(), ^
		{
			self.killTimer = [NSTimer
						  scheduledTimerWithTimeInterval:(NSTimeInterval)self.idleTime
												  target:self
												selector:@selector(exitLaunchAgent:)
												userInfo:nil
												 repeats:NO];
		});
	}
}

- (void)invalidateAndRemoveKillTimer
{
	if (self.killTimer)
	{
		[self.killTimer invalidate];
		self.killTimer = NULL;
	}
}

- (void)invalidateOldTimerAndCreateNew
{
	[self invalidateAndRemoveKillTimer];
	[self createKillTimer];
}

- (void)keepAgentAlive:(BOOL)isAlive
{
	[self setKeepAlive:isAlive];
	[self invalidateOldTimerAndCreateNew];
}

- (void)specifyIdleTime:(NSInteger)theIdleTime
{
	self.idleTime = theIdleTime;
	[self invalidateOldTimerAndCreateNew];
}

- (void)getRandomNumberWithReply:(void (^)(NSInteger))reply
{
	NSInteger randNum = arc4random_uniform(10000);
	[self invalidateOldTimerAndCreateNew];
	reply(randNum);
}

@end
