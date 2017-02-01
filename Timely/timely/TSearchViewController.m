//
//  TSearchViewController.m
//  Timely
//
//  Created by Aakash on 6/8/15.
//  Copyright (c) 2015 Aakash Thumaty. All rights reserved.
//

#import "TSearchViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "TDetailViewController.h"


@class MBProgressHUD;

@interface TSearchViewController ()
{
    MBProgressHUD *HUD;

    IBOutlet UIImageView *white;
    
    IBOutlet UILabel *welcomeLabel;
    
    IBOutlet UIButton *gotItButton;
    
    int count;
    NSDate *totalTime;
    int totalTimeInt;
    
    IBOutlet UILabel *nullState;
    
    int hours;
    int minutes;
    
    NSDate * now;
    NSDateFormatter *outputFormatter;
    
    NSCalendar *calendar;
    NSDateComponents *components;
    
    NSDateFormatter *dateFormatter;
    
    NSMutableDictionary *selectedPlace;
}

@end

@implementation TSearchViewController
@synthesize searchTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    _picker = [[UIPickerView alloc] init];
    _picker.delegate = self;
    _picker.dataSource = self;
    
    //rgb(52, 152, 219)
    [_queryBar setDelegate:self];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"h:mm"];
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm"];
    
    nullState.hidden = TRUE;
    
#ifdef __IPHONE_8_0

#endif
//    [self.locationManager startUpdatingLocation];
    
//    self.locationManager.distanceFilter = kCLDistanceFilterNone;
//    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//    [self.locationManager startUpdatingLocation];
//    NSLog(@"%@", self.locationManager.location);
    
//    [self.locationManager stopUpdatingLocation];
    
    _timeList = [[NSMutableArray alloc] init];
    _distList = [[NSMutableArray alloc] init];
    
    if(![self isLoggedIn]){
        [self.view addSubview:white];
        [self.view addSubview:welcomeLabel];
        [self.view addSubview:gotItButton];
        white.alpha = 1.0;
        welcomeLabel.alpha = 0.0;
        gotItButton.alpha = 0.0;
        CGSize labelSize = [welcomeLabel.text sizeWithAttributes:@{NSFontAttributeName:welcomeLabel.font}];
        
        welcomeLabel.frame = CGRectMake(
                                 welcomeLabel.frame.origin.x, welcomeLabel.frame.origin.y,
                                 welcomeLabel.frame.size.width, labelSize.height);
        
        [UIView animateWithDuration: 1.0f
                              delay: 0.0f
                            options: UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             welcomeLabel.alpha = 1.0;
                         }
                         completion:^(BOOL finished){
                             [UIView animateWithDuration:0.5f
                                                   delay: 1.0f
                                                 options: UIViewAnimationOptionCurveEaseIn
                                              animations:^{
                                                  welcomeLabel.alpha = 0.0;
                                              }
                                              completion:^(BOOL finished){
                                                  welcomeLabel.text = [NSString stringWithFormat:@"Enter a search term (Mexican,fast,\netc.) as well as how much time\nyou have and Timely will\nreturn optimal destinations for your\npreference and time limit."];
                                                  
                                                  [UIView animateWithDuration: 0.7f
                                                                        delay: 0.0f
                                                                      options: UIViewAnimationOptionCurveEaseIn
                                                                   animations:^{
                                                                       
                                                                       welcomeLabel.alpha = 1.0;
                                                                       //workButt.alpha = 1.0;
                                                                   }
                                                                   completion:^(BOOL finished){
                                                                       [UIView animateWithDuration: 0.7f
                                                                                             delay: 2.0f
                                                                                           options: UIViewAnimationOptionCurveEaseIn
                                                                                        animations:^{
                                                                                            
                                                                                            gotItButton.alpha = 1.0;
                                                                                            
                                                                                            
                                                                                        }
                                                                                        completion:^(BOOL finished){
                                                                                            

                                                                                            if(IS_OS_8_OR_LATER) {
                                                                                                // Use one or the other, not both. Depending on what you put in info.plist
                                                                                                [self.locationManager requestWhenInUseAuthorization];
                                                                                                
                                                                                            }
                                                                                            
                                                                                        }];
                                                                
                                                                       
                                }];
                            }];
                         }];

    
    }else{
        [white removeFromSuperview];
        [welcomeLabel removeFromSuperview];
        [gotItButton removeFromSuperview];
    }

    
    //picker = (UIDatePicker*)self.timeBar.inputView;

    // Do any additional setup after loading the view.
}

