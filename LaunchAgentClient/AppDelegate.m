// Usual Apple 2012 Copyright message

#import "AppDelegate.h"
#import "Interfaces.h"

@implementation AppDelegate {
	NSMutableString *_text;
	id <Agent> _agent;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// Initialize string to hold history buffer text.
	// _text = [NSMutableString string];

	// Setup our connection to the launch item's service.
	// This will start the launch item if it isn't already running.
	NSError *error = nil;
	NSXPCConnection *connection;
	connection = [[NSXPCConnection alloc]
				  initWithMachServiceName:@"U6TV63RN87.com.yvs.LaunchAgent" options:0];
	if (connection == nil)
	{
		NSLog(@"Failed to connect to Launch Agent: %@\n", [error description]);
//		[_query setEditable:NO];
		return;
	}
	connection.remoteObjectInterface = [NSXPCInterface interfaceWithProtocol:@protocol(Agent)];
	[connection resume];

	// Get a proxy DecisionAgent object for the connection.
	_agent = [connection remoteObjectProxy];
/*
	_agent = [connection remoteObjectProxyWithErrorHandler:^(NSError *err) {
		// This block is run when an error occurs communicating with
		// the launch item service.  This will not be invoked on the
		// main queue, so re-schedule a block on the main queue to
		// update the U.I.
		dispatch_async(dispatch_get_main_queue(), ^{
			[self appendToHistory:@"Failed to query oracle: %@\n\n", [err description]];
		});
	}];
*/
}

- (IBAction)updateIdleTime:(id)sender
{
//	NSTextField *textField = sender;
//	NSLog(@"idleTimeTextField = %@", [textField description]);
//	NSString *textString = [textField stringValue];
	
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

/*
- (IBAction)postQuery:(id)sender
{
	// Move the query text into the history buffer.
	NSString *query = [_query stringValue];
	[self appendToHistory:@">>> %@\n", query];
	[_query setStringValue:@""];

	// Query the DecisionAgent for its advice...
	[_agent adviseOn:query reply:^(NSString *advice) {
		// Got advice back from DecisionAgent.  This will not be
		// invoked on the main queue, so re-schedule a block on the
		// main queue to update the U.I.
		dispatch_async(dispatch_get_main_queue(), ^{
			[self appendToHistory:@"%@\n\n", advice];
		});
	}];
}
*/
@end
