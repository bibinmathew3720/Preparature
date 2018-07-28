//
//  UserManager.swift
//  Preparture
//
//  Created by Bibin Mathew on 7/28/18.
//  Copyright © 2018 praveen raj. All rights reserved.
//

import UIKit

class UserManager: CLBaseService {
    
    //MARK : Log In Api
    
    func callingLogInApi(with body:String, success : @escaping (Any)->(),failure : @escaping (_ errorType:ErrorType)->()){
        CLNetworkManager().initateWebRequest(networkModelForLogIn(with:body), success: {
            (resultData) in
            let (jsonDict, error) = self.didReceiveStatesResponseSuccessFully(resultData)
            if error == nil {
                if let jdict = jsonDict{
                    print(jsonDict)
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
                    print(jsonDict)
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
}
    
class LogInResponseModel : NSObject{
        var statusMessage:String = ""
        var errorMessage:String = ""
        var statusCode:Int = 0
        var userId:Int = 0
        
        var name:String = ""
        var userName:String = ""
        var userEmail:String = ""
        var userProfileImageUrl:String = ""
        init(dict:[String:Any?]) {
            if let value = dict["message"] as? String{
                statusMessage = value
            }
            if let value = dict["errorMsg"] as? String{
                errorMessage = value
            }
            if let value = dict["status"] as? Int{
                statusCode = value
            }
            
            if let user = dict["user_details"] as? [String:AnyObject]{
                if let value = user["user_id"] as? Int{
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
              
//                if let value = user["u_profilePicURL"] as? String{
//                    userProfileImageUrl = value
//                }
            }
        }
    }

class SignUpResponseModel : NSObject{
    var statusMessage:String = ""
    var errorMessage:String = ""
    var statusCode:Int = 0
    var userId:Int = 0
    init(dict:[String:Any?]) {
        if let value = dict["message"] as? String{
            statusMessage = value
        }
        if let value = dict["errorMsg"] as? String{
            errorMessage = value
        }
        if let value = dict["status"] as? Int{
            statusCode = value
        }
        if let value = dict["user_id"] as? Int{
            userId = value
        }
    }
}