-(BOOL)isLoggedIn{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([[defaults objectForKey:@"loggedIn"] isEqualToString:@"YES"]){
        
        return YES;
    }
    else{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        
        [defaults setObject:@"YES" forKey:@"loggedIn"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        return NO;

    }
}
- (IBAction)gotIt:(id)sender {
    
    [UIView animateWithDuration: 0.7f
                          delay: 0.0f
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         gotItButton.alpha = 0.0f;
                         white.alpha = 0.0f;
                         welcomeLabel.alpha = 0.0f;
                         
                     }
                     completion:^(BOOL finished){
                         
                         [white removeFromSuperview];
                         [welcomeLabel removeFromSuperview];
                         [gotItButton removeFromSuperview];
                         
                     }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
 
    //[self.navigationController.navigationBar addSubview:(UIImageView *)[UIImage imageNamed:@"head.png"]];
    
    UINavigationBar *navBar = self.navigationController.navigationBar;
    UIImage *image = [UIImage imageNamed:@"nav.jpeg"];
    [navBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];

    
    self.navigationController.navigationBar.opaque = NO;
    
    //[self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
}

-(void)resignShit{
    [_timeList removeAllObjects];
    [_distList removeAllObjects];
    [_places removeAllObjects];
    
    [_queryBar resignFirstResponder];
    [_timeBar resignFirstResponder];
    _queryBar.selected = NO;
    _timeBar.selected = NO;
}


- (IBAction)searchGo:(id)sender {
    
    [self.locationManager startUpdatingLocation];

    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    NSLog(@"%@", self.locationManager.location);
    
    if(_timeBar.text.length == 0 || [_timeBar.text isEqualToString:@"00:00"]){
        UIAlertView *alert = [[UIAlertView alloc]
                              
            initWithTitle:@"Oops."
            message:@"Please enter how much time you have!"
            delegate:nil
            cancelButtonTitle:@"OK"
            otherButtonTitles:nil];
        
        [alert show];
        
        return;
    }
    [self resignShit];
    _latitude = self.locationManager.location.coordinate.latitude;
    _longitude = self.locationManager.location.coordinate.longitude;

    NSString *queryString = _queryBar.text;
    NSString *betterQueryString = [queryString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSDate *date = [dateFormatter dateFromString:self.timeBar.text];
    
    NSDateComponents *componentsTemp = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:date];
    
    //NSInteger hour = [components hour];
    //        NSInteger minute = [components minute];
    
    totalTime = date;
    
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Finding timely places...";
    hud.color = [UIColor colorWithRed:52.0/255.0 green:152.0/255.0 blue:219.0/255.0 alpha:0.80];
    [hud show:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        
        [self fetchPlacesWithLat:_latitude andLong:_longitude andQuery:betterQueryString completionBlock:^(BOOL success){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                for(int i = _places.count - 1; i >= 0; i--){
                    
                if([[_timeList objectAtIndex:i] floatValue]/60 > totalTimeInt/2){
                    
                    [_places removeObjectAtIndex:i];
                    [_timeList removeObjectAtIndex:i];
                    [_distList removeObjectAtIndex:i];
                }
                }
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                [self.searchTableView reloadData];
                [self wtf];

            });
            
        }];
        
    });


}

