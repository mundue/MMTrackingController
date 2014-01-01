//
//  MMTrackingController.m
//
//  Created by Matt Martel on 02/20/09
//  Copyright (c) 2009-2014, Mundue LLC. All rights reserved.
//

//
// Demonstrates how to integrate Flurry and Google Analytics.
// Modify as needed for other services.
//

#import "MMTrackingController.h"
#import "MMTrackingControllerDefs.h"

#ifdef USES_FLURRY
#import "Flurry.h"
#endif

#ifdef USES_GAITRACKER
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
static id<GAITracker> _tracker;
// Dispatch period in seconds
static const NSInteger kGANDispatchPeriodSec = 10;
#endif

@implementation MMTrackingController

static MMTrackingController* _sharedTrackingController = nil;

#pragma mark - Singleton Methods

+ (MMTrackingController*)sharedTrackingController
{
	@synchronized(self) {
		if ( _sharedTrackingController == nil ) {
			_sharedTrackingController = [[MMTrackingController alloc] init];
		}
	}
	return _sharedTrackingController;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) {
        if (_sharedTrackingController == nil) {
            _sharedTrackingController = [super allocWithZone:zone];			
            return _sharedTrackingController;  // assignment and return on first allocation
        }
    }
    return nil; //on subsequent allocation attempts return nil	
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;	
}

#pragma mark - MMTrackingController Methods

// Call once from ApplicationDidFinishLaunchingWithOptions:.
- (void)startTracking
{
#ifdef USES_FLURRY
    [Flurry setAppVersion:@"1.0"]; // Optional
    [Flurry setCrashReportingEnabled:YES]; // Optional
	[Flurry startSession:kFlurryAPIKey];
#endif
#ifdef USES_GAITRACKER
    [GAI sharedInstance].dispatchInterval = kGANDispatchPeriodSec;
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    _tracker = [[GAI sharedInstance] trackerWithTrackingId:kGAAccountIDKey];
#endif
	[self logEvent:@"Launch" ];										   
}

// Call once from applicationWillTerminate: on iOS 3 & non-multitasking devices.
- (void)stopTracking
{
	[self logEvent:@"Terminate" ];
#ifdef USES_FLURRY
	// Nothing to do
#endif
#ifdef USES_GAITRACKER
	// Nothing to do
#endif
}

// Call to log an arbitrary event.
- (void)logEvent:(NSString*)event
{
#ifdef DEBUG	
	NSLog( @"Log Event: %@", event );
#endif
#ifdef USES_FLURRY
	[Flurry logEvent:event];
#endif
#ifdef USES_GAITRACKER
    [_tracker send:[[GAIDictionaryBuilder createEventWithCategory:kGACategoryKey action:event label:nil value:nil] build]];
#endif
}

// Call to log an error.
- (void)logError:(NSString *)errorID message:(NSString *)message exception:(NSException *)exception
{
#ifdef USES_FLURRY
	[Flurry logError:errorID message:message exception:exception];
#endif
#ifdef USES_GAITRACKER
    [_tracker send:[[GAIDictionaryBuilder createExceptionWithDescription:exception.description withFatal:[NSNumber numberWithBool:YES]] build]];
#endif
}

// Call to log a screen visit.
- (void)screenName:(NSString*)screen
{
#ifdef USES_GAITRACKER
    [_tracker send:@{kGAIScreenName:screen, kGAIHitType:kGAIAppView}];
#endif
}

@end
