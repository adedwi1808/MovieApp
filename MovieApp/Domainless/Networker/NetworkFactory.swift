//
//  NetworkFactory.swift
//  MovieApp
//
//  Created by Ade Dwi Prayitno on 20/01/25.
//

import Foundation

enum NetworkFactory {
    case popularMovies(page: Int)
    case movieDetail(id: Int)
    case movieVideos(id: Int)
    case movieReviews(id: Int, page: Int)
}

extension NetworkFactory {
    
    // MARK: URL PATH API
    var path: String {
        switch self {
        case .popularMovies: "/3/movie/popular"
        case .movieDetail(let id): "/3/movie/\(id)"
        case .movieVideos(let id): "/3/movie/\(id)/videos"
        case .movieReviews(let id, let page): "/3/movie/\(id)/reviews"
        }
    }
    
    // MARK: URL QUERY PARAMS / URL PARAMS
    var queryItems: [URLQueryItem] {
        switch self {
        case .popularMovies(let page):
            return [URLQueryItem(name: "page", value: "\(page)")]
        case .movieReviews(_, let page):
            return [URLQueryItem(name: "page", value: "\(page)")]
        default:
            return []
        }
    }
    
    var bodyParam: [String: Any]? {
        switch self {
        default:
            return nil
        }
    }
    
    // MARK: BASE URL API
    var baseApi: String? {
        switch self {
        default:
            return "api.themoviedb.org"
        }
    }
    
    // MARK: URL LINK
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = baseApi
        let finalParams: [URLQueryItem] = self.queryItems
        components.path = path
        components.queryItems = finalParams
        guard let url = components.url else {
            preconditionFailure("Invalid URL components: \(components)")
        }
        return url
    }
    
    // MARK: HTTP METHOD
    var method: RequestMethod {
        switch self {
        case .popularMovies, .movieDetail, .movieVideos, .movieReviews:
            return .get
        }
    }
    
    
    
    enum RequestMethod: String {
        case delete = "DELETE"
        case get = "GET"
        case patch = "PATCH"
        case post = "POST"
        case put = "PUT"
    }
    
    var boundary: String {
        let tmbdAccessToken = ConfigurationManager.shared.getValue(forKey: .tmbdAccessToken)
        let boundary: String = "Boundary-\(tmbdAccessToken)"
        return boundary
    }
    
    // MARK: MULTIPART DATA
    var data: [(paramName: String, fileData: Data, fileName: String)]? {
        switch self {
        default:
            return nil
        }
    }
    
    // MARK: HEADER API
    var headers: [String: String]? {
        switch self {
        case .popularMovies, .movieDetail, .movieVideos, .movieReviews:
            return getHeaders(type: .authorized)
        }
    }
    
    enum HeaderType {
        case anonymous
        case authorized
        case appToken
        case multiPart
        case authorizedMultipart
    }
    
    fileprivate func getHeaders(type: HeaderType) -> [String: String] {
        
        let tmbdAccessToken = ConfigurationManager.shared.getValue(forKey: .tmbdAccessToken)
        
        var header: [String: String]
        
        switch type {
        case .anonymous:
            header = [:]
        case .authorized:
            header = ["Content-Type": "application/json",
                      "Accept": "*/*",
                      "Authorization": "Bearer \(tmbdAccessToken)"]
            
        case .authorizedMultipart:
            header = ["Content-Type": "multipart/form-data; boundary=\(boundary)",
                      "Accept": "*/*",
                      "Authorization": "Bearer \(tmbdAccessToken)"]
        case .appToken:
            header = ["Content-Type": "application/json",
                      "Accept": "*/*"]
        case .multiPart:
            header = ["Content-Type": "multipart/form-data; boundary=\(boundary)",
                      "Accept": "*/*"]
        }
        return header
    }
    
    func createBodyWithParameters(parameters: [String: Any], imageDataKey: [(paramName: String, fileData: Data, fileName: String)]?, boundary: String) throws -> Data {
        let body = NSMutableData()
        
        for (key, value) in parameters {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)".data(using: .utf8)!)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        if let imageData = imageDataKey {
            for datum in imageData {
                if datum.fileData.count > 0,
                   datum.fileData != Data() {
                    body.append("--\(boundary)\r\n".data(using: .utf8)!)
                    body.append("Content-Disposition: form-data; name=\"\(datum.paramName)\"; filename=\"\(datum.fileName)\"\r\n".data(using: .utf8)!)
                    body.append("Content-Type: \(datum.fileData.mimeType)\r\n\r\n".data(using: .utf8)!)
                    body.append(datum.fileData)
                    body.append("\r\n".data(using: .utf8)!)
                }
            }
        }
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        return body as Data
    }
    
    var urlRequestMultiPart: URLRequest {
        var urlRequest = URLRequest(url: self.url)
        urlRequest.httpMethod = method.rawValue
        let boundary = boundary
        if let header = headers {
            header.forEach { key, value in
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        if let bodyParam = bodyParam, let datas = data {
            urlRequest.httpBody = try? createBodyWithParameters(parameters: bodyParam, imageDataKey: datas, boundary: boundary) as Data
        }
        
        return urlRequest
    }
    
    var urlRequest: URLRequest {
        var urlRequest = URLRequest(url: self.url, timeoutInterval: 10.0)
        var bodyData: Data?
        urlRequest.httpMethod = method.rawValue
        if let header = headers {
            header.forEach { (key, value) in
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        if let bodyParam = bodyParam, method != .get {
            do {
                bodyData = try JSONSerialization.data(withJSONObject: bodyParam, options: [.prettyPrinted])
                urlRequest.httpBody = bodyData
            } catch {
#if DEBUG
                print(error)
#endif
            }
        }
        return urlRequest
    }
}
