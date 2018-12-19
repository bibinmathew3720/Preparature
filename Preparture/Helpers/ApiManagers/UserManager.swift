//
//  UserManager.swift
//  Preparture
//
//  Created by Bibin Mathew on 7/28/18.
//  Copyright © 2018 praveen raj. All rights reserved.
//

import UIKit
import Alamofire

class UserManager: CLBaseService {
    
    //MARK : Log In Api
    
    func callingLogInApi(with body:String, success : @escaping (Any)->(),failure : @escaping (_ errorType:ErrorType)->()){
        CLNetworkManager().initateWebRequest(networkModelForLogIn(with:body), success: {
            (resultData) in
            let (jsonDict, error) = self.didReceiveStatesResponseSuccessFully(resultData)
            if error == nil {
                if let jdict = jsonDict{
                    print(jsonDict as Any)
                    success(self.getLogInResponseModel(dict: jdict) as Any)
                }else{
                    failure(ErrorType.dataError)
                }
            }else{
                failure(ErrorType.dataError)
            }
            
        }, failiure: {(error)-> () in failure(error)
            
        })
        
    }
    
    func networkModelForLogIn(with body:String)->CLNetworkModel{
        let loginRequestModel = CLNetworkModel.init(url: BASE_URL+LOGIN_URL, requestMethod_: "POST")
        loginRequestModel.requestBody = body
        return loginRequestModel
    }
    
    func getLogInResponseModel(dict:[String : Any?]) -> Any? {
        let logInReponseModel = LogInResponseModel.init(dict:dict)
        return logInReponseModel
    }
    
    //MARK : Sign Up Api
    
    func callingSignUpApi(with body:String, success : @escaping (Any)->(),failure : @escaping (_ errorType:ErrorType)->()){
        CLNetworkManager().initateWebRequest(networkModelForSignUp(with:body), success: {
            (resultData) in
            let (jsonDict, error) = self.didReceiveStatesResponseSuccessFully(resultData)
            if error == nil {
                if let jdict = jsonDict{
                    print(jsonDict as Any)
                    success(self.getSignUpResponseModel(dict: jdict) as Any)
                }else{
                    failure(ErrorType.dataError)
                }
            }else{
                failure(ErrorType.dataError)
            }
            
        }, failiure: {(error)-> () in failure(error)
            
        })
        
    }
    
    func networkModelForSignUp(with body:String)->CLNetworkModel{
        let signUpRequestModel = CLNetworkModel.init(url: BASE_URL+SIGNUP_URL, requestMethod_: "POST")
        signUpRequestModel.requestBody = body
        return signUpRequestModel
    }
    
    func getSignUpResponseModel(dict:[String : Any?]) -> Any? {
        let signUpReponseModel = SignUpResponseModel.init(dict:dict)
        return signUpReponseModel
    }
    
    //MARK : Forgot Password Api
    
    func callingForgotPasswordApi(with body:String, success : @escaping (Any)->(),failure : @escaping (_ errorType:ErrorType)->()){
        CLNetworkManager().initateWebRequest(networkModelForForgotPassword(with:body), success: {
            (resultData) in
            let (jsonDict, error) = self.didReceiveStatesResponseSuccessFully(resultData)
            if error == nil {
                if let jdict = jsonDict{
                    print(jsonDict as Any)
                    success(self.getForgotResponseModel(dict: jdict) as Any)
                }else{
                    failure(ErrorType.dataError)
                }
            }else{
                failure(ErrorType.dataError)
            }
            
        }, failiure: {(error)-> () in failure(error)
            
        })
        
    }
    
    func networkModelForForgotPassword(with body:String)->CLNetworkModel{
        let forgotRequestModel = CLNetworkModel.init(url: BASE_URL+FORGOT_PASSWORD_URL, requestMethod_: "POST")
        forgotRequestModel.requestBody = body
        return forgotRequestModel
    }
    
    func getForgotResponseModel(dict:[String : Any?]) -> Any? {
        let forgotReponseModel = ForgotResponseModel.init(dict:dict)
        return forgotReponseModel
    }
    