-(void)wtf{
    if([_places count] == 0){
        UIAlertView *alert = [[UIAlertView alloc]
                              
                              initWithTitle:@"Oops."
                              
                              message:@"Looks like we can't find any places, sorry. Enter a larger time frame or a different search term!"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        
    }
}

//-(void)fetchPlacesWithLat:(float)lat andLong:(float)lng completionBlock:(void (^)(BOOL success))completionBlock{
//    
//    if (totalTimeInt > 60){
//        
//    }
//    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/explore?client_id=D3ENYQKKAMZ2V15WBERUSJ4IFASQHB4FOD41BGLHOPYD53YK&client_secret=20CHU15IVGZFYS0AGRM1VNCKT210Q3TO2AGR5S3H1OCTE2IJ&v=20130815&ll=%f,%f&query=japanese&sortByDistance=1&limit=20",lat,lng]]];
//    if(data == nil){
//        UIAlertView *alert = [[UIAlertView alloc]
//                              
//                              initWithTitle:@"Oops."
//                              
//                              message:@"Looks like we can't find any places, sorry. Check if location services is turned on in Settings or check your network connection!"
//                              delegate:nil
//                              cancelButtonTitle:@"OK"
//                              otherButtonTitles:nil];
//        
//        [alert show];
//    }
//    else{
//        id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//        _places = [[[[[object objectForKey:@"response"] objectForKey:@"groups"] objectAtIndex:0] objectForKey:@"items"] mutableCopy];
//        completionBlock(YES);
//    }
//    
////    
//    //latitude & longitude are taken as parameters to the method
//    /*
//     https://api.foursquare.com/v2/venues/explore
//     ?client_id=D3ENYQKKAMZ2V15WBERUSJ4IFASQHB4FOD41BGLHOPYD53YK
//     &client_secret=20CHU15IVGZFYS0AGRM1VNCKT210Q3TO2AGR5S3H1OCTE2IJ
//     &v=20130815
//     &ll=40.7,-74
//     &query=sushi
//     
//     */
//}


-(void)fetchPlacesWithLat:(float)lat andLong:(float)lng andQuery:(NSString*)query completionBlock:(void (^)(BOOL success))completionBlock{
    int radius;
    int limit;
    if (totalTimeInt < 61){
        limit = 20;
        radius = 10000;
    }
    else if(totalTimeInt < 91){
        limit = 25;
        radius = 10000;

    }
    
    else if(totalTimeInt < 121){
        limit = 30;
        radius = 15000;

    }
    else{
        limit = 35;
        radius = 20000;

    }
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/explore?client_id=D3ENYQKKAMZ2V15WBERUSJ4IFASQHB4FOD41BGLHOPYD53YK&client_secret=20CHU15IVGZFYS0AGRM1VNCKT210Q3TO2AGR5S3H1OCTE2IJ&v=20130815&ll=%f,%f&query=%@&sortByDistance=1&limit=%d&radius=%d",lat,lng,query,limit,radius]]];
    if(data == nil){
        UIAlertView *alert = [[UIAlertView alloc]
                              
                              initWithTitle:@"Oops."
                              
                              message:@"Looks like we can't find any places, sorry. Check if location services is turned on in Settings or check your network connection!"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [alert show];
            });
        completionBlock(YES);
    }
    else{
        id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        //count = [[[[[object objectForKey:@"response"] objectForKey:@"groups"] objectAtIndex:0] objectForKey:@"items"] count];
        
        _places = [[[[[object objectForKey:@"response"] objectForKey:@"groups"] objectAtIndex:0] objectForKey:@"items"] mutableCopy];
        
        if([_places count] == 0){
            
           
            
        }else{
            
            for(int i = 0; i < [_places count]; i++){
            
                float latitudes = [[[[[_places objectAtIndex:i] objectForKey:@"venue"] objectForKey:@"location"] objectForKey:@"lat"] floatValue];
                float longitudes = [[[[[_places objectAtIndex:i] objectForKey:@"venue"] objectForKey:@"location"] objectForKey:@"lng"] floatValue];

                [self fetchGoogStuffWithLat:latitudes andLong:longitudes andInt:i completionBlock:^(BOOL success){
                
                
                //NSLog(_timeList);
                }];
            }
        }
        completionBlock(YES);
        
        }
    
}


-(void)fetchGoogStuffWithLat:(float)lat andLong:(float)lng andInt:(int)row completionBlock:(void (^)(BOOL success))completionBlock{
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f&key=AIzaSyDdDlBmwHhfmWIUB8kKdWMyh7E8TjdovXg",_latitude,_longitude,lat,lng]]];
 
    id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    if([[object objectForKey:@"routes"] count] > 0){
        
        if([[object objectForKey:@"routes"] objectAtIndex:0] != Nil){
            
    [_timeList addObject:[[[[[[object objectForKey:@"routes"] objectAtIndex:0] objectForKey:@"legs"] objectAtIndex:0] objectForKey:@"duration"] objectForKey:@"value"]];
    
    [_distList addObject:[[[[[[object objectForKey:@"routes"] objectAtIndex:0] objectForKey:@"legs"] objectAtIndex:0] objectForKey:@"distance"] objectForKey:@"text"]];
            
    completionBlock(YES);
        }
    }else{
        
        [_places removeObjectAtIndex:_timeList.count - 1];
        completionBlock(YES);

    }

    
    //json parsing done right (Google)
    ///[[[[[[object objectForKey:@"routes"] objectAtIndex:0] objectForKey:@"legs"] objectAtIndex:0] objectForKey:@"duration"] objectForKey:@"text"]
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)outsideTouch:(id)sender {
    [_queryBar resignFirstResponder];
}

