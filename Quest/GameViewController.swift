//
//  GameViewController.swift
//  Quest
//
//  Created by Yurii Troniak on 9/21/17.
//  Copyright © 2017 Yurii Troniak. All rights reserved.
//

import UIKit

import Mapbox
import MapboxDirections
import MapboxNavigation

class GameViewController: UIViewController , MGLMapViewDelegate, CLLocationManagerDelegate  {
    var timer:Timer!
    var questInfo: Quests_list!
    let locationManager = CLLocationManager()
    var mapView: MGLMapView!
    var currentIndex = 0
    var lastKnownCoordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var totalCheckpointsCount = 0
    var routeLine: MGLPolyline?
    
    @IBOutlet weak var gameView: UIView!
    @IBOutlet weak var nextPointDistance: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var checkpointsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        // set total count
        totalCheckpointsCount = (questInfo.markers?.count)!
        checkpointsLabel.text = "0 of \(totalCheckpointsCount)"
        
        //timer for update map
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.updateMapTimer), userInfo: nil, repeats: true)
        updateMapTimer()
        
        let styleURL = NSURL(string: "mapbox://styles/mapbox/navigation-preview-night-v2")
        mapView = MGLMapView(frame: gameView.bounds,
                                 styleURL: styleURL as URL?)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // Set the map’s center coordinate and zoom level.
        mapView.setCenter(CLLocationCoordinate2D(latitude: questInfo.markers![0].lat!,
                                                 longitude: questInfo.markers![0].lon!),
                          zoomLevel: 16, animated: false)
        mapView.userLocationVerticalAlignment = .center
        mapView.userTrackingMode = .followWithCourse
        
        gameView.addSubview(mapView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.frame = gameView.bounds
    }
    
    func reducePointIndex (){
        currentIndex = currentIndex+1;
        checkpointsLabel.text = "\(currentIndex) of \(totalCheckpointsCount)"
    }
    func updateMapTimer(){
        if locationManager.location != nil && (lastKnownCoordinates.latitude != locationManager.location?.coordinate.longitude){
            createQuestRoute()
        }
    }
    func createQuestRoute(){
        
        //next quest point
        let questPoint = CLLocation(latitude: self.questInfo.markers![currentIndex].lat!, longitude: self.questInfo.markers![currentIndex].lon!)
        
        // dstance to point
        let distance = locationManager.location!.distance(from: questPoint)
        nextPointDistance.text = String(format: "%.0f m", distance)
        if(distance <= 50){
            reducePointIndex()
        }
        // speed line
        speedLabel.text = String(format: "%.1f m/s", (locationManager.location?.speed)!)
        
    }
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    func updateCoordinates(coordinates:CLLocationCoordinate2D){
        lastKnownCoordinates = coordinates
    }
    override func viewDidDisappear(_ animated: Bool) {
        timer.invalidate()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        updateCoordinates(coordinates: center)
    }
}
