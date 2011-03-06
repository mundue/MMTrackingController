Shared Tracking Controller
==========================

This is the Shared Tracking Controller code which can be used to easily manage multiple iOS analytics packages. Included in this code are configurations for [Flurry](http://www.flurry.com), [Google Analytics](http://www.google.com/analytics), and [Localytics](http://www.localytics.com). It should be easy to adapt this to most new analytics APIs.

Usage
-----

Include the three files TrackingController.h, TrackingController.m, and TrackingControllerDefs.h to your project. Modify TrackingControllerDefs.h to reference your application key, account ID, etc. as needed. Comment out the services you don't want to use.

In you application delegate you must do at least the following:

    #import "TrackingController.h"

    - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
		[[TrackingController sharedTrackingController] startTracking];
		[[TrackingController sharedTrackingController] logEvent:@"Launch"];
	}
	
	- (void)applicationWillTerminate:(UIApplication*)application {
		[[TrackingController sharedTrackingController] stopTracking];
	}
	
If your applications supports multitasking on iSO 4.x, you should also add the following calls:

	- (void)applicationWillEnterForeground:(UIApplication *)application {
		[[TrackingController sharedTrackingController] logEvent:@"EnterForeground" ];
	}

	- (void)applicationDidEnterBackground:(UIApplication *)application {
		[[TrackingController sharedTrackingController] logEvent:@"EnterBackground" ];
	}

This will properly trigger suspend/resume handling of the tracking code. See -[TrackingController logEvent] for example of how Localytics handles this case.

Any place in your code where you'd like to track an interesting event, simply add a line like this:

	[[TrackingController sharedTrackingController] logEvent:@"eventOfInterest" ];

License
-------

This source code is licensed under The MIT License. Enjoy.