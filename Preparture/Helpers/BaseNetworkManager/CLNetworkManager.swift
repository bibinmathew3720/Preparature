//
//  CLNetworkManager.swift
//  CCLUB
//
//  Created by Albin Joseph on 2/7/18.
//  Copyright © 2018 Albin Joseph. All rights reserved.
//

import UIKit

class CLNetworkManager: NSObject {
    func initateWebRequest(_ netWorkModel : CLNetworkModel, success:@escaping (_ result: Data)->(), failiure:@escaping (_ error:ErrorType)->()){
        if CLNetworkUtility.sharedInstance.isConnected() {
            var sessionConfiguration : URLSessionConfiguration = initSessionConfigurationobject(netWorkModel)
            sessionConfiguration.urlCache = nil
            sessionConfiguration.timeoutIntervalForRequest = 30.0
            sessionConfiguration.timeoutIntervalForResource = 30.0
            sessionConfiguration.urlCredentialStorage = nil
            let session : URLSession = URLSession(configuration: sessionConfiguration)
            defer {
                session.finishTasksAndInvalidate()
            }
            let requestObject : URLRequest? = createWebServiceRequestWithModel(netWorkModel) as URLRequest?
            if requestObject != nil{
                let sessionTask : URLSessionDataTask = session.dataTask(with: requestObject!, completionHandler: { (data, response , error) -> Void in
                    if let error_ = error{
                        DispatchQueue.main.async(execute: {[weak self] () -> () in
                            let errorReceived = error_ as NSError
                            if(errorReceived.code == -1004){
                               failiure(.internalServerError)
                            }
                            else{
                                 failiure( (self?.getErrorTypeFromCode(errorCode: (errorReceived.code)))!)
                            }
                        })
                    }else{
                        DispatchQueue.main.async(execute: { () -> () in
                            if let _data = data{
                                success(_data)
                            }else{
                                failiure(ErrorType.dataError)
                            }
                            
                        } )           }
                })
                sessionTask.resume()
                
            }else{
                DispatchQueue.main.async(execute: { () -> () in
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
        case 500:
            return .internalServerError
        default:
            return .noNetwork
        }
    }
}
