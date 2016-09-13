//
//  TracksViewController.swift
//  Pedometer
//
//  Created by Kravis on 16/9/9.
//  Copyright © 2016年 Kravis Liu. All rights reserved.
//

import UIKit
import MapKit

class TracksViewController: UIViewController
{    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.mapType = .Standard
        let theCoordinate = CLLocationCoordinate2D(latitude: 39.925918, longitude: 116.201716)
        let theSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegionMake(theCoordinate, theSpan)
        
        mapView.setRegion(region, animated: true)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
