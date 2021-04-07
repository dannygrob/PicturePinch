//
//  APIManager.swift
//  PicturePinch
//
//  Created by Danny Grob on 18/12/2021.
//

import Foundation
import Alamofire
import SwiftyJSON

enum APIError:LocalizedError {
    case noInternet(message:String, statusCode:Int, tag:String)
    case badURL(message:String, statusCode:Int, tag:String)
    case unknownError(message:String, statusCode:Int, tag:String)
    
    var errorDescription: String? {
        switch self {
        case let .noInternet(_, _, tag):
            return tag.translate()
        case let .badURL(message, _, tag):
            let trans =  tag.translate()
            if trans == tag {
                return message
            } else {
                return trans
            }
        case let .unknownError(message, _, tag):
            let trans =  tag.translate()
            if trans == tag {
                return message
            } else {
                return trans
            }
        }
        
    }
    
}

extension APIError: CustomNSError {

    public static var errorDomain: String {
        return "myDomain"
    }

    public var errorCode: Int {
        switch self {
        case let .noInternet(_, statusCode, _):
            return statusCode
        case let .badURL(_, statusCode, _):
            return statusCode
        case let .unknownError(_, statusCode, _):
            return statusCode
        }
    }

}

enum ServerConfig {
    case test
    case accept
    case production
    
    var instance: Server {
        switch self {
        case .test:
            return Server(host: "http://testapi.pinch.nl:3000/")
        case .accept:
            return Server(host: "http://testapi.pinch.nl:3000/")
        case .production:
            return Server(host: "http://testapi.pinch.nl:3000/")
        }
    }
}

struct Server {
    var host: String
}

class APIService {
    
    var headers: HTTPHeaders = [.accept("application/json"),
                                .acceptEncoding("gzip, deflate")]
    var request: Request?
    var config:Server
    
    init() {
        config = ServerConfig.test.instance
    }
    
    func get(host:String? = nil, path:String, completion: @escaping (Result<JSON, APIError>) -> Void) {
        self.handleRequest(host: host ?? config.host, path: path, method: .get, completion: completion)
    }
    
    func post(host:String? = nil, path:String, params:[String:Any], completion: @escaping (Result<JSON, APIError>) -> Void) {
        self.handleRequest(host:host ?? config.host, path: path, method: .post, params: params, completion: completion)
    }
    
    func patch(host:String? = nil, path:String, params:[String:Any], completion: @escaping (Result<JSON, APIError>) -> Void) {
        self.handleRequest(host:host ?? config.host, path: path, method: .patch, params: params, completion: completion)
    }
    
    func delete(host:String? = nil, path:String, completion: @escaping (Result<JSON, APIError>) -> Void) {
        self.handleRequest(host:host ?? config.host, path: path, method: .delete, completion: completion)
    }
    
    func handleRequest(host:String, path:String, method: HTTPMethod, params:[String:Any]? = nil, completion: @escaping (Result<JSON, APIError>) -> Void) {
        guard let url = URL(string: host + path) else {
            completion(.failure(.badURL(message:  "Invalid url \(host)\(path)", statusCode: 999, tag: "url_invalid")))
            return
        }
        
        var requestHeaders = HTTPHeaders.init()
        for header in self.headers {
            requestHeaders.add(header)
        }
        requestHeaders.add(.init(name: "Content-Type", value: "application/json"))
        
        AF.request(url, method: method, parameters:params, encoding: JSONEncoding.default, headers: requestHeaders).responseData { (response) in
            switch response.result {
            case .success(let responseData):
                
                if let jsonObject = try? JSON(data: responseData) {
                    if response.response?.statusCode != 200 {
                        if response.response?.statusCode == 401 {
                            //TODO: implement logout?
                            return
                        } else {
                            print(response.error?.localizedDescription ?? "")
                            var message = jsonObject["error"]["code"].stringValue.translate()
                            if message == jsonObject["error"]["code"].stringValue {
                                message = jsonObject["error"]["message"].stringValue
                            }
                            completion(.failure(.unknownError(message: message, statusCode: response.response?.statusCode ?? 999, tag: jsonObject["error"]["code"].stringValue)))
                            print(jsonObject["error"]["message"].stringValue)
                            return
                        }
                    }
                
                    completion(.success(jsonObject))
                    return
                }
                
                break
            case .failure(let afError):
                print(afError.localizedDescription)
                completion(.failure(.unknownError(message: afError.localizedDescription, statusCode: response.response?.statusCode ?? 999, tag: "")))
            }
        }
    }
}