    //MARK : Change Password Api
    
    func callingChangePasswordApi(with body:String, success : @escaping (Any)->(),failure : @escaping (_ errorType:ErrorType)->()){
        CLNetworkManager().initateWebRequest(networkModelForChangePassword(with:body), success: {
            (resultData) in
            let (jsonDict, error) = self.didReceiveStatesResponseSuccessFully(resultData)
            if error == nil {
                if let jdict = jsonDict{
                    print(jsonDict as Any)
                    success(self.getChangePasswordResponseModel(dict: jdict) as Any)
                }else{
                    failure(ErrorType.dataError)
                }
            }else{
                failure(ErrorType.dataError)
            }
            
        }, failiure: {(error)-> () in failure(error)
            
        })
        
    }
    
    func networkModelForChangePassword(with body:String)->CLNetworkModel{
        let chnagePasswordRequestModel = CLNetworkModel.init(url: BASE_URL+CHANGE_PASSWORD_URL, requestMethod_: "POST")
        chnagePasswordRequestModel.requestBody = body
        return chnagePasswordRequestModel
    }
    
    func getChangePasswordResponseModel(dict:[String : Any?]) -> Any? {
        let changePasswordReponseModel = ChangePasswordResponseModel.init(dict:dict)
        return changePasswordReponseModel
    }
    
    //MARK : Edit Profile Api
    
    func callingEditProfileApi(with body:String, success : @escaping (Any)->(),failure : @escaping (_ errorType:ErrorType)->()){
        CLNetworkManager().initateWebRequest(networkModelForEditProfile(with:body), success: {
            (resultData) in
            let (jsonDict, error) = self.didReceiveStatesResponseSuccessFully(resultData)
            if error == nil {
                if let jdict = jsonDict{
                    print(jsonDict as Any)
                    success(self.getEditProfileResponseModel(dict: jdict) as Any)
                }else{
                    failure(ErrorType.dataError)
                }
            }else{
                failure(ErrorType.dataError)
            }
            
        }, failiure: {(error)-> () in failure(error)
            
        })
        
    }
    
    func networkModelForEditProfile(with body:String)->CLNetworkModel{
        let editProfileRequestModel = CLNetworkModel.init(url: BASE_URL+EDIT_PROFILE_URL, requestMethod_: "POST")
        editProfileRequestModel.requestBody = body
        return editProfileRequestModel
    }
    
    func getEditProfileResponseModel(dict:[String : Any?]) -> Any? {
        let editProfileReponseModel = EditProfileResponseModel.init(dict:dict)
        return editProfileReponseModel
    }
    
    //MARK : Add to Favorite Api
    
    func addToFavoriteApi(with body:String, success : @escaping (Any)->(),failure : @escaping (_ errorType:ErrorType)->()){
        CLNetworkManager().initateWebRequest(networkModelForAddToFavorite(with:body), success: {
            (resultData) in
            let (jsonDict, error) = self.didReceiveStatesResponseSuccessFully(resultData)
            if error == nil {
                if let jdict = jsonDict{
                    print(jsonDict as Any)
                    success(self.getAddToFavoriteResponseModel(dict: jdict) as Any)
                }else{
                    failure(ErrorType.dataError)
                }
            }else{
                failure(ErrorType.dataError)
            }
            
        }, failiure: {(error)-> () in failure(error)
            
        })
        
    }
    
    func networkModelForAddToFavorite(with body:String)->CLNetworkModel{
        let addToFavoriteRequestModel = CLNetworkModel.init(url: BASE_URL+ADD_TO_FAVORITE_URL, requestMethod_: "POST")
        addToFavoriteRequestModel.requestBody = body
        return addToFavoriteRequestModel
    }
    
    func getAddToFavoriteResponseModel(dict:[String : Any?]) -> Any? {
        let addToFavoriteReponseModel = AddToFavoriteResponseModel.init(dict:dict)
        return addToFavoriteReponseModel
    }
    
    
    //MARK : Get All Favorite Api
    