- (IBAction)enterTapped:(id)sender {
    _queryBar.selected = NO;
    [_queryBar resignFirstResponder];
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    
    return 2;//Or return whatever as you intend
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component{
    if(component == 0){
    return 12;//Or, return as suitable for you...normally we use array for dynamic
    }
    return 60;
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"%ld",(long)row];//Or, your suitable title; like Choice-a, etc.
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    //Here, like the table view you can get the each section of each row if you've multiple sections
    
    if(component == 0){
        hours = (int)row ;
    }else{
        minutes = (int)row ;
    }
    
    totalTimeInt = hours*60 + minutes;
    
    NSString *string = [NSString stringWithFormat:@"%d:%d", hours, minutes];
    NSDate *date = [outputFormatter dateFromString:string];
    
    self.timeBar.text = [self formatDate:date];
    
    NSLog(@" Index of selected row: %li", (long)row);
    
    //Now, if you want to navigate then;
    // Say, OtherViewController is the controller, where you want to navigate:

    
}

- (IBAction)timeBarDidBeginEditing:(id)sender {
    
    UILabel *hourLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, _picker.frame.size.height / 2 - 15, 75, 30)];
    hourLabel.text = @"hours";
    [_picker addSubview:hourLabel];
    
    UILabel *minsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 + (_picker.frame.size.width / 2), _picker.frame.size.height / 2 - 15, 75, 30)];
    minsLabel.text = @"minutes";
    [_picker addSubview:minsLabel];
    


    
    hours = 0;
    minutes = 0;
    
    // Create a date picker for the date field.
    
//    
//    picker.datePickerMode = UIDatePickerModeCountDownTimer;
//    picker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
//    //datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:-31536000];
//    [picker setDate:[NSDate dateWithTimeIntervalSinceNow:0] animated:true ];
    
    //picker.setDate(date, animated: true)  [self.datePicker setDate:[NSDate date] animated:YES];

    // If the date field has focus, display a date picker instead of keyboard.
    // Set the text to the date currently displayed by the picker.

    
    self.timeBar.inputView = _picker;
    
    [self.picker selectRow:0 inComponent:0 animated:YES];
    
    NSString *string = [NSString stringWithFormat:@"%d:%d", hours, minutes];
    NSDate *date = [outputFormatter dateFromString:string];
    
    self.timeBar.text = [self formatDate:date];
//        self.timeBar.text = [self formatDate:picker];
    
}
//
//
//// Called when the date picker changes.
//- (void)updateDateField:(id)sender
//{
//
//    self.timeBar.text = [self formatDate:picker.date];
//}


// Formats the date chosen with the date picker.

- (NSString *)formatDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setDateStyle:NSDateFormatterShortStyle];
//    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"NL"];
//    [dateFormatter setLocale:locale];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *formattedDate = [dateFormatter stringFromDate:date];
    return formattedDate;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //NSLog(@"%@", _places.count);
    return [_places count];
}

- (IBAction)keyboard:(id)sender {
    [_queryBar becomeFirstResponder];


}

