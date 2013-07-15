#import "AppDelegate.h"
#import "Interfaces.h"

@implementation AppDelegate {
	NSMutableString *_text;
	id <Agent> _agent;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// Setup our connection to the launch item's service.
	// This will start the launch item if it isn't already running.
	NSError *error = nil;
	NSXPCConnection *connection;
	connection = [[NSXPCConnection alloc]
				  initWithMachServiceName:@"U6TV63RN87.com.yvs.LaunchAgent" options:0];
	if (connection == nil)
	{
		NSLog(@"Failed to connect to Launch Agent: %@\n", [error description]);
		return;
	}
	connection.remoteObjectInterface = [NSXPCInterface interfaceWithProtocol:@protocol(Agent)];
	[connection resume];

	// Get a proxy DecisionAgent object for the connection.
	_agent = [connection remoteObjectProxy];
}

- (IBAction)updateIdleTime:(id)sender
{
	[_agent specifyIdleTime:[self.idleTime integerValue]];
}

- (IBAction)updateKeepAlive:(id)sender
{
	[_agent keepAgentAlive:!([sender integerValue] == 0)];
}

- (IBAction)getRandomNumber:(id)sender
{
	[_agent getRandomNumberWithReply:^(NSInteger ranNum)
	{
		dispatch_async(dispatch_get_main_queue(), ^
		{
			[self.randomNumber setStringValue:[[NSString alloc] initWithFormat:@"%ld", ranNum]];
		});
	}];
}

@end
