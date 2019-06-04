//
//  EventManager.swift
//  Preparture
//
//  Created by Bibin Mathew on 8/1/18.
//  Copyright © 2018 praveen raj. All rights reserved.
//

import UIKit

class EventManager: CLBaseService {
    
    //MARK : Get All Events Api Without category
    
    func callingGetAllEventsApi(with body:String, success : @escaping (Any)->(),failure : @escaping (_ errorType:ErrorType)->()){
        CLNetworkManager().initateWebRequest(networkModelForGetallEvents(with:body), success: {
            (resultData) in
            let (jsonDict, error) = self.didReceiveStatesResponseSuccessFully(resultData)
            if error == nil {
                if let jdict = jsonDict{
                    print(jsonDict as Any)
                    success(self.getEventsResponseModel(dict: jdict) as Any)
                }else{
                    failure(ErrorType.dataError)
                }
            }else{
                failure(ErrorType.dataError)
            }
            
        }, failiure: {(error)-> () in failure(error)
            
        })
        
    }
    
    func networkModelForGetallEvents(with body:String)->CLNetworkModel{
        let getAllEventsModel = CLNetworkModel.init(url: BASE_URL+GET_ALL_EVENTS, requestMethod_: "POST")
        getAllEventsModel.requestBody = body
        return getAllEventsModel
    }
    
    //MARK : Get All Events Based On Location
    
    func callingGetAllEventsBasedOnLocationApi(with body:String, success : @escaping (Any)->(),failure : @escaping (_ errorType:ErrorType)->()){
        CLNetworkManager().initateWebRequest(networkModelForSearchEvents(with:body), success: {
            (resultData) in
            let (jsonDict, error) = self.didReceiveStatesResponseSuccessFully(resultData)
            if error == nil {
                if let jdict = jsonDict{
                    print(jsonDict as Any)
                    success(self.getEventsResponseModel(dict: jdict) as Any)
                }else{
                    failure(ErrorType.dataError)
                }
            }else{
                failure(ErrorType.dataError)
            }
            
        }, failiure: {(error)-> () in failure(error)
            
        })
        
    }
    
    func networkModelForSearchEvents(with body:String)->CLNetworkModel{
        let getSearchEventsModel = CLNetworkModel.init(url: BASE_URL+GET_SEARCH_EVENTS_URL, requestMethod_: "POST")
        getSearchEventsModel.requestBody = body
        return getSearchEventsModel
    }
    
    
    //MARK : Get Events Api
    
    func callingEventsApi(with body:String, success : @escaping (Any)->(),failure : @escaping (_ errorType:ErrorType)->()){
        CLNetworkManager().initateWebRequest(networkModelForGetEvents(with:body), success: {
            (resultData) in
            let (jsonDict, error) = self.didReceiveStatesResponseSuccessFully(resultData)
            if error == nil {
                if let jdict = jsonDict{
                    print(jsonDict as Any)
                    success(self.getEventsResponseModel(dict: jdict) as Any)
                }else{
                    failure(ErrorType.dataError)
                }
            }else{
                failure(ErrorType.dataError)
            }
            
        }, failiure: {(error)-> () in failure(error)
            
        })
        
    }
    
    func networkModelForGetEvents(with body:String)->CLNetworkModel{
        let getSuggestionsModel = CLNetworkModel.init(url: BASE_URL+GET_PARTICULAR_EVENTITEMS_URL, requestMethod_: "POST")
        getSuggestionsModel.requestBody = body
        return getSuggestionsModel
    }
    
    func getEventsResponseModel(dict:[String : Any?]) -> Any? {
        let eventsReponseModel = EventsResponseModel.init(dict:dict)
        return eventsReponseModel
    }
    
    //MARK : Get Event Details Api
    
    func callingEventDetailsApi(with body:String, success : @escaping (Any)->(),failure : @escaping (_ errorType:ErrorType)->()){
        CLNetworkManager().initateWebRequest(networkModelForGetEventDetails(with:body), success: {
            (resultData) in
            let (jsonDict, error) = self.didReceiveStatesResponseSuccessFully(resultData)
            if error == nil {
                if let jdict = jsonDict{
                    print(jsonDict as Any)
                    success(self.getEventDetailResponseModel(dict: jdict) as Any)
                }else{
                    failure(ErrorType.dataError)
                }
            }else{
                failure(ErrorType.dataError)
            }
            
        }, failiure: {(error)-> () in failure(error)
            
        })
        
    }
    
    func networkModelForGetEventDetails(with body:String)->CLNetworkModel{
        let getSuggestionsModel = CLNetworkModel.init(url: BASE_URL+GET_EVENT_DETAILS, requestMethod_: "POST")
        getSuggestionsModel.requestBody = body
        return getSuggestionsModel
    }
    
