//
//  MMTrackingController.h
//
//  Created by Matt Martel on 02/20/09
//  Copyright Mundue LLC 2008-2011. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMTrackingController : NSObject {
}

+ (MMTrackingController*) sharedTrackingController;
- (void) startTracking;
- (void) stopTracking;
- (void) logEvent:(NSString*)event;
- (void) logError:(NSString *)errorID message:(NSString *)message exception:(NSException *)exception;

@end
