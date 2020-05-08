//
//  NetworkLayer.swift
//  Appcent Test
//
//  Created by Amir Daliri on 5/5/20.
//  Copyright © 2020 Amir Daliri. All rights reserved.
//

import Foundation
import Alamofire

class DefaultAlamofireManager: Alamofire.SessionManager {
    static let sharedManager: DefaultAlamofireManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 50
        configuration.timeoutIntervalForResource = 50
        configuration.requestCachePolicy = .useProtocolCachePolicy
        return DefaultAlamofireManager(configuration: configuration)
    }()
}

enum BackendError: Error {
    case network(error: Error) // Capture any underlying Error from the URLSession API ///
    case dataSerialization(error: Error)
    case jsonSerialization(error: Error)
    case xmlSerialization(error: Error)
    case objectSerialization(reason: String)
}

public protocol ResponseCollectionSerializable {
    static func collection(from response: HTTPURLResponse, withRepresentation representation: Any) -> [Self]
}

public protocol ResponseObjectSerializable {
    init?(response: HTTPURLResponse, representation: Any)
}

extension ResponseCollectionSerializable where Self: ResponseObjectSerializable {
    static func collection(from response: HTTPURLResponse, withRepresentation representation: Any) -> [Self] {
        var collection: [Self] = []
        if let representation = representation as? [[String: Any]] {
            for itemRepresentation in representation {
                if let item = Self(response: response, representation: itemRepresentation) {
                    collection.append(item)
                }
            }
        }
        
        return collection
    }
}

extension DataRequest {
    @discardableResult
    public func responseObject<T: ResponseObjectSerializable>(
        _ queue: DispatchQueue? = nil,
        completionHandler: @escaping (DataResponse<T>) -> Void)
        -> Self {
            let responseSerializer = DataResponseSerializer<T> { request, response, data, error in
                guard error == nil else { return .failure(BackendError.network(error: error!)) }
                
                let jsonResponseSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
                let result = jsonResponseSerializer.serializeResponse(request, response, data, nil)
                
                guard case let .success(jsonObject) = result else {
                    return .failure(BackendError.jsonSerialization(error: result.error!))
                }
                
                guard let response = response, let responseObject = T(response: response, representation: jsonObject) else {
                    return .failure(BackendError.objectSerialization(reason: "JSON could not be serialized: \(jsonObject)"))
                }
                
                return .success(responseObject)
            }
            
            return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseCollection<T: ResponseCollectionSerializable>(
        _ queue: DispatchQueue? = nil,
        completionHandler: @escaping (DataResponse<[T]>) -> Void) -> Self {
        let responseSerializer = DataResponseSerializer<[T]> { request, response, data, error in
            guard error == nil else { return .failure(BackendError.network(error: error!)) }
            
            let jsonSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
            let result = jsonSerializer.serializeResponse(request, response, data, nil)
            
            guard case let .success(jsonObject) = result else {
                return .failure(BackendError.jsonSerialization(error: result.error!))
            }
            
            guard let response = response else {
                let reason = "Response collection could not be serialized due to nil response."
                return .failure(BackendError.objectSerialization(reason: reason))
            }
            
            return .success(T.collection(from: response, withRepresentation: jsonObject))
        }
        
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}

// MARK: - API Router Methode

struct ApiRouter {}

struct ImageRouter {}

// MARK: - Api Request

class ApiRequest: NSObject {
    static let shared = ApiRequest()
}

extension String: ParameterEncoding {
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
}


struct JSONStringArrayEncoding: ParameterEncoding {
    private let myString: String

    init(string: String) {
        self.myString = string
    }

    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = urlRequest.urlRequest

        let data = myString.data(using: .utf8)!

        if urlRequest?.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest?.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        urlRequest?.httpBody = data

        return urlRequest!
    }
}

struct APIConstants {
    static let baseUrl = "https://api.flickr.com/"
    static let apiKey = "068fc713006bf371d9a6db446ab942a4"
    static let methode = "flickr.photos.getRecent"
}