    func getEventDetailResponseModel(dict:[String : Any?]) -> Any? {
        let eventDetailReponseModel = EventDetailResponseModel.init(dict:dict)
        return eventDetailReponseModel
    }
    
    //MARK : Get Add Itinerary Api
    
    func callingAddItineraryApi(with body:String, success : @escaping (Any)->(),failure : @escaping (_ errorType:ErrorType)->()){
        CLNetworkManager().initateWebRequest(networkModelForAddItinerary(with:body), success: {
            (resultData) in
            let (jsonDict, error) = self.didReceiveStatesResponseSuccessFully(resultData)
            if error == nil {
                if let jdict = jsonDict{
                    print(jsonDict as Any)
                    success(self.getAddItineraryResponseModel(dict: jdict) as Any)
                }else{
                    failure(ErrorType.dataError)
                }
            }else{
                failure(ErrorType.dataError)
            }
            
        }, failiure: {(error)-> () in failure(error)
            
        })
        
    }
    
    func networkModelForAddItinerary(with body:String)->CLNetworkModel{
        let addIntineraryModel = CLNetworkModel.init(url: BASE_URL+ADD_ITINERARY_URL, requestMethod_: "POST")
        addIntineraryModel.requestBody = body
        return addIntineraryModel
    }
    
    func getAddItineraryResponseModel(dict:[String : Any?]) -> Any? {
        let addItineraryReponseModel = AddToFavoriteResponseModel.init(dict:dict)
        return addItineraryReponseModel
    }
    
    //MARK : Get All Feeds Api Without category
    
    func callingGetAllFeedsApi(with body:String, success : @escaping (Any)->(),failure : @escaping (_ errorType:ErrorType)->()){
        CLNetworkManager().initateWebRequest(networkModelForGetAllFeeds(with:body), success: {
            (resultData) in
            //let (jsonDict, error) = self.didReceiveStatesResponseSuccessFully(resultData)
            //if (!error) {
           // }
            //if error == nil {
                //if let jdict = jsonDict{
                    //print(jsonDict as Any)
                    success(resultData as Any)
//                }else{
//                    failure(ErrorType.dataError)
//                }
//            }else{
//                failure(ErrorType.dataError)
//            }
            
        }, failiure: {(error)-> () in failure(error)
            
        })
        
    }
    
    func networkModelForGetAllFeeds(with body:String)->CLNetworkModel{
        let getAllFeedsModel = CLNetworkModel.init(url: GET_ALL_CHICAGO_FEEDS_URL, requestMethod_: "GET")
        return getAllFeedsModel
    }
}

class EventsResponseModel : NSObject{
    var statusMessage:String = ""
    var statusCode:Int = 0
    var events = [EventItem]()
    init(dict:[String:Any?]) {
        if let value = dict["message"] as? String{
            statusMessage = value
        }
        if let value = dict["status"] as? Int{
            statusCode = value
        }
        if let value = dict["result"] as? NSArray{
            for item in value {
                events.append(EventItem.init(dict: item as! [String : Any?]))
            }
        }
        if let value = dict["results"] as? NSArray{
            for item in value {
                events.append(EventItem.init(dict: item as! [String : Any?]))
            }
        }
    }
}

class EventDetailResponseModel : NSObject{
    var statusMessage:String = ""
    var statusCode:Int = 0
    var eventItem:EventItem?
    init(dict:[String:Any?]) {
        if let value = dict["message"] as? String{
            statusMessage = value
        }
        if let value = dict["status"] as? Int{
            statusCode = value
        }
        if let value = dict["result"] as? [String : Any?]{
            eventItem = EventItem.init(dict: value )
        }
    }
}

class EventItem : NSObject{
    var eventId:Int = 0
    var categoryId:Int = 0
    var name:String = ""
    var location:String = ""
    var eventDate:String = ""
    var createdDate:String = ""
    var eventCost:Double = 0.0
    var rating:Int = 0
    var reviewsCount:Int = 0
    var eventImages = [String]()
    var isFavourite:Bool = false
    var eventOwnerName:String = ""
    var travelExperience:String = ""
    var comments:String = ""
    
