//
//  Services.swift
//  Appcent Test
//
//  Created by Amir Daliri on 5/5/20.
//  Copyright © 2020 Amir Daliri. All rights reserved.
//

import Alamofire

extension ApiRouter {
    
    enum BaseServicesEndPoint: String {
        case getRecent = "services/rest/"
    }
    
    enum BaseServices: URLRequestConvertible {
        
        case getRecent(perPage: Int, page: Int)
        
        
        var method: Alamofire.HTTPMethod {
            switch self {
                
            case .getRecent:
                return .get
            }
        }
        
        func asURLRequest() throws -> URLRequest {
            let result: (path: String, parameters: [String: AnyObject]?) = {
                switch self {
                    
                case .getRecent(let perPage, let page):
                    let params: [String: AnyObject] = ["per_page": perPage as AnyObject, "page": page as AnyObject, "api_key": APIConstants.apiKey as AnyObject, "method": APIConstants.methode as AnyObject]
                    return (BaseServicesEndPoint.getRecent.rawValue, params)
                }
            }()
            
            // MARK: - Set HTTP Header Field
            let base = URL(string: APIConstants.baseUrl)!
            let baseAppend = base.appendingPathComponent(result.path).absoluteString.removingPercentEncoding
            let url = URL(string: baseAppend!)
            var urlRequest = URLRequest(url: url!)
            urlRequest.httpMethod = method.rawValue
            let encoding = try URLEncoding.default.encode(urlRequest, with: result.parameters)
            return encoding
        }
    }
}

extension ApiRequest {
    
    func getPhotos(perPage: Int, page: Int, _ completionHandler: @escaping (Bool, Photos?) -> Void) {
        DefaultAlamofireManager.sharedManager.request(ApiRouter.BaseServices.getRecent(perPage: perPage, page: page)).validate().responseXMLObject { (response: DataResponse<BasePhotosResponse>) in
            switch response.result {
            case .success(let result):
                if let photos = result.photos {
                    completionHandler(true, photos)
                } else {
                    completionHandler(false, nil)
                }
            case .failure(_):
                completionHandler(false, nil)
            }
        }
    }
}
