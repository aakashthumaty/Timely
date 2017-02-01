//
//  TSearchViewController.h
//  Timely
//
//  Created by Aakash on 6/8/15.
//  Copyright (c) 2015 Aakash Thumaty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface TSearchViewController : UIViewController <CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, retain) NSMutableArray *places;
@property (nonatomic, retain) NSMutableArray *timeList;
@property (nonatomic, retain) NSMutableArray *distList;

@property (nonatomic) CGPoint tapLocation;

@property (nonatomic) float latitude;
@property (nonatomic) float longitude;
@property (weak, nonatomic) IBOutlet UITableView *searchTableView;
@property (weak, nonatomic) IBOutlet UITextField *queryBar;
@property (weak, nonatomic) IBOutlet UITextField *timeBar;
@property (weak, nonatomic) IBOutlet UIButton *goButton;

@property(nonatomic, retain) CLLocationManager *locationManager;

@property (strong, nonatomic) IBOutlet UIPickerView *picker;




@end
