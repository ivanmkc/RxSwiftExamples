//
//  GithubEndpoint.swift
//  RxMoyaExample
//
//  Created by Lukasz Mroz on 11.02.2016.
//  Copyright © 2016 Droids on Roids. All rights reserved.
//

import Foundation
import Moya

private extension String {
    var URLEscapedString: String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!
    }
}

//TODO Move this out
public enum TVFoursquareActivityCategory : String {
    case Sights = "sights"
    case Park = "park"
}

enum TripVerseNetworking {
    case LoginByEmail(email : String, password : String)
    case GetProfile(userId : String?)
//    case GetActivity(activityId : String)
    case GetActivitiesInTrip(tripId : String, dayNumber : Int?)
//    case GetTrendingFoursquareActivitiesForCategory(tripId : String, category : TVFoursquareActivityCategory, destinationNumber : Int?)
//    case GetFlickrPhotosForFlickerLocation(locationId : String)
//    case GetFlickrPhotosForKeyword(query : String)
//    case userProfile(username: String)
//    case repos(username: String)
//    case repo(fullName: String)
//    case issues(repositoryFullName: String)
}

extension TripVerseNetworking: TargetType {
    var baseURL: URL { return URL(string: "http://api.tripverse.co/api")! }
    var path: String {
        switch self {
        case .LoginByEmail:
            return "/user/login"
        case .GetProfile:
            return "user/get-profile"
//        case .GetActivity(let activityId):
//            return "/spot/get)"
        case .GetActivitiesInTrip:
            return "/spot/list"
//        case .GetTrendingFoursquareActivitiesForCategory(let tripId, let category, let destinationNumber):
//            return "/spot/spot-trending-by-category"
        }
    }
    var method: Moya.Method {
        return .post
    }
    var parameters: [String: Any]? {
        switch self {
        case .LoginByEmail(let email, let password):
            return ["email" : email, "passwd" : password]
        case .GetProfile(let userId):
            return ["user": userId ?? ""]
//        case .GetActivity(let activityId):
//            return "/spot/get)"
        case .GetActivitiesInTrip(let tripId, let dayNumber):
            return ["trip_id" : tripId,
                    "day_no" : (dayNumber != nil) ? String(describing:dayNumber) : "",
                    "u" : "4039",
                    "t" : "e49900320aa8f1d8121ed20a60f46d4b"
                    ]
//        case .GetTrendingFoursquareActivitiesForCategory(let tripId, let category, let destinationNumber):
//            return "/spot/spot-trending-by-category"
        }

    }
    var sampleData: Data {
        switch self {
        case .GetProfile:
            return "{{\"id\": \"1\", \"language\": \"Swift\", \"url\": \"https://api.github.com/repos/mjacko/Router\", \"name\": \"Router\"}}}".data(using: .utf8)!
        case .LoginByEmail:
            return "{}".data(using: .utf8)!
//        case .GetActivity:
//            return "{\"login\": \"name\", \"id\": 100}".data(using: .utf8)!
        case .GetActivitiesInTrip:
            return "{\"id\": \"1\", \"language\": \"Swift\", \"url\": \"https://api.github.com/repos/mjacko/Router\", \"name\": \"Router\"}".data(using: .utf8)!
//        case .GetTrendingFoursquareActivitiesForCategory:
//            return "{\"id\": 132942471, \"number\": 405, \"title\": \"Updates example with fix to String extension by changing to Optional\", \"body\": \"Fix it pls.\"}".data(using: .utf8)!
        }
    }
    
    var task: Task {
        return .request
    }
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
}
