//
//  Models.swift
//  ApliteEquipDragDrop
//
//  Created by Aplite on 22/04/23.
//

import Foundation
import UIKit
class FloreMap {
    var dimention = CGSize.init(width: 800, height: 700)
    var mapID = "123"
    var mapImage = "https://www.google.com/imgres?imgurlcoordinate"
    var jobID = "1"
    var floorID = "1"
    var mapType = "home"
    var Title = "your loved one"
    var fieldLocation = "Washington, D.C."
    var status = "new"
    var color = "red"
    var availableItems = MapItem()
    var consumedItem =  MapItem()
}
class MapItem {
    var coordinate = CGPoint(x: 50, y: 80)
    var name = "Bulb"
    var description = "smart LED Bulb"
    var photoOfItem = "https://www.google.com/imgres?"
    var ItemId = "11"
    var Availability = true
}
// codable item
struct MapResponse : Codable {
    let success : Bool?
    let data : [Map_jsonData]?
    let message : String?

}

//class ArrMapData : Codable {
//    let map_id : String?
//    let map_jobid : String?
//    let map_jsonData : Map_jsonData?
//    let map_createdate : String?
//    let map_updatedate : String?
//
//}



class Map_jsonData : Codable {
    let mapId : String?
    let jobId : String?

    let mapLength : Int?
    let mapWidth : Int?
    let mapImageUrl : String?
    let title : String?
    let mapItems : [MapItems]?
}

class MapItems : Codable {
    var coordinateX : Float? //  : Int?
    var coordinateY : Float?  // Int?
    var name : String?
    var description : String?
    var photoOfItem : String?
    var itemID : String?
    var availability : String?
}