    var suggestions = [UserSuggestion]()
    var itineraries = [ItineraryDetails]()
    init(dict:[String:Any?]) {
        if let value = dict["event_id"] as? String{
            if let evId = Int(value){
                eventId = evId
            }
        }
        if let value = dict["event_name"] as? String{
            name = value
        }
        if let value = dict["category_id"] as? String{
            if let catId = Int(value){
                categoryId = catId
            }
        }
        if let value = dict["author_name"] as? String{
            eventOwnerName = value
        }
        if let value = dict["location"] as? String{
            location = value
        }
        if let value = dict["event_date"] as? String{
            eventDate = value
        }
        if let value = dict["created_date"] as? String{
            createdDate = value
        }
        if let value = dict["event_cost"] as? String{
            if let n = NumberFormatter().number(from: value) {
                eventCost = Double(truncating: n)
            }
        }
        if let value = dict["total"] as? String{
            if let total = Int(value){
                rating = total
            }
        }
        if let value = dict["total_reviews"] as? String{
            if let reviewCount = Int(value){
                reviewsCount = reviewCount
            }
        }
        if let filesArray = dict["event_files"] as? NSArray{
            for item in filesArray {
                if let image = item as? String {
                    eventImages.append(image)
                }
            }
        }
        if let value = dict["favorite_status"] as? Int{
            if value == 1{
                isFavourite = true
            }
            else{
                isFavourite = false
            }
        }
        if let value = dict["user_favorite_status"] as? Int{
            if value == 1{
                isFavourite = true
            }
            else{
                isFavourite = false
            }
        }
        if let value = dict["travel_experience"] as? String{
            travelExperience = value
        }
        if let value = dict["comments"] as? String{
            comments = value
        }
        if let sugns = dict["reviews"]  as? NSArray {
            for item in sugns {
                suggestions.append(UserSuggestion.init(dict: item as! [String : Any?]))
            }
        }
        if let itineries = dict["itinerary_details"]  as? NSArray {
            for item in itineries {
                itineraries.append(ItineraryDetails.init(dict: item as! [String : Any?]))
            }
        }
        
    }
}

class UserSuggestion : NSObject{
    var sugId:Int = 0
    var eventId:Int = 0
    var userId:Int = 0
    var userName:String = ""
    var userProfImage:String = ""
    var comments:String = ""
    var rating:Int = 0
    var title:String = ""
    var createdDate:String = ""
    var updatedDate:String = ""
    var placeFiles = [String]()
    
    init(dict:[String:Any?]) {
        if let value = dict["sgg_id"] as? String{
            if let suId = Int(value){
                sugId = suId
            }
        }
        if let value = dict["event_id"] as? String{
            if let eveId = Int(value){
                eventId = eveId
            }
        }
        if let value = dict["created_date"] as? String{
            createdDate = value
        }
        if let value = dict["name"] as? String{
            userName = value
        }
        if let value = dict["title"] as? String{
            title = value
        }
        if let value = dict["updated_date"] as? String{
            updatedDate = value
        }
        if let value = dict["user_id"] as? String{
            if let usId = Int(value){
                userId = usId
            }
        }
        if let value = dict["user_image"] as? String{
            userProfImage = value
        }
        if let value = dict["comments"] as? String{
            comments = value
        }
        if let value = dict["rating"] as? String{
            if let total = Int(value){
                rating = total
            }
        }
        if let value = dict["place_files"] as? NSArray{
            for item in value {
                if let image = item as? String {
                    placeFiles.append(image)
                }
            }
        }
    }
}

class ItineraryDetails : NSObject{
    var categoryId:String = ""
    var createdDate:String = ""
    var startDate:String = ""
    var endDate:String = ""
    var eventID:String = ""
    var itineraryID:String = ""
    var itineraryName:String = ""
    var landMarks = [LandMarkDetails]()
    init(dict:[String:Any?]) {
        if let value = dict["category_id"] as? String{
            categoryId = value
        }
        if let value = dict["created_date"] as? String{
            createdDate = value
        }
        if let value = dict["start_date"] as? String{
            startDate = value
        }
        if let value = dict["end_date"] as? String{
            endDate = value
        }
        if let value = dict["event_id"] as? String{
            eventID = value
        }
        if let value = dict["itinerary_id"] as? String{
            itineraryID = value
        }
        if let value = dict["itinerary_name"] as? String{
            itineraryName = value
        }
        if let value = dict["landmark_details"] as? NSArray{
            for item in value {
                landMarks.append(LandMarkDetails.init(dict: item as! [String : Any?]))
            }
        }
    }
}

class LandMarkDetails : NSObject{
    var checkIn:String = ""
    var checkOut:String = ""
    var itineraryID:String = ""
    var itineraryLandMarkId:String = ""
    var landLatitude:String = ""
    var landLongitude:String = ""
    var landMarkName:String = ""
    init(dict:[String:Any?]) {
        if let value = dict["check_in"] as? String{
            checkIn = value
        }
        if let value = dict["check_out"] as? String{
            checkOut = value
        }
        if let value = dict["itinerary_id"] as? String{
            itineraryID = value
        }
        if let value = dict["itinerary_landmark_id"] as? String{
            itineraryLandMarkId = value
        }
        if let value = dict["land_latitude"] as? String{
            landLatitude = value
        }
        if let value = dict["land_longitude"] as? String{
            landLongitude = value
        }
        if let value = dict["landmark_name"] as? String{
            landMarkName = value
        }
    }
}