    func getAllFavoriteApi(with body:String, success : @escaping (Any)->(),failure : @escaping (_ errorType:ErrorType)->()){
        CLNetworkManager().initateWebRequest(networkModelForGetAllFavorite(with:body), success: {
            (resultData) in
            let (jsonDict, error) = self.didReceiveStatesResponseSuccessFully(resultData)
            if error == nil {
                if let jdict = jsonDict{
                    print(jsonDict as Any)
                    success(self.getAllFavoriteResponseModel(dict: jdict) as Any)
                }else{
                    failure(ErrorType.dataError)
                }
            }else{
                failure(ErrorType.dataError)
            }
            
        }, failiure: {(error)-> () in failure(error)
            
        })
        
    }
    
    func networkModelForGetAllFavorite(with body:String)->CLNetworkModel{
        let getAllFavoriteRequestModel = CLNetworkModel.init(url: BASE_URL+LIST_ALL_FAVORITES_URL, requestMethod_: "POST")
        getAllFavoriteRequestModel.requestBody = body
        return getAllFavoriteRequestModel
    }
    
    func getAllFavoriteResponseModel(dict:[String : Any?]) -> Any? {
        let listAllFavoriteReponseModel = ListAllFavoriteResponseModel.init(dict:dict)
        return listAllFavoriteReponseModel
    }
    
    //MARK : Get Settings Api
    
    func getSettingsApi(with body:String, success : @escaping (Any)->(),failure : @escaping (_ errorType:ErrorType)->()){
        CLNetworkManager().initateWebRequest(networkModelForGetAllSettings(with:body), success: {
            (resultData) in
            let (jsonDict, error) = self.didReceiveStatesResponseSuccessFully(resultData)
            if error == nil {
                if let jdict = jsonDict{
                    print(jsonDict as Any)
                    success(self.getSettingsResponseModel(dict: jdict) as Any)
                }else{
                    failure(ErrorType.dataError)
                }
            }else{
                failure(ErrorType.dataError)
            }
            
        }, failiure: {(error)-> () in failure(error)
            
        })
        
    }
    
    func networkModelForGetAllSettings(with body:String)->CLNetworkModel{
        let getAllFavoriteRequestModel = CLNetworkModel.init(url: BASE_URL+GET_SETTINGS_URL, requestMethod_: "POST")
        getAllFavoriteRequestModel.requestBody = body
        return getAllFavoriteRequestModel
    }
    
    func getSettingsResponseModel(dict:[String : Any?]) -> Any? {
        let settingsReponseModel = SettingsResponseModel.init(dict:dict)
        return settingsReponseModel
    }
    
    //MARK : Get Main Category Api
    
    func getCategoryApi(with body:String, success : @escaping (Any)->(),failure : @escaping (_ errorType:ErrorType)->()){
        CLNetworkManager().initateWebRequest(networkModelForGetCategory(with:body), success: {
            (resultData) in
            let (jsonDict, error) = self.didReceiveStatesResponseSuccessFully(resultData)
            if error == nil {
                if let jdict = jsonDict{
                    print(jsonDict as Any)
                    success(self.getCategoryResponseModel(dict: jdict) as Any)
                }else{
                    failure(ErrorType.dataError)
                }
            }else{
                failure(ErrorType.dataError)
            }
            
        }, failiure: {(error)-> () in failure(error)
            
        })
        
    }
    
    func networkModelForGetCategory(with body:String)->CLNetworkModel{
        let addToFavoriteRequestModel = CLNetworkModel.init(url: BASE_URL+GET_MAIN_CATEGORY_URL, requestMethod_: "POST")
        addToFavoriteRequestModel.requestBody = body
        return addToFavoriteRequestModel
    }
    
    func getCategoryResponseModel(dict:[String : Any?]) -> Any? {
        let addToFavoriteReponseModel = GetAllCategoryResponseModel.init(dict:dict)
        return addToFavoriteReponseModel
    }
    
    
    //MARK : Get Suggestions Api
    
