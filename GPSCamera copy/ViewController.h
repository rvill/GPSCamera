//
//  ViewController.h
//  GPSCamera
//
//  Created by rvill on 5/25/15.
//  Copyright (c) 2015 rvill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationHandler.h"

@interface ViewController : UIViewController<LocationHandlerDelegate>
{
    IBOutlet UILabel *latitudeLabel;
    IBOutlet UILabel *longitudeLabel;
}
@end


