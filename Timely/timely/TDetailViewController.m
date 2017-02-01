//
//  TDetailViewController.m
//  Timely
//
//  Created by Aakash on 6/8/15.
//  Copyright (c) 2015 Aakash Thumaty. All rights reserved.
//

#import "TDetailViewController.h"
#import <MapKit/MapKit.h>

@interface TDetailViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *coverImg;
@property (strong, nonatomic) IBOutlet UIScrollView *scrolly;
@property (strong, nonatomic) IBOutlet UILabel *placeName;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *tagsLabel;
@property (strong, nonatomic) IBOutlet UILabel *ratingLabel;
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UILabel *hoursLabel;

@end

@implementation TDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
        UIGraphicsBeginImageContext(self.view.frame.size);
        [[UIImage imageNamed:@"work.jpeg"] drawInRect:self.view.bounds];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    
        self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    _mapView.showsUserLocation = YES;
    _mapView.mapType = MKMapTypeHybrid;
    _mapView.delegate = self;
    
    MKPointAnnotation *mapPoint = [[MKPointAnnotation alloc] init];
    mapPoint.coordinate = CLLocationCoordinate2DMake(_pLatitude, _pLongitude);
    mapPoint.title = _name;
    
    // Add it to the map view
    [self.mapView addAnnotation:mapPoint];
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(mapPoint.coordinate, 1600, 1600);
    [self.mapView setRegion:region];
    
    [NSThread detachNewThreadSelector:@selector(getImage) toTarget:self withObject:nil];
    _placeName.text = _name;
    _addressLabel.text = _address;
    _tagsLabel.text = _tags;
    _ratingLabel.text = _rating;
    _distanceLabel.text = _distance;
    _priceLabel.text = _priceRange;
    _hoursLabel.text = _hoursss;
    
    [self.view bringSubviewToFront:_placeName];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    _scrolly.delegate = self;
    CGRect scrollFrame;
    scrollFrame.origin = _scrolly.frame.origin;
    scrollFrame.size = CGSizeMake(screenWidth,  1200);
    _scrolly.frame = scrollFrame;
    _scrolly.contentSize = scrollFrame.size;
    
    //_scrolly.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgIMG.png"]];
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgIMG.png"]];
    

    // Do any additional setup after loading the view.
}
- (IBAction)getDirections:(id)sender {
    
    NSString* url = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f",_latitude, _longitude, _pLatitude, _pLongitude];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
}
- (IBAction)makeACall:(id)sender {
    NSString *phoneNumber =[NSString stringWithFormat:@"tel:%@", _pNumber];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];

}
- (IBAction)goToMenu:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_menu]];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{

}

-(void)getImage{
    NSURL *url = [NSURL URLWithString:_photoURL];
    
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    
    UIImage *tmpImage = [[UIImage alloc] initWithData:data];
    
    _coverImg.image = tmpImage;
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
