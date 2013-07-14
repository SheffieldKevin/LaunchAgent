// Usual Apple 2012 Copyright agreement. 

#import <Foundation/Foundation.h>
#import "LaunchAgentExample.h"

int main(int argc, const char *argv[])
{
	// LaunchServices automatically registers a mach service of the same
	// name as our bundle identifier.
	NSString *bundleId = [[NSBundle mainBundle] bundleIdentifier];
	NSXPCListener *listener = [[NSXPCListener alloc] initWithMachServiceName:bundleId];

	// Create the delegate of the listener.
	LaunchAgentExample *launchAgent = [[LaunchAgentExample alloc] init];
	listener.delegate = launchAgent;

	// Begin accepting incoming connections.
	// For mach service listeners, the resume method returns immediately so
	// we need to start our event loop manually.
	[listener resume];
	[[NSRunLoop currentRunLoop] run];

	return 0;
}
