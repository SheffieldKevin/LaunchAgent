@import Foundation;

@protocol Agent

- (void)keepAgentAlive:(BOOL)keepAlive;
- (void)specifyIdleTime:(NSInteger)idleTime;
- (void)getRandomNumberWithReply:(void (^)(NSInteger))reply;

@end