    func getSuggestionsApi(with body:String, success : @escaping (Any)->(),failure : @escaping (_ errorType:ErrorType)->()){
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
        let addToFavoriteRequestModel = CLNetworkModel.init(url: BASE_URL+GET_ALL_SUGGESTIONS_EVENT, requestMethod_: "POST")
        addToFavoriteRequestModel.requestBody = body
        return addToFavoriteRequestModel
    }
    
    func getSuggestionsResponseModel(dict:[String : Any?]) -> Any? {
        let addToFavoriteReponseModel = GetSuggestionsResponseModel.init(dict:dict)
        return addToFavoriteReponseModel
    }
    
    //MARK : Post Suggestions Api
    
    func postSuggestionsApi(with body:String, success : @escaping (Any)->(),failure : @escaping (_ errorType:ErrorType)->()){
        CLNetworkManager().initateWebRequest(networkModelForaddSuggestions(with:body), success: {
            (resultData) in
            let (jsonDict, error) = self.didReceiveStatesResponseSuccessFully(resultData)
            if error == nil {
                if let jdict = jsonDict{
                    print(jsonDict as Any)
                    success(self.addSuggestionsResponseModel(dict: jdict) as Any)
                }else{
                    failure(ErrorType.dataError)
                }
            }else{
                failure(ErrorType.dataError)
            }
            
        }, failiure: {(error)-> () in failure(error)
            
        })
        
    }
    
    func networkModelForaddSuggestions(with body:String)->CLNetworkModel{
        let addToFavoriteRequestModel = CLNetworkModel.init(url: BASE_URL+ADD_SUGGESTIONS_URL, requestMethod_: "POST")
        addToFavoriteRequestModel.requestBody = body
        return addToFavoriteRequestModel
    }
    
    func addSuggestionsResponseModel(dict:[String : Any?]) -> Any? {
        let addToFavoriteReponseModel = GetAllCategoryResponseModel.init(dict:dict)
        return addToFavoriteReponseModel
    }
    
    //MARK : Add Event Api
    
    func addEventApi(with body:String, success : @escaping (Any)->(),failure : @escaping (_ errorType:ErrorType)->()){
        CLNetworkManager().initateWebRequest(networkModelForaddEvent(with:body), success: {
            (resultData) in
            let (jsonDict, error) = self.didReceiveStatesResponseSuccessFully(resultData)
            if error == nil {
                if let jdict = jsonDict{
                    print(jsonDict as Any)
                    success(self.addEventResponseModel(dict: jdict) as Any)
                }else{
                    failure(ErrorType.dataError)
                }
            }else{
                failure(ErrorType.dataError)
            }
            
        }, failiure: {(error)-> () in failure(error)
            
        })
        
    }
    
    func networkModelForaddEvent(with body:String)->CLNetworkModel{
        let addToFavoriteRequestModel = CLNetworkModel.init(url: BASE_URL+ADD_EVENT_URL, requestMethod_: "POST")
        addToFavoriteRequestModel.requestBody = body
        return addToFavoriteRequestModel
    }
    
    func addEventResponseModel(dict:[String : Any?]) -> Any? {
        let addToFavoriteReponseModel = GetAllCategoryResponseModel.init(dict:dict)
        return addToFavoriteReponseModel
    }
    
    func requestWith(endUrl: String, imagesDatas: [Data], parameters: [String : Any], onCompletion: ((FileUploadResponseModel?) -> Void)? = nil, onError: ((Error?) -> Void)? = nil){
        let url = endUrl
        Alamofire.upload(multipartFormData: { (multipartFormData) in
//            for (key, value) in parameters {
//                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
//            }
            
            for imageData in imagesDatas {
                multipartFormData.append(imageData, withName: "files[]", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
            }
            
//            if let data = imageData{
//                multipartFormData.append(data, withName: "files[]", fileName: "file.jpg", mimeType: "image/jpg")
//
//            }
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: nil) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    if let result = response.result.value {
                        if let resultJ = result as? [String:Any?]{
                            let model = FileUploadResponseModel.init(dict:resultJ )
                            onCompletion!(model)
                        }
                    }
                    
                    if let err = response.error{
                        onError?(err)
                        return
                    }
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                onError?(error)
            }
        }
    }
}
    
