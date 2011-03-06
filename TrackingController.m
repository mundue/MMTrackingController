//
//  TrackingController.m
//  reMovem2
//
//  Created by Matt Martel on 02/20/09
//  Copyright Mundue LLC 2008-2011. All rights reserved.
//

//
// Demonstrates how to integrate Flurry, Google Analytics, and Localtyics.
// Modify as needed for other services.
//

#import "TrackingController.h"
#import "TrackingControllerDefs.h"

#ifdef USES_FLURRY
#import "FlurryAPI.h"
#endif

#ifdef USES_LOCALYTICS
#import "LocalyticsSession.h"
#endif

#ifdef USES_GANTRACKER
#import "GANTracker.h"
// Dispatch period in seconds
static const NSInteger kGANDispatchPeriodSec = 10;
#endif

@implementation TrackingController

static TrackingController* _sharedTrackingController = nil;

#pragma mark -
#pragma mark Singleton Methods

+ (TrackingController*) sharedTrackingController {
	@synchronized(self) {
		if ( _sharedTrackingController == nil ) {
			_sharedTrackingController = [[TrackingController alloc] init];
		}
	}
	return _sharedTrackingController;
}

+ (id)allocWithZone:(NSZone *)zone {	
    @synchronized(self) {
        if (_sharedTrackingController == nil) {
            _sharedTrackingController = [super allocWithZone:zone];			
            return _sharedTrackingController;  // assignment and return on first allocation
        }
    }
    return nil; //on subsequent allocation attempts return nil	
}

- (id)copyWithZone:(NSZone *)zone {
    return self;	
}

- (id)retain {	
    return self;	
}

- (unsigned)retainCount {
    return UINT_MAX;  //denotes an object that cannot be released
}

- (void)release {
    //do nothing
}

- (id)autorelease {
    return self;	
}

#pragma mark -
#pragma mark TrackingController Methods

- (void) startTracking {
#ifdef USES_FLURRY
	[FlurryAPI startSession:kFlurryAPIKey];
#endif
#ifdef USES_LOCALYTICS
	[[LocalyticsSession sharedLocalyticsSession] startSession:kLocalyticsAppKey];
#endif
#ifdef USES_GANTRACKER
	[[GANTracker sharedTracker] startTrackerWithAccountID:kGANAccountIDKey
										   dispatchPeriod:kGANDispatchPeriodSec
												 delegate:nil];
#endif
	[self logEvent:@"Launch" ];										   
}

- (void) stopTracking {
	[self logEvent:@"Terminate" ];
#ifdef USES_FLURRY
	// Nothing to do
#endif
#ifdef USES_LOCALYTICS
    [[LocalyticsSession sharedLocalyticsSession] close];
    [[LocalyticsSession sharedLocalyticsSession] upload];
#endif
#ifdef USES_GANTRACKER
	[[GANTracker sharedTracker] stopTracker];
#endif
}

- (void) logEvent:(NSString*)event {
#ifdef DEBUG	
	NSLog( @"Log Event: %@", event );
#endif
#ifdef USES_FLURRY
	[FlurryAPI logEvent:event];
#endif
#ifdef USES_LOCALYTICS
	if ( [event isEqualToString:@"EnterForeground"] ) {
		[[LocalyticsSession sharedLocalyticsSession] resume];
		[[LocalyticsSession sharedLocalyticsSession] upload];
	}
	[[LocalyticsSession sharedLocalyticsSession] tagEvent:event];
	if ( [event isEqualToString:@"EnterBackground"] ) {
		[[LocalyticsSession sharedLocalyticsSession] close];
		[[LocalyticsSession sharedLocalyticsSession] upload];
	}
#endif
#ifdef USES_GANTRACKER
	NSError *error;
	if (![[GANTracker sharedTracker] trackEvent:kGANCategoryKey
										 action:event
										  label:nil
										  value:-1
									  withError:&error]) {
		// Handle error here
	}
#endif
}

// Flurry ONLY !!!
- (void) logError:(NSString *)errorID message:(NSString *)message exception:(NSException *)exception {
#ifdef USES_FLURRY
	[FlurryAPI logError:errorID message:message exception:exception];
#endif
}

@end
