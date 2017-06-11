//
//  ViewController.swift
//  panic
//
//  Created by Sarat Vemulapalli on 6/10/17.
//  Copyright © 2017 Sarat Vemulapalli. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import MessageUI
class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var manager = CLLocationManager?()
    
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //[super viewDidLoad];
        if let _ = self.mapView {
            self.mapView.setRegion(MKCoordinateRegionMake(self.mapView.userLocation.coordinate, MKCoordinateSpanMake(0.1, 0.1)), animated: true)
        }
        manager = CLLocationManager()
        let latitude: CLLocationDegrees = -33.8634
        let longitude: CLLocationDegrees = 151.211
        let center: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let radius: CLLocationDistance = CLLocationDistance(100.0)
        let identifier: String = "Facebook` "
        let currRegion = CLCircularRegion(center: center, radius: radius, identifier: identifier)
        
        manager?.distanceFilter = 10
        manager?.desiredAccuracy = kCLLocationAccuracyBest
        currRegion.notifyOnEntry = true
        currRegion.notifyOnExit = true
        
        manager?.requestAlwaysAuthorization()
        
        
        manager?.delegate = self
        manager?.pausesLocationUpdatesAutomatically = true
        
        manager?.startMonitoringForRegion(currRegion)
        manager?.startUpdatingLocation()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didStartMonitoringForRegion region: CLRegion) {
        print("The monitored regions are: \(manager.monitoredRegions)")
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion)  {
        NSLog("Entered")
        print("Entered")
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        NSLog("Exited")
        //let mescontroller = MFMessageComposeViewController()
        //let res = MessageComposeResult(1)
        //messageComposeViewController(mescontroller, didFinishWithResult: res)
        sendSMS();
        print("Exited")
    }
    
    /*func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        //... handle sms screen actions
        print("Func called")
        
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = "Emergency SOS, I am in trouble"
            controller.recipients = ["6692267357"]
            controller.messageComposeDelegate = self
            self.presentViewController(controller, animated: true, completion: nil)
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }*/
    func sendSMS()
    {
        
        let twilioSID = "ACd05d1173656d28ded96f2da227f8b652"
        let twilioSecret = "e5543ac55fd7dc8689a72d07f26305e4"
        
        //Note replace + = %2B , for To and From phone number
        let fromNumber = "%2B18315316170"// actual number is +14803606445
        let toNumber = "%2B16692267357"// actual number is +919152346132
        let message = "Emergency, I am in trouble"
        
        // Build the request
        let request = NSMutableURLRequest(URL: NSURL(string:"https://\(twilioSID):\(twilioSecret)@api.twilio.com/2010-04-01/Accounts/\(twilioSID)/SMS/Messages")!)
        request.HTTPMethod = "POST"
        request.HTTPBody = "From=\(fromNumber)&To=\(toNumber)&Body=\(message)".dataUsingEncoding(NSUTF8StringEncoding)
        
        // Build the completion block and send the request
        NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) in
            print("Finished")
            if let data = data, responseDetails = NSString(data: data, encoding: NSUTF8StringEncoding) {
                // Success
                print("Response: \(responseDetails)")
            } else {
                // Failure
                print("Error: \(error)")
            }
        }).resume()
    }
    
    
    
}