class LogInResponseModel : NSObject{
        var statusMessage:String = ""
        var statusCode:Int = 0
        var userId:String = ""
        
        var name:String = ""
        var userName:String = ""
        var userEmail:String = ""
        var userProfileImageUrl:String = ""
        init(dict:[String:Any?]) {
            if let value = dict["message"] as? String{
                statusMessage = value
            }
            if let value = dict["status"] as? Int{
                statusCode = value
            }
            
            if let user = dict["user_details"] as? [String:AnyObject]{
                if let value = user["user_id"] as? String{
                    userId = value
                }
                if let value = user["name"] as? String{
                    name = value
                }
                if let value = user["username"] as? String{
                    userName = value
                }
                if let value = user["email"] as? String{
                    userEmail = value
                }
                if let value = user["user_image"] as? String{
                    userProfileImageUrl = value
                }
            }
        }
    }

class SignUpResponseModel : NSObject{
    var statusMessage:String = ""
    var statusCode:Int = 0
    var userId:String = ""
    init(dict:[String:Any?]) {
        if let value = dict["message"] as? String{
            statusMessage = value
        }
        if let value = dict["status"] as? Int{
            statusCode = value
        }
        if let value = dict["user_id"] as? String{
            userId = value
        }
    }
}

class ForgotResponseModel : NSObject{
    var statusMessage:String = ""
    var statusCode:Int = 0
    init(dict:[String:Any?]) {
        if let value = dict["message"] as? String{
            statusMessage = value
        }
        if let value = dict["status"] as? Int{
            statusCode = value
        }
    }
}

class ChangePasswordResponseModel : NSObject{
    var statusMessage:String = ""
    var statusCode:Int = 0
    init(dict:[String:Any?]) {
        if let value = dict["message"] as? String{
            statusMessage = value
        }
        if let value = dict["status"] as? Int{
            statusCode = value
        }
    }
}

class EditProfileResponseModel : NSObject{
    var statusMessage:String = ""
    var statusCode:Int = 0
    init(dict:[String:Any?]) {
        if let value = dict["message"] as? String{
            statusMessage = value
        }
        if let value = dict["status"] as? Int{
            statusCode = value
        }
    }
}

class AddToFavoriteResponseModel : NSObject{
    var statusMessage:String = ""
    var statusCode:Int = 0
    init(dict:[String:Any?]) {
        if let value = dict["message"] as? String{
            statusMessage = value
        }
        if let value = dict["status"] as? Int{
            statusCode = value
        }
    }
}

class ListAllFavoriteResponseModel : NSObject{
    var statusMessage:String = ""
    var statusCode:Int = 0
    var favoriteItems = [FavoriteItem]()
    init(dict:[String:Any?]) {
        if let value = dict["message"] as? String{
            statusMessage = value
        }
        if let value = dict["status"] as? Int{
            statusCode = value
        }
        if let value = dict["favorites"] as? NSArray {
            for item in value {
                favoriteItems.append(FavoriteItem.init(dict: item as! [String : Any?]))
            }
        }
    }
}


class GetAllCategoryResponseModel : NSObject{
    var statusMessage:String = ""
    var statusCode:Int = 0
    var categoryItems = [CategoryItem]()
    init(dict:[String:Any?]) {
        if let value = dict["message"] as? String{
            statusMessage = value
        }
        if let value = dict["status"] as? Int{
            statusCode = value
        }
        if let value = dict["category"] as? NSArray {
            for item in value {
                categoryItems.append(CategoryItem.init(dict: item as! [String : Any?]))
            }
        }
    }
}

