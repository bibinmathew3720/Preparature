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
    
    //MARK : Get Suggestion Details Api
    
    func callingSuggestionDetailsApi(with body:String, success : @escaping (Any)->(),failure : @escaping (_ errorType:ErrorType)->()){
        CLNetworkManager().initateWebRequest(networkModelForGetSuggestionDetails(with:body), success: {
            (resultData) in
            let (jsonDict, error) = self.didReceiveStatesResponseSuccessFully(resultData)
            if error == nil {
                if let jdict = jsonDict{
                    print(jsonDict as Any)
                    success(self.getSuggestionsDetailResponseModel(dict: jdict) as Any)
                }else{
                    failure(ErrorType.dataError)
                }
            }else{
                failure(ErrorType.dataError)
            }
            
        }, failiure: {(error)-> () in failure(error)
            
        })
        
    }
    
    func networkModelForGetSuggestionDetails(with body:String)->CLNetworkModel{
        let getSuggestionsModel = CLNetworkModel.init(url: BASE_URL+GET_SUGGESTION_DETAILS, requestMethod_: "POST")
        getSuggestionsModel.requestBody = body
        return getSuggestionsModel
    }
    
    func getSuggestionsDetailResponseModel(dict:[String : Any?]) -> Any? {
        let suggestionDetailReponseModel = SuggestionDetailResponseModel.init(dict:dict)
        return suggestionDetailReponseModel
    }
}

class SuggestionsResponseModel : NSObject{
    var statusMessage:String = ""
    var statusCode:Int = 0
    var suggestions = [SuggestionItems]()
    init(dict:[String:Any?]) {
        if let value = dict["message"] as? String{
            statusMessage = value
        }
        if let value = dict["status"] as? Int{
            statusCode = value
        }
        if let value = dict["result"] as? NSArray{
            for item in value {
                suggestions.append(SuggestionItems.init(dict: item as! [String : Any?]))
            }
        }
    }
}
class SuggestionItems : NSObject{
    var comments:String = ""
    var createdDate:String = ""
    var eventId:Int = 0
    var name:String = ""
    var placeImages = [String]()
    var placeLocation:String = ""
    var placeName:String = ""
    var travelExp:String = ""
    var rating:Float = 0.0
    var totalReviews:String = ""
    var updatedDate:String = ""
    var userId:Int = 0
    var userImage:String = ""
    var isFavorited:Bool = false
    var authorName:String = ""
    
    init(dict:[String:Any?]) {
        if let value = dict["comments"] as? String{
            comments = value
        }
        if let value = dict["created_date"] as? String{
            createdDate = value
        }
        if let value = dict["event_id"] as? String{
            eventId = Int(value)!
        }
        if let value = dict["name"] as? String{
            name = value
        }
        if let value = dict["event_files"] as? NSArray{
            for item in value {
                placeImages.append(item as! String)
            }
        }
        if let value = dict["location"] as? String{
            placeLocation = value
        }
        if let value = dict["event_name"] as? String{
            placeName = value
        }
        if let value = dict["author_name"] as? String{
            authorName = value
        }
        if let value = dict["travel_experience"] as? String{
            travelExp = value
        }
        if let value = dict["event_rate"] as? String{
            rating = Float(value)!
        }
        if let value = dict["total_reviews"] as? String{
            totalReviews = value
        }
        if let value = dict["updated_date"] as? String{
            updatedDate = value
        }
        if let value = dict["user_id"] as? String{
            userId = Int(value)!
        }
        if let value = dict["user_image"] as? String{
            userImage = value
        }
    }
}

class SuggestionDetailResponseModel : NSObject{
    var statusMessage:String = ""
    var statusCode:Int = 0
    var suggestionItem:SuggestionItems?
    init(dict:[String:Any?]) {
        if let value = dict["message"] as? String{
            statusMessage = value
        }
        if let value = dict["status"] as? Int{
            statusCode = value
        }
        if let value = dict["suggestions"] as? [String : Any?]{
            suggestionItem = SuggestionItems.init(dict: value )
        }
    }
}
