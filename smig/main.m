//
//  main.m
//  smig
//
//  Copyright (c) 2013 YVS Inc. All rights reserved.
//

@import Foundation;
#import "Interfaces.h"

int main(int argc, const char * argv[])
{
	@autoreleasepool
	{
		id <Agent> agent;
		// Setup our connection to the launch item's service.
		NSError *error = nil;
		NSXPCConnection *connection;
		connection = [[NSXPCConnection alloc]
					  initWithMachServiceName:@"U6TV63RN87.com.yvs.LaunchAgent" options:0];
		if (connection == nil)
		{
			NSLog(@"Failed to connect to Launch Agent: %@\n", [error description]);
			return EXIT_FAILURE;
		}
		connection.remoteObjectInterface = [NSXPCInterface interfaceWithProtocol:@protocol(Agent)];
		[connection resume];
		
		// Get a proxy DecisionAgent object for the connection.
		agent = [connection remoteObjectProxy];

		[agent getRandomNumberWithReply:^(NSInteger ranNum)
		{
			 dispatch_async(dispatch_get_main_queue(), ^
			{
				NSLog(@"Random number is: %ld", ranNum);
				exit(EXIT_SUCCESS);
			});
		}];
		[[NSRunLoop currentRunLoop] run];
	}
    return 0;
}

