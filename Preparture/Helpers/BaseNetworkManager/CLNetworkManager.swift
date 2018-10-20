//
//  CLNetworkManager.swift
//  CCLUB
//
//  Created by Albin Joseph on 2/7/18.
//  Copyright © 2018 Albin Joseph. All rights reserved.
//

import UIKit
import Alamofire

enum ErrorType : Int {
    case noNetwork = 1
    case dataError
    case notFound
    case internalServerError
    case forbidden
    case tokenExpired
}

class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

class CLNetworkManager: NSObject {
    func initateWebRequest(_ netWorkModel : CLNetworkModel, success:@escaping (_ result: Data)->(), failiure:@escaping (_ error:ErrorType)->()){
        if CLNetworkUtility.sharedInstance.isConnected() {
            var sessionConfiguration : URLSessionConfiguration = initSessionConfigurationobject(netWorkModel)
            sessionConfiguration.urlCache = nil
            sessionConfiguration.timeoutIntervalForRequest = 30.0
            sessionConfiguration.timeoutIntervalForResource = 30.0
            sessionConfiguration.urlCredentialStorage = nil
            let session : URLSession = URLSession(configuration: sessionConfiguration)
            defer {session.finishTasksAndInvalidate()}
            let requestObject : URLRequest? = createWebServiceRequestWithModel(netWorkModel) as URLRequest?
            if requestObject != nil{
                let sessionTask : URLSessionDataTask = session.dataTask(with: requestObject!, completionHandler: { (data, response , error) -> Void in
                    if let error_ = error{
                        DispatchQueue.main.async(execute: {[weak self] () -> () in
                            let errorReceived = error_ as NSError
                            if let _self = self{
                                failiure(_self.getErrorTypeFromCode(errorCode: errorReceived.code))
                            }else{
                                failiure(ErrorType.dataError)}})}else{
                        DispatchQueue.main.async(execute: { () -> () in
                            if let _data = data{
                                success(_data)
                            }else{failiure(ErrorType.dataError)}} )}})
                sessionTask.resume()
                
            }else{
                DispatchQueue.main.async(execute: { () -> () in
                    //request nil
                    failiure(ErrorType.dataError)
                })
            }
        }else{
            DispatchQueue.main.async(execute: { () -> () in
                failiure(ErrorType.noNetwork)
            })
        }
    }
    
    
    func createURLFromString(_ urlString :String)->URL?{
        let encodedUrlstring = urlString.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
        if let encodedUrlstring_ = encodedUrlstring{
            let requestURL = URL(string: encodedUrlstring_)
            return requestURL
        }else{
            return nil
        }
    }
    
    func initSessionConfigurationobject(_ netWorkModel_ : CLNetworkModel)->URLSessionConfiguration{
        let sessionConfiguration : URLSessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.httpAdditionalHeaders = netWorkModel_.requestHeader
        //sessionConfiguration.timeoutIntervalForRequest = 30.0
        //sessionConfiguration.timeoutIntervalForResource = 60.0
        return sessionConfiguration
    }
    
    func createWebServiceRequestWithModel(_ networkModel_: CLNetworkModel)->NSMutableURLRequest?{
        let requestUrl : URL?
        var urlRequest: NSMutableURLRequest?
        if networkModel_.requestURL != nil{
            requestUrl = createURLFromString(networkModel_.requestURL!)
            
            if let requestUrl_ = requestUrl{
                urlRequest = NSMutableURLRequest(url: requestUrl_)
                
                if let requestType = networkModel_.requestMethod{
                    urlRequest!.httpMethod = requestType
                }
                if let requestBody = networkModel_.requestBody{
                    urlRequest!.httpBody = requestBody.data(using: String.Encoding.utf8)
                }
                return urlRequest
                
            }else{
                return nil
            }
        }else{
            return nil
        }
    }
    
