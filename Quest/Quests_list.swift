//
//  questScope.swift
//  Quest
//
//  Created by Yurii Troniak on 9/18/17.
//  Copyright © 2017 Yurii Troniak. All rights reserved.
//

import UIKit
import Foundation


class Quests_list {
    
    var id: Int?
    var name:String?
    var description:String?
    var start_date:Date?
    var logo:String?
    var author:String?
    var markers: [MarkersScope]?
    var members: [Any]?
    var date : Date?
    
    
    init(quest: NSDictionary) {
        
        self.id = quest["id"] as? Int
        self.name = quest["name"] as? String
        self.description = quest["description"] as? String
        self.logo = quest["logo"] as? String
        self.author = quest["author"] as? String
        self.members = quest["members"] as? Array
        
        self.markers = []
        let markers = quest["markers"] as? [[String: Any]]
        for markerJson in markers ?? [] {
            let newMarker = MarkersScope(marker: markerJson)
            self.markers?.append(newMarker)
        }
        
    }
}
