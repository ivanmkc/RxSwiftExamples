//
//  IssueEntity.swift
//  RxMoyaExample
//
//  Created by Lukasz Mroz on 11.02.2016.
//  Copyright © 2016 Droids on Roids. All rights reserved.
//
import CoreLocation
import Mapper

struct TVActivity: Mappable {
    
    var id : String
    var tripId : String
    var dateCreated : Date
    var dateUpdated : Date
    var timesCloned : Int
    var name : String
    var images : [(id : String, imageUrl : URL)]
    
    var placeId : String?
    var dayNumber : Int?
    var dayName : String?
    var time : Date?
    var orderNumber : Int?
    var typeNumber : Int?
    var budgetNumber : Int?
    var url : URL?
    var imageUrl : URL?
    var address : String?
    var phone : String?
    var coordinates : CLLocationCoordinate2D?
    var publicDescription : String?
    var privateDescription : String?
    var state : String?
    var date : Date?

    
    init(map: Mapper) throws {
        try id = map.from("id")
        try tripId = map.from("trip_id")
        
        let dateCreatedDouble = try Double(map.from("created") as String) ?? 0
        dateCreated = Date(timeIntervalSince1970:dateCreatedDouble)
        
        let dateUpdatedDouble = try Double(map.from("updated") as String) ?? 0
        dateUpdated = Date(timeIntervalSince1970:dateUpdatedDouble)
        
        try timesCloned = Int(map.from("cloned_times")) ?? 0
        try name = map.from("name")
        //TODO
        images = [(id : String, imageUrl : URL)]()// map.from("trip_id")
        try? placeId = map.from("place_id")
        try? dayNumber = map.from("day_no")
        try? dayName = map.from("day_name")
        
        //TODO
        try? time = nil// map.from("time")
        
        try? orderNumber = map.from("order_no")
        try? typeNumber = map.from("type_no")
        try? budgetNumber = map.from("budget_no")
        try? url = URL(string:map.from("url"))
        try? imageUrl = URL(string:map.from("img_url"))
        try? address = map.from("address")
        try? phone = map.from("phone")
        
        //TODO
//        try coordinates = map.from("trip_id")
        
        try? publicDescription = map.from("memo")
        try? privateDescription = map.from("desc")
        try? state = map.from("state")
    }
}