- (NSInteger)numberOfSectionsInTableView: (UITableView *) tableView{
    
    
    
    if(_places.count == 0){
        
        self.searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        nullState.hidden = FALSE;
        return 0;
    }
    nullState.hidden = TRUE;
    self.searchTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.searchTableView.separatorColor = [UIColor lightGrayColor];
    return 1;

}
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"place";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    UILabel *nameLabel = (UILabel*) [cell viewWithTag:3];
    nameLabel.text = [[[_places objectAtIndex:indexPath.row] objectForKey:@"venue"] objectForKey:@"name"];
    
    UILabel *num = (UILabel*) [cell viewWithTag:2];
    num.text = [NSString stringWithFormat:@"%ld.",(long)indexPath.row+1];
    
    UILabel *dist = (UILabel*) [cell viewWithTag:6];
    dist.textAlignment = UITextAlignmentCenter;
    dist.text = [NSString stringWithFormat:@"%@",[_distList objectAtIndex:indexPath.row]];
    
    UILabel *rating = (UILabel *) [cell viewWithTag:100];
    rating.textAlignment = UITextAlignmentCenter;
    NSString *actRat = [NSString stringWithFormat:@"%@",[[[_places objectAtIndex:indexPath.row] objectForKey:@"venue"] objectForKey:@"rating"]];
    if(actRat.length >= 3){
    actRat = [actRat substringToIndex:3];
    }
    
    if([actRat  isEqual: @"(nu"]){
        actRat = @"7";
    }
    rating.text = [NSString stringWithFormat:@"%@/10",actRat];
    
    now = [NSDate date];
    NSString *newDateString = [outputFormatter stringFromDate:now];
    //NSLog(@"newDateString %@", newDateString);
    
    
    UILabel *timeOne = (UILabel*) [cell viewWithTag:4];
    timeOne.text = [NSString stringWithFormat:@"%@",newDateString];
    
        calendar = [NSCalendar currentCalendar];
        components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:totalTime];
//        NSInteger hour = [components hour];
//        NSInteger minute = [components minute];
    
    NSDate *newDate= [calendar dateByAddingComponents:components toDate:[outputFormatter dateFromString:newDateString] options:0];
    
    
    UILabel *timeTwo = (UILabel*) [cell viewWithTag:5];
    timeTwo.text = [NSString stringWithFormat:@"%@",[outputFormatter stringFromDate:newDate]];
    
    NSNumber *seconds = [_timeList objectAtIndex:indexPath.row];
    

    NSDateComponents *arrivalComponents = [NSDateComponents new];
    NSDateComponents *departureComponents = [NSDateComponents new];

    
//    if(seconds < 60){
//    arrivalComponents.minute = 1;
//    }
//    else{
//        int toAdd = seconds;
//        NSNumber *adding = [NSNumber numberWithInt:toAdd/60];
//        arrivalComponents.minute = adding;
//        
//    }
    arrivalComponents.minute = [seconds floatValue]/60;
    arrivalComponents.minute ++;
    
    departureComponents.minute = [seconds floatValue]*-1/60;
    departureComponents.minute --;
    
    NSDate *arrival = [[NSCalendar currentCalendar]dateByAddingComponents:arrivalComponents
                                                                   toDate: [outputFormatter dateFromString:newDateString]
                                                                  options:0];
    
    NSDate *departure = [[NSCalendar currentCalendar]dateByAddingComponents:departureComponents
                                                                   toDate: [outputFormatter dateFromString:[outputFormatter stringFromDate:newDate]]
                                                                  options:0];
    
    
    UILabel *timeThree = (UILabel*) [cell viewWithTag:7];
    timeThree.text = [NSString stringWithFormat:@"%@",[outputFormatter stringFromDate:arrival]];
    
    UILabel *timeFour = (UILabel*) [cell viewWithTag:8];
    timeFour.text = [NSString stringWithFormat:@"%@",[outputFormatter stringFromDate:departure]];
    
    UILabel *address = (UILabel*) [cell viewWithTag:10];

    address.text = [NSString stringWithFormat:@"%@, %@, %@",[[[[_places objectAtIndex:indexPath.row] objectForKey:@"venue"] objectForKey:@"location"] objectForKey:@"address"],[[[[_places objectAtIndex:indexPath.row] objectForKey:@"venue"] objectForKey:@"location"] objectForKey:@"city"],[[[[_places objectAtIndex:indexPath.row] objectForKey:@"venue"] objectForKey:@"location"] objectForKey:@"state"]];
    
    if([[address.text substringToIndex:3] isEqualToString:@"(nu"]){
        address.text = [NSString stringWithFormat:@"%@", [[[[[_places objectAtIndex:indexPath.row] objectForKey:@"venue"] objectForKey:@"location"] objectForKey:@"formattedAddress"] objectAtIndex:0]];
    }

