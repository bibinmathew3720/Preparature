//
//  CLNetworkManager.swift
//  CCLUB
//
//  Created by Albin Joseph on 2/7/18.
//  Copyright © 2018 Albin Joseph. All rights reserved.
//

import UIKit
enum MIMEType : String {
    case JPEG
    case PNG
    case DOC
    case PDF
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
                            else if (errorReceived.code == -2103){
                                failiure(.internalServerError)
                            }
                            else{
                                failiure( (self?.getErrorTypeFromCode(errorCode: errorReceived.code))!)
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
    //TODO:- UPLOAD IMAGE
    static func upload(file:Data,type:MIMEType,ext:String,url:String,parameters:String?,headers:[String:String]?, completionHandler:@escaping([String : Any]?,Bool,ErrorType?) ->Void) ->Void {
        
        let config = URLSessionConfiguration.default
        let session = URLSession.init(configuration: config, delegate: nil, delegateQueue: OperationQueue.main)
        let characterSet = CharacterSet.urlQueryAllowed
        let queryUrl = URL.init(string: url.addingPercentEncoding(withAllowedCharacters: characterSet)!)
        let boundary = "---------------------------14737809831466499882746641449"
        var request = URLRequest.init(url: queryUrl!)
        request.httpMethod = "POST"
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        if headers != nil {
            request.allHTTPHeaderFields = headers
        }
        
        let body = NSMutableData()
        let boundaryPrefix = "--\(boundary)\r\n"
        let uploadFile = "image." + ext
        let mimeType = CLNetworkManager().mime(type: type)
        
        
        body.appendString(boundaryPrefix)
        body.appendString("Content-Disposition: form-data; name=\"files\"; filename=\"\(uploadFile)\"\r\n")
        body.appendString("Content-Type: \(mimeType)\r\n\r\n")
        body.append(file)
        body.appendString("\r\n")
        
        //Text params
        body.appendString(boundaryPrefix)
        body.appendString("Content-Disposition: form-data; name=\"message\"\r\n\r\n")
        body.appendString("")
        body.appendString("\r\n")
        
        body.appendString("--\(boundary)--\r\n")
        
        request.httpBody = body as Data
        
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if error == nil  {
                let httpResponse = response as! HTTPURLResponse
                print(httpResponse.statusCode)
                if httpResponse.statusCode == 200 {
                    do {
                        if let jsondata = data ,
                            let json = try JSONSerialization.jsonObject(with: jsondata, options: []) as? [String : Any] {
                            
                            print(json as AnyObject)
                            /*if json["status"] as! String == APIStatus.SUCCESS {
                             completionHandler(json,true,json["message"] as? String)
                             }
                             else {
                             completionHandler(nil,false,json["message"] as? String)
                             }*/
                            completionHandler(json,true,nil)
                            
                        }
                        else {
                            //DATA IS NIL
                            completionHandler(nil,false,ErrorType.dataError)
                        }
                    }
                    catch {
                        //JSON CANNOT SERIALISED
                        completionHandler(nil,false,ErrorType.dataError)
                    }
                }
                else {
                    //BAD RESPONSE - 404,402
                    completionHandler(nil,false,ErrorType.dataError)
                }
            }
            else{
                //BAD RESPONSE - 500
                completionHandler(nil,false,ErrorType.noNetwork)
            }
        }
        task.resume()
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
    func mime(type: MIMEType) ->String {
        switch type {
        case .JPEG:
            return "image/jpeg"
        case .PNG:
            return "image/png"
        default:
            return ""
        }
    }
}
extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}
