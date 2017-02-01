//
//  TDetailViewController.h
//  Timely
//
//  Created by Aakash on 6/8/15.
//  Copyright (c) 2015 Aakash Thumaty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface TDetailViewController : UIViewController <UIScrollViewDelegate, MKMapViewDelegate, MKAnnotation>


@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *distance;
@property (nonatomic, retain) NSString *priceRange;
@property (nonatomic, retain) NSString *photoURL;
@property (nonatomic, retain) NSString *tags;
@property (nonatomic, retain) NSString *rating;
@property (nonatomic, retain) NSString *hoursss;
@property (nonatomic, retain) NSString *pNumber;
@property (nonatomic, retain) NSString *menu;

@property (nonatomic) float latitude;
@property (nonatomic) float longitude;

@property (nonatomic) float pLatitude;
@property (nonatomic) float pLongitude;

@end
