Shared Tracking Controller
==========================

This is the Shared Tracking Controller code which can be used to easily manage multiple iOS analytics packages. Included in this code are configurations for [Flurry](http://www.flurry.com), [Google Analytics](http://www.google.com/analytics), and [Localytics](http://www.localytics.com). It should be easy to adapt this to most new analytics APIs.

TrackingController is a singleton instance. You invoke all methods by first calling +[TrackingController sharedTrackingController].

Usage
-----

Include the three files TrackingController.h, TrackingController.m, and TrackingControllerDefs.h to your project. Modify TrackingControllerDefs.h to reference your application key, account ID, etc. as needed. Comment out the services you don't want to use.

In you application delegate you must do at least the following:

    #import "TrackingController.h"

    - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
		[[TrackingController sharedTrackingController] startTracking];
	}
	
	- (void)applicationWillTerminate:(UIApplication*)application {
		[[TrackingController sharedTrackingController] stopTracking];
	}
	
If your application supports multitasking on iSO 4.x, you should also add the following calls:

	- (void)applicationWillEnterForeground:(UIApplication *)application {
		[[TrackingController sharedTrackingController] logEvent:@"EnterForeground" ];
	}

	- (void)applicationDidEnterBackground:(UIApplication *)application {
		[[TrackingController sharedTrackingController] logEvent:@"EnterBackground" ];
	}

This will properly trigger suspend/resume handling of the tracking code. See -[TrackingController logEvent] for example of how Localytics handles this case.

Any place in your code where you'd like to track an interesting event, simply add a line like this:

	[[TrackingController sharedTrackingController] logEvent:@"eventOfInterest" ];
	
Note: Flurry has a special "error handler" that you can use to log exceptions to. You need to install the exception handler and invoke -[TrackingController logError] like this:

	void uncaughtExceptionHandler(NSException *exception) {
		[[TrackingController sharedTrackingController] logError:@"Uncaught Exception" message:@"Crash!" exception:exception];
	}                                       

    - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
		NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
		[[TrackingController sharedTrackingController] startTracking];
	}
	
License
-------

This source code is licensed under The MIT License. Enjoy.