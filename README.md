# LaunchAgent

LaunchAgent is an example project for getting a LaunchAgent up and running and provides a tiny application demonstrating communicating with the LaunchAgent

##Info

In this branch I’ve updated the project to work with Xcode 4.6 on 10.9. I’ve also removed sandboxing. XPC communication still seems to work.

I’ve code signed both the LaunchAgent and its client application. The bundle identifier and the bundle name must be the same. You’ll need to update the project settings and replace yvs with your trading name and your Team ID. The Team ID is the first part of the bundle identifier and name for the LaunchAgent, so for me I get the following.

* Bundle Identifier: U6TV63RN87.com.yvs.LaunchAgent
* Bundle name with extension: U6TV63RN87.com.yvs.LaunchAgent.app
* Mac Service name published by LaunchAgent: U6TV63RN87.com.yvs.LaunchAgent

You can build the application now, the LaunchAgent is a build dependency of the application so the LaunchAgent will also be built.

After making the appropriate changes above you’ll need to create your own LaunchAgent plist file. My version of the LaunchAgent plist file lives in the root folder of the git repository. I would duplicate the plist file because the original is part of the git rep. Rename the duplicated plist file to the same as the LaunchAgent bundle identifier but keep the .plist file extension. Open the plist file and replace all references to the Team ID and trading name with your own. You’ll need to update the full path to the executable file which is in the LaunchAgent bundle built when you built the Application. The full path is specified as the first Program Arguments value. Once you’ve done that you can then copy the plist file to ~/Library/LaunchAgents/ .

You can use the `launchctl` command with the load option to load the Mach Service to the system immediately or you can logout and log back in again and the system will now know about the existence of the Mach Service.

Once the service is registered you can stop and start it using the `launchctl` command.

`launchctl start U6TV63RN87.com.yvs.LaunchAgent`

`launchctl stop U6TV63RN87.com.yvs.LaunchAgent`

Running the application and then sending the first message to the LaunchAgent will automatically start the LaunchAgent service so start is not strictly necessary in this case.

##Debugging your LaunchAgent from Xcode

Add a break point in LaunchAgentExample.m in the getRandomNumberWithReply message.

In Xcode I’ve set up the run section in the scheme for the LaunchAgent that it doesn’t launch the LaunchAgent automatically but instead waits for it to start. I select the LaunchAgent scheme and click run. I then switch to the LaunchAgent client scheme and click run, the application starts. To test that the LaunchAgent is working click the Get a random number button, this will start the LaunchAgent and you should stop at the break point. Click continue and the random number the launch agent generated is displayed next to the button.

You can turn off keeping the launch agent alive indefinitely, and you can specify the idle time before the launch agent will exit. Change the number in the text field and click Update idle time to inform the LaunchAgent how long it should stay alive for.

The get a random number button is purely to test that xpc is working. The other options are to make it possible to play around with the lifetime of the launch agent.

## Credits and Contact

LaunchAgent created by [Sheffield Kevin](https://github.com/SheffieldKevin) and on twitter you can find him at [Cocoa Kevin](https://twitter.com/CocoaKevin)

