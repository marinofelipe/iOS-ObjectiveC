//
//  ViewController.m
//  DeviceAdptivity
//
//  Created by Felipe Lefevre Marino on 1/25/16.
//  Copyright © 2016 Felipe Lefevre Marino. All rights reserved.
//

#import "ViewController.h"
#import "MapKit/MapKit.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // initialize web page
    NSString* webURL = @"http://www.vikings.com";
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:webURL]];
    [self.webView loadRequest:request];
    
    // center the map
    double latitude = 44.9708661;
    double longitude = -93.2598137;
    
    MKPointAnnotation* wiclAnno = [[MKPointAnnotation alloc] init];
    wiclAnno.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    wiclAnno.title = @"Minnesota Vikings - U.S. Bank Stadium";
    
    [self.mapView addAnnotation:wiclAnno];
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(wiclAnno.coordinate, 10000, 10000);
    MKCoordinateRegion adjusted = [self.mapView regionThatFits:region];
    [self.mapView setRegion:adjusted animated:YES];
}

@end
