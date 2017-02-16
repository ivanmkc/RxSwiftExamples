//
//  IssueTrackerModel.swift
//  RxMoyaExample
//
//  Created by Lukasz Mroz on 11.02.2016.
//  Copyright © 2016 Droids on Roids. All rights reserved.
//

import Foundation
import Moya
import Mapper
import Moya_ModelMapper
import RxOptional
import RxSwift
//import Pantry

struct IssueTrackerModel {
    
    let provider: RxMoyaProvider<TripVerseNetworking>
    let tripId: Observable<String>
    
    func trackIssues() -> Observable<[TVActivity]> {
        //TODO Combine cache and network streams
        return tripId
            .observeOn(MainScheduler.instance)
            .flatMapLatest { name -> Observable<String?> in
                print("Name: \(name)")
                return self
                    .findTrip(name)
            }
            .flatMapLatest { tripId -> Observable<[TVActivity]?> in
                guard let tripId = tripId else { return Observable.just(nil) }
                
                print("Trip Id: \(tripId)")
                return self.findActivities(tripId)
            }
            .replaceNilWith([])
    }
    
    internal func findActivities(_ tripId: String) -> Observable<[TVActivity]?> {
        //TODO Cache activities
        return self.provider
            .request(TripVerseNetworking.GetActivitiesInTrip(tripId: tripId, dayNumber: nil))
            .debug()
            .mapArrayOptional(type: TVActivity.self, keyPath: "data")
    }

    internal func findTrip(_ name: String) -> Observable<String?> {
        return Observable.just(name)
//        return self.provider
//            .request(TripVerse.repo(fullName: name))
//            .debug()
//            .mapObjectOptional(type: Repository.self)
    }
}

public extension Response
{
    public func mapTVResponse() throws -> NSDictionary {
        guard let jsonDictionary = try mapJSON() as? NSDictionary,
            let dataDictionary = jsonDictionary["data"] as? NSDictionary            
            else {
                throw MoyaError.jsonMapping(self)
            }
        
        return dataDictionary
    }
}

extension ObservableType where E == Response {
    /// Maps data received from the signal into a JSON object. If the conversion fails, the signal errors.
    public func mapTVResponse() -> Observable<NSDictionary> {
        return flatMap { response -> Observable<NSDictionary> in
            return Observable.just(try response.mapTVResponse())
        }
    }
    
//    public func mapTVArrayOptional<T: Mappable>(type: T.Type, keyPath: String? = nil) -> Observable<[T]?> {
//        return observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
//            .flatMap { response -> Observable<[T]?> in
//                do {
//                    let object: [T] = try response.mapArray(withKeyPath: keyPath)
//                    return Observable.just(object)
//                } catch {
//                    return Observable.just(nil)
//                }
//            }
//            .observeOn(MainScheduler.instance)
//    }
}

//
//extension ObservableType where E == Response {
//    /// Maps data received from the signal into a JSON object. If the conversion fails, the signal errors.
//    public func mapTVResponse() throws -> Observable<NSDictionary> {
//        return observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
//            .flatMap { response -> Observable<NSDictionary> in
//                guard let jsonDictionary = try? response.mapJSON() as? NSDictionary,
//                    let data = jsonDictionary["data"] as? NSDictionary
//                else {
//                    return Observable.just(nil)
//                }
//            }
//            .observeOn(MainScheduler.instance)
//}
//        
//        guard let jsonDictionary = try mapJSON() as? NSDictionary,
//            let data = jsonDictionary["data"] as? NSDictionary
////            let object = T.from(objectDictionary) 
//            else {
//                throw MoyaError.jsonMapping(response)
//        }
//        
//        return data
        
//        return observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
//            .flatMap { response -> Observable<AnyObject> in
//                do {
//                    let object: AnyObject = try response.mapObject(withKeyPath: keyPath)
//                    return Observable.just(object)
//                } catch {
//                    return Observable.just(nil)
//                }
//                
//            }
//            .observeOn(MainScheduler.instance)
        
//        
//        return flatMap { response -> Observable<Any> in
//            return Observable.just(try response.mapJSON(failsOnEmptyData: failsOnEmptyData))
//        }
//    }
//}
