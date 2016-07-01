//
//  ViewController.m
//  Reverse Geocode Live Demo 01
//
//  Created by Felipe Lefevre Marino on 4/3/16.
//  Copyright © 2016 Felipe Lefevre Marino. All rights reserved.
//

#import "ViewController.h"
@import CoreLocation;
@import MapKit;

@interface ViewController () <MKMapViewDelegate>

@property (strong, nonatomic) CLGeocoder *geocoder;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *geocodeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pinIcon;
@property (assign, nonatomic) BOOL lookUp;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    
    self.geocoder = [[CLGeocoder alloc] init];
    self.geocodeLabel.text = nil;
    self.geocodeLabel.alpha = 0.5;
    
    self.lookUp = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Private

-(void)executeTheLookUp {
    if (self.lookUp == NO) {
        
        self.lookUp = YES;
        
        CLLocationCoordinate2D coord = [self locationAtCenterOfMapView];
        CLLocation* loc = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
        [self startReverseGeocodeLocation: loc];
    }
}

-(CLLocationCoordinate2D)locationAtCenterOfMapView {
    
    CGPoint centerOfPin = CGPointMake(CGRectGetMidX(self.pinIcon.bounds), CGRectGetMidY(self.pinIcon.bounds));
    return [self.mapView convertPoint:centerOfPin toCoordinateFromView:self.pinIcon];
}

-(void)startReverseGeocodeLocation:(CLLocation*)location {
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        if (error) {
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"There was a problem reverse geocoding" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:ac animated:YES completion:nil];
            return;
        }
        
        // Grab some interesting bits of CLPlacemarkand show it
        // But no dupes
        NSMutableSet* mappedPlacesDescs = [NSMutableSet new];
        for (CLPlacemark *p in placemarks) {
            if (p.name != nil)
                [mappedPlacesDescs addObject:p.name];
            if (p.administrativeArea != nil)
                [mappedPlacesDescs addObject:p.administrativeArea];
            if (p.country != nil)
                [mappedPlacesDescs addObject:p.country];
            [mappedPlacesDescs addObjectsFromArray:p.areasOfInterest];
        }
        self.geocodeLabel.text = [[mappedPlacesDescs allObjects] componentsJoinedByString:@"\n"];
        self.geocodeLabel.alpha = 1.0;
        
        self.lookUp = NO;
    }];
    
}

#pragma mark - MapViewDelegate
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    [self executeTheLookUp];
}



@end
