Shared Tracking Controller
==========================

This is the MMTrackingController code which can be used to easily manage multiple iOS analytics packages. Included in this code are configurations for [Flurry][] and [Google Analytics][]. It should be easy to adapt this to most new analytics APIs.

   [Flurry]: http://www.flurry.com "Flurry"
   [Google Analytics]: http://www.google.com/analytics "Google Analytics"

Usage
-----

Include the three files MMTrackingController.h, MMTrackingController.m, and MMTrackingControllerDefs.h to your project. Modify MMTrackingControllerDefs.h to reference your application key, account ID, etc. as needed. Comment out the services you don't want to use. Add the libs & headers for the individual services as needed.

MMTrackingController is a singleton instance. You invoke all methods by first calling +[MMTrackingController sharedTrackingController].

In your application delegate you must do at least the following:

    #import "MMTrackingController.h"

    - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
		[[MMTrackingController sharedTrackingController] startTracking];
	}
	
	- (void)applicationWillTerminate:(UIApplication*)application {
		[[MMTrackingController sharedTrackingController] stopTracking];
	}
	
If your application supports multitasking on iOS 4.x, you should also add the following calls:

	- (void)applicationWillEnterForeground:(UIApplication *)application {
		[[MMTrackingController sharedTrackingController] logEvent:@"EnterForeground"];
	}

	- (void)applicationDidEnterBackground:(UIApplication *)application {
		[[MMTrackingController sharedTrackingController] logEvent:@"EnterBackground"];
	}

This will properly trigger suspend/resume handling of the tracking code, if needed.

Any place in your code where you'd like to track an interesting event, simply add a line like this:

	[[MMTrackingController sharedTrackingController] logEvent:@"eventOfInterest"];

Google also lets you track screens “visited” by subclassing the GAITrackedViewController. Alternatively you can report screens with calls like like:

	[[MMTrackingController sharedTrackingController] screenName:@“SettingsScreen”];
	
Note: Flurry has a special "error handler" that you can use to log exceptions to. You need to install the exception handler and invoke -[MMTrackingController logError] like this:

	void uncaughtExceptionHandler(NSException *exception) {
		[[MMTrackingController sharedTrackingController] logError:@"Uncaught Exception" message:@"Crash!" exception:exception];
	}                                       

    - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
		NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
		[[MMTrackingController sharedTrackingController] startTracking];
	}
	
License
-------

This source code is licensed under The MIT License. Enjoy.