//Output Classes

class AddEvent : NSObject{
    var eventName:String = ""
    var authorName:String = ""
    var eventCost:String = ""
    var eventDate:String = ""
    var eventTime:String = ""
    var location:String = ""
    var latitude:Double = 0.0
    var longitude:Double = 0.0
    var category:String = ""
    var eventRating:Int = 0
    var travelExperience:String = ""
    var comment:String = ""
    var eventFiles:String = ""
    func getRequestBody()->String{
        var dict:[String:String] = [String:String]()
        if let user = User.getUser(){
            if let userIdString = user.userId{
                dict.updateValue(userIdString, forKey: "user_id")
            }
        }
        dict.updateValue(eventName, forKey: "event_name")
        dict.updateValue(authorName, forKey: "author_name")
        dict.updateValue(eventCost, forKey: "event_cost")
        dict.updateValue(eventDate, forKey: "event_date")
        dict.updateValue(eventTime, forKey: "event_time")
        dict.updateValue(category, forKey: "category_id")
        dict.updateValue(String(format: "%f", latitude), forKey: "latitude")
        dict.updateValue(String(format: "%f", longitude), forKey: "longitude")
        dict.updateValue(location, forKey: "location")
        dict.updateValue(String(format: "%d", eventRating), forKey: "event_rate")
        dict.updateValue(travelExperience, forKey: "travel_experience")
        dict.updateValue(comment, forKey: "comments")
        dict.updateValue(eventFiles, forKey: "event_files")
        return CCUtility.getJSONfrom(dictionary: dict)
    }
    
}

class AddItinerary : NSObject{
    var eventId:Int = 0
    var categoryId:Int = 0
    var itineraryName:String = ""
    var itineraryStartDate:String = ""
    var itineraryEndDate:String = ""
    var landMarks = [AddLandmark]()
    var latitudeArray = [String]()
    var longitudeArray = [String]()
    var landMarkNameArray = [String]()
    var checkInArray = [String]()
    var checkOutArray = [String]()
    func getRequestBody()->String{
        var dict:[String:AnyObject] = [String:AnyObject]()
        dict.updateValue(itineraryName as AnyObject, forKey: "itinerary_name")
        dict.updateValue("\(eventId)" as AnyObject, forKey: "event_id")
        if let user = User.getUser(){
            if let userIdString = user.userId{
                dict.updateValue(userIdString as AnyObject, forKey: "user_id")
            }
        }
        dict.updateValue("\(categoryId)" as AnyObject, forKey: "category_id")
        dict.updateValue(itineraryStartDate as AnyObject, forKey: "start_date")
        dict.updateValue(itineraryEndDate as AnyObject, forKey: "end_date")
        for landMark in landMarks{
            if landMark.landmarkName.count > 0{
                latitudeArray.append("\(landMark.landmarkLatitude)")
                longitudeArray.append("\(landMark.landmarkLongitude)")
                landMarkNameArray.append(landMark.landmarkName)
                checkInArray.append(landMark.checkInDate)
                checkOutArray.append(landMark.checkOutDate)
            }
        }
        dict.updateValue(latitudeArray as AnyObject, forKey: "land_latitude")
         dict.updateValue(longitudeArray as AnyObject, forKey: "land_longitude")
         dict.updateValue(landMarkNameArray as AnyObject, forKey: "landmark_name")
        dict.updateValue(checkInArray as AnyObject, forKey: "check_in")
        dict.updateValue(checkOutArray as AnyObject, forKey: "check_out")
        return CCUtility.getJSONfrom(dictionary: dict)
    }
    
    
}

class AddLandmark : NSObject{
    var landmarkName:String = ""
    var landmarkLatitude:Double = 0.0
    var landmarkLongitude:Double = 0.0
    var checkInDate:String = ""
    var checkOutDate:String = ""
}

class EventsSearchRequestModel:NSObject{
    var searchText:String = ""
    func getRequestBody()->String{
        var dict:[String:String] = [String:String]()
        if let user = User.getUser(){
            if let userIdString = user.userId{
                dict.updateValue(userIdString, forKey: "user_id")
            }
        }
        dict.updateValue(searchText, forKey: "search_words")
        return CCUtility.getJSONfrom(dictionary: dict)
    }
    
}

class Feed:NSObject{
    var feedTitle:String = ""
    var feedLink:String = ""
    var feedComments:String = ""
    var feedDate:String = ""
    var feedDescription:String = ""
    
    init(title:String, link:String, comments:String, date:String, feedDes:String){
        feedTitle = title
        feedLink = link
        feedComments = comments
        feedDate = date
        feedDescription = feedDes
    }
}