//
//    UILabel *categories = (UILabel*) [cell viewWithTag:5];
//    if([[[[_places objectAtIndex:indexPath.row] objectForKey:@"venue"] objectForKey:@"categories"] count] > 1)
//        categories.text = [NSString stringWithFormat:@"%@,%@",[[[[[_places objectAtIndex:indexPath.row] objectForKey:@"venue"] objectForKey:@"categories"] objectAtIndex:0] objectForKey:@"name"],[[[[[_places objectAtIndex:indexPath.row] objectForKey:@"venue"] objectForKey:@"categories" ] objectAtIndex:1]objectForKey:@"name"]];
//    else{
//        categories.text = [NSString stringWithFormat:@"%@",[[[[[_places objectAtIndex:indexPath.row] objectForKey:@"venue"] objectForKey:@"categories"] objectAtIndex:0] objectForKey:@"name"]];
//    }
    
    
    
    //NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/directions/json?origi%f/%f&destination=%@/%@&key=AIzaSyDdDlBmwHhfmWIUB8kKdWMyh7E8TjdovXg",_latitude,_longitude,[[[[_places objectAtIndex:indexPath.row] objectForKey:@"venue"] objectForKey:@"location"] objectForKey:@"lat"],[[[[_places objectAtIndex:indexPath.row] objectForKey:@"venue"] objectForKey:@"location"]  objectForKey:@"lng"]]]];
    
    //id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    //AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

