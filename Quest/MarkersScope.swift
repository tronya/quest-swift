//
//  markersScope.swift
//  Quest
//
//  Created by Yurii Troniak on 9/18/17.
//  Copyright © 2017 Yurii Troniak. All rights reserved.
//

import Foundation
class MarkersScope {
    
    var id: Int?
    var lat:Double?
    var lon:Double?
    var name:String?
    var picture:String?
    
    
    var author_email:String?
    var author_fb_id:String?
    var author_first_name:String?
    var author_last_name:String?
    var author_user_profile:String?
    
    
    init(marker: [String: Any]) {
        var author = marker["author"] as? [String: Any]
        
        self.id = marker["id"] as? Int
        self.author_email = author?["email"] as? String
        self.picture = marker["picture"] as? String
        self.name = marker["name"] as? String
        
        if let q_point_lat = Double((marker["lat"] as? String)!) {
            self.lat = q_point_lat
        }
        if let q_point_lon = Double((marker["lon"] as? String)!) {
            self.lon = q_point_lon
        }
    }
}
