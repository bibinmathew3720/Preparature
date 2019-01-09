//
//  EventManager.swift
//  Preparture
//
//  Created by Bibin Mathew on 8/1/18.
//  Copyright © 2018 praveen raj. All rights reserved.
//

import UIKit

class EventManager: CLBaseService {
    
    //MARK : Get Suggestions Api
    
    func callingSuggestionsApi(with body:String, success : @escaping (Any)->(),failure : @escaping (_ errorType:ErrorType)->()){
        CLNetworkManager().initateWebRequest(networkModelForGetSuggestions(with:body), success: {
            (resultData) in
            let (jsonDict, error) = self.didReceiveStatesResponseSuccessFully(resultData)
            if error == nil {
                if let jdict = jsonDict{
                    print(jsonDict as Any)
                    success(self.getSuggestionsResponseModel(dict: jdict) as Any)
                }else{
                    failure(ErrorType.dataError)
                }
            }else{
                failure(ErrorType.dataError)
            }
            
        }, failiure: {(error)-> () in failure(error)
            
        })
        
    }
    
    func networkModelForGetSuggestions(with body:String)->CLNetworkModel{
        let getSuggestionsModel = CLNetworkModel.init(url: BASE_URL+GET_PARTICULAR_EVENTITEMS_URL, requestMethod_: "POST")
        getSuggestionsModel.requestBody = body
        return getSuggestionsModel
    }
    
    func getSuggestionsResponseModel(dict:[String : Any?]) -> Any? {
        let suggestionReponseModel = SuggestionsResponseModel.init(dict:dict)
        return suggestionReponseModel
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
}

class SuggestionsResponseModel : NSObject{
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
    var name:String = ""
    var location:String = ""
    var eventDate:String = ""
    var eventCost:Double = 0.0
    var rating:Int = 0
    var reviewsCount:Int = 0
    var eventImages = [String]()
    var isFavourite:Bool = false
    var eventOwnerName:String = ""
    var travelExperience:String = ""
    var comments:String = ""
    
    var suggestions = [UserSuggestion]()
    init(dict:[String:Any?]) {
        if let value = dict["event_id"] as? String{
            if let evId = Int(value){
                eventId = evId
            }
        }
        if let value = dict["event_name"] as? String{
            name = value
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
    var updatedDate:String = ""
    
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
    }
}
