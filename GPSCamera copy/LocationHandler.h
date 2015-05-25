//
//  LocationHandler.h
//  GPSCamera
//
//  Created by rvill on 5/25/15.
//  Copyright (c) 2015 rvill. All rights reserved.
//

#ifndef GPSCamera_LocationHandler_h
#define GPSCamera_LocationHandler_h

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol LocationHandlerDelegate <NSObject>

@required
-(void) didUpdateToLocation:(CLLocation*)newLocation
               fromLocation:(CLLocation*)oldLocation;
@end

@interface LocationHandler : NSObject<CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
}
@property(nonatomic,strong) id<LocationHandlerDelegate> delegate;

+(id)getSharedInstance;
-(void)startUpdating;
-(void) stopUpdating;

@end
#endif
