//
//  ViewController.swift
//  Ssteps
//
//  Created by Elizabeth Gentile on 7/27/17.
//  Copyright © 2017 Elizabeth Gentile. All rights reserved.
//

import UIKit
import MapKit
import Foundation


class ViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self as? CLLocationManagerDelegate
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        makeGetCall()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let location = locations.last as! CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.mapView.setRegion(region, animated: true)
    }
    func makeGetCall() {
        // Set up the URL request
        let todoEndpoint: String = "https://brigades.opendatanetwork.com/resource/u4cw-q86b.json"
        guard let url = URL(string: todoEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = URLRequest(url: url)
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                print("error calling GET on /todos/1")
                return
            }
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            let string1 = String(data: responseData, encoding: String.Encoding.utf8) ?? "Data could not be printed"
            print(string1)

            // parse the result as JSON
            do {

                guard let todo = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: AnyObject] else {
                    print("error trying to convert data to JSON")
                    return
                }
                // now we have the todo, let's just print it to prove we can access it
                print("The todo is: " + todo.description)
                
                // the todo object is a dictionary
                // so we just access the title using the "title" key
                // so check for a title and print it if we have one
                guard let todoTitle = todo["title"] as? String else {
                    print("Could not get todo title from JSON")
                    return
                }
                print("The title is: " + todoTitle)
            } catch  {
                print("error trying to convert title? to JSON")
                return
            }
        }
        task.resume()
    }
}

