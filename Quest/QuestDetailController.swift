//
//  DetailController.swift
//  Quest
//
//  Created by Yurii Troniak on 9/18/17.
//  Copyright © 2017 Yurii Troniak. All rights reserved.
//

import UIKit
import Mapbox;
import MapboxDirections
import MapboxNavigation


class QuestDetailController: UIViewController, MGLMapViewDelegate  {
    
    @IBOutlet weak var detailQuestDescription: UILabel!
    @IBOutlet weak var detailQuestImage: UIImageView!
    @IBOutlet weak var detailQuestNameLabel: UILabel!
    @IBAction func StartGameButton(_ sender: UIButton) {
        performSegue(withIdentifier: "startGameSegue", sender: sender)
    }
    
    private weak var imageDownloadTask: URLSessionDataTask?
    
    @IBOutlet weak var mapView: MGLMapView!
    var quest: Quests_list!
    
    func setImage(withURL url: URL) {
        imageDownloadTask = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.detailQuestImage.image = image
                }
            }
        })
        imageDownloadTask?.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailQuestDescription.text = quest.description
        detailQuestNameLabel.text = quest.name
        if ((quest.logo) != nil){
            setImage(withURL: URL(string:quest.logo!)!)
        }
        
        let styleURL = NSURL(string: "mapbox://styles/tronya/cixa87ptp00g12qo9jjbqm9mk")
        let mapView = MGLMapView(frame: self.mapView.bounds,
                                 styleURL: styleURL as URL?)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        // Set the map’s center coordinate and zoom level.
        mapView.setCenter(CLLocationCoordinate2D(latitude: quest.markers![0].lat!,
                                                 longitude: quest.markers![0].lon!),
                          zoomLevel: 16, animated: false)
        self.mapView.addSubview(mapView)
        mapView.delegate = self
        
        var constraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[mapView]-0-|", options: .alignAllCenterY, metrics: nil, views: ["mapView": mapView])
        constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[mapView]-0-|", options: .alignAllCenterX, metrics: nil, views: ["mapView": mapView]))
        NSLayoutConstraint.activate(constraints)
        
        let hello = MGLPointAnnotation()
        hello.coordinate = CLLocationCoordinate2D(latitude: quest.markers![0].lat!,
                                                  longitude: quest.markers![0].lon!)
        hello.title = "Start point!"
        hello.subtitle = "Let play?"
        
        // Add marker `hello` to the map.
        mapView.addAnnotation(hello)
        
        // Use the default marker. See also: our view annotation or custom marker examples.
        func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
            return nil
        }
        
        // Allow callout view to appear when an annotation is tapped.
        func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
            return true
        }

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "startGameSegue"{
            guard let detailVC = segue.destination as? GameViewController else {
                return
            }
            detailVC.questInfo = quest
        }
    }
}