class FavoriteItem : NSObject{
    var comments:String = ""
    var createdDate:String = ""
    var eventId:Int = 0
    var name:String = ""
    var placeImages = [String]()
    var placeLocation:String = ""
    var placeName:String = ""
    var placeType:String = ""
    var rating:CGFloat = 0.0
    var sugId:Int = 0
    var updatedDate:String = ""
    var userId:Int = 0
    var userImage:String = ""
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
        if let value = dict["place_files"] as? NSArray{
            for item in value {
                placeImages.append(item as! String)
            }
        }
        if let value = dict["place_location"] as? String{
            placeLocation = value
        }
        if let value = dict["place_name"] as? String{
            placeName = value
        }
        if let value = dict["place_type"] as? String{
            placeType = value
        }
        if let value = dict["rating"] as? Float{
            rating = CGFloat(value)
        }
        if let value = dict["sgg_id"] as? String{
            sugId = Int(value)!
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

class CategoryItem : NSObject{
    var categoryID:String = ""
    var categoryName:String = ""
    var categoryIcon:String = ""
    init(dict:[String:Any?]) {
        if let value = dict["category_id"] as? String{
            categoryID = value
        }
        if let value = dict["category_name"] as? String{
            categoryName = value
        }
        if let value = dict["category_appicon"] as? String{
            categoryIcon = value
        }
    }
}
class FileUploadResponseModel : NSObject{
    var statusCode:Int = 0
    var uploadedImageName:String = ""
    //var statusCode:Int = 0
    init(dict:[String:Any?]) {
        if let value = dict["status"] as? Int{
            statusCode = value
        }
        if let value = dict["file_names"] as? String{
            uploadedImageName = value
        }
        
    }
}

class SettingsResponseModel : NSObject{
    var statusMessage:String = ""
    var settingItems = [SettingItem]()
    var statusCode:Int = 0
    init(dict:[String:Any?]) {
        if let value = dict["status"] as? Int{
            statusCode = value
        }
        if let value = dict["message"] as? String{
            statusMessage = value
        }
        if let value = dict["results"] as? NSArray{
            for item in value {
                settingItems.append(SettingItem.init(dict: item as! [String : Any?]) )
            }
        }
        
    }
}

class SettingItem : NSObject{
    var title:String = ""
    var content:String = ""
    init(dict:[String:Any?]) {
        if let value = dict["title"] as? String{
            title = value
        }
        if let value = dict["content"] as? String{
            content = value
        }
    }
}

class GetSuggestionsResponseModel : NSObject{
    var statusMessage:String = ""
    var statusCode:Int = 0
    var categoryItems = [SuggestionItem]()
    init(dict:[String:Any?]) {
        if let value = dict["message"] as? String{
            statusMessage = value
        }
        if let value = dict["status"] as? Int{
            statusCode = value
        }
        if let value = dict["result"] as? NSArray {
            for item in value {
                categoryItems.append(SuggestionItem.init(dict: item as! [String : Any?]))
            }
        }
    }
}

class SuggestionItem : NSObject{
    var categoryID:String = ""
    var comments:String = ""
    var userImage:String = ""
    var createdDate:String = ""
    var eventId:String = ""
    var sugId:String = ""
    var name:String = ""
    var userId:String = ""
    var rating:String = ""
    init(dict:[String:Any?]) {
        if let value = dict["category_id"] as? String{
            categoryID = value
        }
        if let value = dict["comments"] as? String{
            comments = value
        }
        if let value = dict["user_image"] as? String{
            userImage = value
        }
        if let value = dict["created_date"] as? String{
            createdDate = value
        }
        if let value = dict["event_id"] as? String{
            eventId = value
        }
        if let value = dict["name"] as? String{
            name = value
        }
        if let value = dict["sgg_id"] as? String{
            sugId = value
        }
        if let value = dict["rating"] as? String{
            rating = value
        }
        if let value = dict["user_id"] as? String{
            userId = value
        }
//        "place_files" =     (
//            "http://preparature.copycon.in/includes/uploads/VID-20171231-WA0010__3_5.mp4",
//            "http://preparature.copycon.in/includes/uploads/g211.jpg",
//            "http://preparature.copycon.in/includes/uploads/1296121-dark-pink-background16.jpg"
//        );
    }
}