    func getErrorTypeFromCode(errorCode : Int) -> ErrorType {
        switch errorCode {
        case 0:
            return .noNetwork
        case 404:
            return .notFound
        case 401:
            return .tokenExpired
        case 403:
            return .forbidden
        case 500:
            return .internalServerError
        default:
            return .dataError
        }
    }
    
    
    //MARK: Alamofire
    class func callApi(with body:[String:Any], method:HTTPMethod, and url:String,success:@escaping(Any)->(),failure:@escaping(_ errorType:Any)->()) -> () {
        if Connectivity.isConnectedToInternet{
            let header = getHeader()
            let encode:ParameterEncoding = (method == .post || method == .put) ? JSONEncoding.default : URLEncoding.default
            Alamofire.request(url, method: method, parameters: body, encoding: encode, headers: header).responseJSON(completionHandler: { (response) in
                switch response.result{
                case .success(_):
                    guard let _statusCode = response.response?.statusCode else{
                        return
                    }
                    switch _statusCode{
                    case 200,201,203,204:
                        guard let _value = response.result.value else{
                            DispatchQueue.main.async {success("SUCESS")}
                            return
                        }
                        DispatchQueue.main.async {
                            success(_value)
                        }
                    case 400,401,403,404:
                        guard let _value = response.result.value else{
                            DispatchQueue.main.async {
                                failure(self.updateErrorValue(to: _statusCode, value: "Error"))
                            }
                            return
                        }
                        DispatchQueue.main.async {
                            failure(self.updateErrorValue(to: _statusCode, value: _value))
                        }

                    default:
                        guard let _value = response.result.value else{
                            DispatchQueue.main.async { failure(self.updateErrorValue(to: _statusCode, value: "Error"))}
                            return
                        }
                        DispatchQueue.main.async {
                             failure(self.updateErrorValue(to: _statusCode, value: _value))
                        }
                    }
                    
            case .failure(_):
                guard let _statusCode = response.response?.statusCode else{
                    return
                }
                switch _statusCode{
                case 200,201,203,204:
                    guard let _value = response.result.value else{
                        DispatchQueue.main.async {success("SUCESS")}
                        return
                    }
                    DispatchQueue.main.async {
                        success(_value)
                    }
                case 400,401,403,404:
                    guard let _value = response.result.value else{
                        DispatchQueue.main.async {
                            failure(self.updateErrorValue(to: _statusCode, value: "Error"))
                        }
                        return
                    }
                    DispatchQueue.main.async {
                        failure(self.updateErrorValue(to: _statusCode, value: _value))
                    }

                default:
                    guard let _value = response.result.value else{
                        DispatchQueue.main.async {failure(self.updateErrorValue(to: _statusCode, value: "Error"))}
                        return
                    }
                    DispatchQueue.main.async {
                       failure(self.updateErrorValue(to: _statusCode, value: _value))
                    }
                    }
                }
            })
        }else{
            var dict:[String:Any] = [String:Any]()
            dict.updateValue(Constant.GenAlerts.noNetwork, forKey: "detail")
            dict.updateValue(1, forKey: "statusCode")
            failure(dict)
        }
    }
        
        //Get
       class func callGetApi(with body:[String:Any], method:HTTPMethod, and url:String,success:@escaping(Any)->(),failure:@escaping(_ errorType:Any)->()) -> () {
         if Connectivity.isConnectedToInternet{
            let header = getHeader()
            Alamofire.request(url, method: method, encoding: URLEncoding.default, headers: header).responseJSON(completionHandler: { (response) in
                switch response.result{
                case .success(_):
                    guard let _statusCode = response.response?.statusCode else{
                        return
                    }
                    switch _statusCode{
                    case 200,201,203,204:
                        guard let _value = response.result.value else{
                            DispatchQueue.main.async {success("SUCESS")}
                            return
                        }
                        DispatchQueue.main.async {
                            success(_value)
                        }
                    case 400,401,403,404:
                        guard let _value = response.result.value else{
                            DispatchQueue.main.async {
                               failure(self.updateErrorValue(to: _statusCode, value: "Error"))
                            }
                            return
                        }
                        DispatchQueue.main.async {
                            failure(self.updateErrorValue(to: _statusCode, value: _value))
                        }

                    default:
                        guard let _value = response.result.value else{
                            DispatchQueue.main.async {failure(self.updateErrorValue(to: _statusCode, value: "Error"))}
                            return
                        }
                        DispatchQueue.main.async {
                            failure(self.updateErrorValue(to: _statusCode, value: _value))
                        }
                    }
                    
                case .failure(_):
                    guard let _statusCode = response.response?.statusCode else{
                        return
                    }
                    switch _statusCode{
                    case 200,201,203,204:
                        guard let _value = response.result.value else{
                            DispatchQueue.main.async {success("SUCESS")}
                            return
                        }
                        DispatchQueue.main.async {
                            success(_value)
                        }
                    case 400,401,403,404:
                        guard let _value = response.result.value else{
                            DispatchQueue.main.async {
                                failure(self.updateErrorValue(to: _statusCode, value: "Error"))
                            }
                            return
                        }
                        DispatchQueue.main.async {
                            failure(self.updateErrorValue(to: _statusCode, value: _value))
                        }

                    default:
                        guard let _value = response.result.value else{
                            DispatchQueue.main.async {failure(self.updateErrorValue(to: _statusCode, value: "Error"))}
                            return
                        }
                        DispatchQueue.main.async {
                            failure(self.updateErrorValue(to: _statusCode, value: _value))
                        }
                    }
                }
            })}else{
            var dict:[String:Any] = [String:Any]()
             dict.updateValue(Constant.GenAlerts.noNetwork, forKey: "detail")
            dict.updateValue(1, forKey: "statusCode")
            failure(dict)
        }
        }
    
   class func updateErrorValue(to errorCode:Int,value:Any) -> [String:Any] {
         var dict:[String:Any] = [String:Any]()
        if let _value = value as? [String:Any]{
           dict = _value
        }else{
          dict.updateValue(value, forKey: "detail")
        }
       
        dict.updateValue(errorCode, forKey: "statusCode")
        return dict
    }
    
    class func getHeader() -> [String:String] {
        var header = [String:String]()
         header.updateValue("application/json", forKey: "Content-Type")
//        guard let _cLTokenModel = CLAppController.sharedInstance.cLTokenModel else {
//            return header
//        }
//        header.updateValue(_cLTokenModel.tokenType+" "+_cLTokenModel.accessToken, forKey: "Authorization")
       // header.updateValue("application/json", forKey: "Content-Type")
        return header
    }
}