//    NSLog(@"%f",appDelegate.marker);
//    int time = [[object objectForKey:@"duration"] objectForKey:@"value"];
//https://maps.googleapis.com/maps/api/directions/json?origin=Toronto&destination=Montreal&key=AIzaSyDdDlBmwHhfmWIUB8kKdWMyh7E8TjdovXg

    
//    float latitudes = [[[[[_places objectAtIndex:indexPath.row] objectForKey:@"venue"] objectForKey:@"location"] objectForKey:@"lat"] floatValue];
//    float longitudes = [[[[[_places objectAtIndex:indexPath.row] objectForKey:@"venue"] objectForKey:@"location"] objectForKey:@"lng"] floatValue];
//    
//    [self fetchGoogStuffWithLat:latitudes andLong:longitudes andInt:indexPath.row completionBlock:^(BOOL success){
//        
//        
//        NSLog(_timeList);
//    }];

    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Do some stuff when the row is selected
    NSString *ident = [[[_places objectAtIndex:indexPath.row] objectForKey:@"venue"] objectForKey:@"id"];
    
    [self fetchPlaceDetailsWithID:ident completionBlock:^(BOOL success){
    
        
        TDetailViewController *detailViewController = (TDetailViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"detail"];
        
        detailViewController.name = [[[_places objectAtIndex:indexPath.row] objectForKey:@"venue"] objectForKey:@"name"];
        
        detailViewController.address = [NSString stringWithFormat:@"%@, %@, %@",[[[[_places objectAtIndex:indexPath.row] objectForKey:@"venue"] objectForKey:@"location"] objectForKey:@"address"],[[[[_places objectAtIndex:indexPath.row] objectForKey:@"venue"] objectForKey:@"location"] objectForKey:@"city"],[[[[_places objectAtIndex:indexPath.row] objectForKey:@"venue"] objectForKey:@"location"] objectForKey:@"state"]];
        if([[detailViewController.address substringToIndex:3] isEqualToString:@"(nu"]){
                   detailViewController.address = [NSString stringWithFormat:@"%@", [[[selectedPlace objectForKey:@"location"] objectForKey:@"formattedAddress"] objectAtIndex:0]];
        }
 
        
        detailViewController.distance = [NSString stringWithFormat:@"%@",[_distList objectAtIndex:indexPath.row]];
        
        NSString *tags = [[NSString alloc] init];
        int f = [[selectedPlace objectForKey:@"tags"] count];
        for (int i = 0; i < f; i++){
            if (i == 0){
                tags = [[selectedPlace objectForKey:@"tags"] objectAtIndex:0];
            }
            else{
                tags = [tags stringByAppendingFormat:@", %@",[[selectedPlace objectForKey:@"tags"] objectAtIndex:i] ];
            }
        }
        if (tags.length == 0){
            if(_queryBar.text.length != 0)
                tags = _queryBar.text;
        }
        detailViewController.tags = tags;

        NSString *actRat = [NSString stringWithFormat:@"%@",[[[_places objectAtIndex:indexPath.row] objectForKey:@"venue"] objectForKey:@"rating"]];
        if(actRat.length >= 3){
        actRat = [actRat substringToIndex:3];
        }
        if([actRat  isEqual: @"(nu"]){
            actRat = @"7";
        }
        detailViewController.rating = [NSString stringWithFormat:@"%@/10",actRat];
        
        detailViewController.distance = [_distList objectAtIndex:indexPath.row];
        
        detailViewController.photoURL = [NSString stringWithFormat:@"%@361x248%@",[[selectedPlace objectForKey:@"bestPhoto"] objectForKey:@"prefix"], [[selectedPlace objectForKey:@"bestPhoto"] objectForKey:@"suffix"]];
        
        if([[[selectedPlace objectForKey:@"price"] objectForKey:@"tier"] intValue] == 1){
            detailViewController.priceRange = @"$";

        }
        else if ([[[selectedPlace objectForKey:@"price"] objectForKey:@"tier"] intValue] == 2){
            detailViewController.priceRange = @"$$";

        }
        else if([[[selectedPlace objectForKey:@"price"] objectForKey:@"tier"] intValue] == 3){
            detailViewController.priceRange = @"$$$";

        }
        else{
            detailViewController.priceRange = @"$$";
        }
        for(int x = 0; x < [[[selectedPlace  objectForKey:@"hours"] objectForKey:@"timeframes"] count]; x++){
            
            if ([[[[[selectedPlace  objectForKey:@"hours"] objectForKey:@"timeframes"] objectAtIndex:x] objectForKey:@"includesToday"] boolValue] == TRUE){
                NSString *hoursString = [[NSString alloc] init];
                NSString *daysString = [NSString stringWithFormat:@"%@",[[[[selectedPlace  objectForKey:@"hours"] objectForKey:@"timeframes"] objectAtIndex:x] objectForKey:@"days"]];
                
                for(int z = 0; z < [[[[[selectedPlace  objectForKey:@"hours"] objectForKey:@"timeframes"] objectAtIndex:x] objectForKey:@"open"] count]; z++){
                    hoursString = [hoursString stringByAppendingString:[[[[[[selectedPlace  objectForKey:@"hours"] objectForKey:@"timeframes"] objectAtIndex:x] objectForKey:@"open"] objectAtIndex:z] objectForKey:@"renderedTime"]];
                }
                NSString *shit = [NSString stringWithFormat:@"%@: %@",daysString,hoursString];
                detailViewController.hoursss = shit;
                

            }
        }
        
        if (detailViewController.hoursss == NULL){
            detailViewController.hoursss = [NSString stringWithFormat:@"%@",[[selectedPlace objectForKey:@"popular"] objectForKey:@"status"]];
        }
        if ([detailViewController.hoursss isEqualToString:@"(null)"]){
            detailViewController.hoursss = [NSString stringWithFormat:@"unavailable"];
        }
        detailViewController.latitude = _latitude;
        detailViewController.longitude = _longitude;
        
        detailViewController.pNumber = [[selectedPlace objectForKey:@"contact"] objectForKey:@"phone"];
        
        detailViewController.menu = [[selectedPlace objectForKey:@"menu"] objectForKey:@"mobileUrl"];
        
        if([[selectedPlace objectForKey:@"menu"] objectForKey:@"mobileUrl"] == NULL){
            detailViewController.menu = [selectedPlace objectForKey:@"shortUrl"];
            
        }
        
        detailViewController.pLatitude = [[[selectedPlace objectForKey:@"location"] objectForKey:@"lat"] floatValue];
        detailViewController.pLongitude = [[[selectedPlace objectForKey:@"location"] objectForKey:@"lng"] floatValue];

        [self.navigationController pushViewController:detailViewController animated:YES];
    }];
    

    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)fetchPlaceDetailsWithID:(NSString *)identifier completionBlock:(void (^)(BOOL success))completionBlock{
    
    selectedPlace = [[NSMutableDictionary alloc] init];
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/%@?client_id=D3ENYQKKAMZ2V15WBERUSJ4IFASQHB4FOD41BGLHOPYD53YK&client_secret=20CHU15IVGZFYS0AGRM1VNCKT210Q3TO2AGR5S3H1OCTE2IJ&v=20130815",identifier]]];
    
    if(data == nil){
        UIAlertView *alert = [[UIAlertView alloc]
                              
                              initWithTitle:@"Oops."
                              
                              message:@"Looks like we can't find any places, sorry. Check if location services is turned on in Settings or check your network connection!"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [alert show];
        });
    }
    else{
        id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        selectedPlace = [[[object objectForKey:@"response"] objectForKey:@"venue"] mutableCopy];
        
    }
    
    completionBlock(YES);

    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
