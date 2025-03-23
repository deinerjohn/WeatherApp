//
//  NetworkRequest.swift
//  Infrastructure
//
//  Created by Deiner John Calbang on 3/20/25.
//

import Foundation
//import Domain

public protocol NetworkRequest {
    func request<T: Decodable>(endpoint: Endpoint, responseModel: T.Type) async throws -> T
}

public extension NetworkRequest {
    func request<T: Decodable>(endpoint: Endpoint, responseModel: T.Type) async throws -> T {
        
        var components = URLComponents(string: endpoint.baseUrl + endpoint.path)
        components?.queryItems = endpoint.queries.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        guard let composeUrl = components?.url else  {
            throw NetworkError.invalidUrl
        }
        
        var request = URLRequest(url: composeUrl)
        request.httpMethod = endpoint.method.rawValue
        request.timeoutInterval = TimeInterval(30)

        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = [
            "Accept-Encoding": "gzip;q=1.0, compress;q=0.5",
            "Accept-Language": Locale.preferredLanguages.prefix(6).enumerated().map { index, languageCode in
                let quality = 1.0 - (Double(index) * 0.1)
                return "\(languageCode);q=\(quality)"
            }.joined(separator: ", "),
            "Accept": "application/json"
        ]
        
        let (data, response) = try await URLSession(configuration: configuration).data(for: request)
        guard let response = response as? HTTPURLResponse else {
            self.logError(error: .noResponse, endpoint: endpoint, statusCode: 0, data: data)
            throw NetworkError.noResponse
        }
        switch response.statusCode {
        case 200...299:
            
            do {
                self.logSuccess(endpoint: endpoint, statusCode: response.statusCode, data: data)
                let decodedResponse = try JSONDecoder().decode(responseModel, from: data)
                return decodedResponse
            } catch DecodingError.keyNotFound(_, let context),
                    DecodingError.valueNotFound(_, let context),
                    DecodingError.typeMismatch(_, let context),
                    DecodingError.dataCorrupted(let context) {
                print(context.debugDescription)
                throw NetworkError.decodeError
            }catch {
                self.logError(error: .decodeError, endpoint: endpoint, statusCode: response.statusCode, data: data)
                throw NetworkError.decodeError
            }
            
        case 400:
            
            throw NetworkError.unexpectedStatusCode
        case 401:
            throw NetworkError.unexpectedStatusCode
        default:
//            guard let decodedResponse = try? JSONDecoder().decode(GenericFaulStringError.self, from: data) else {
//                self.logError(error: .decodeError, endpoint: endpoint, statusCode: response.statusCode, data: data)
//                throw NetworkError.unexpectedStatusCode
//            }
            
            throw NetworkError.unexpectedStatusCode
        }
        
    }
    
    private func logSuccess(endpoint: Endpoint, statusCode: Int, data: Foundation.Data) {
        let httpMethod = endpoint.method.rawValue
        let statusCode = statusCode
        var message = "Successfully made | \(httpMethod) | \(statusCode) | request | queries: \(endpoint.queries)"
        
 
        if let parsedData = parseData(data: data) {
            message += parsedData
        }

        Logger.debug(message)
        
    }
    
    private func logError(error: NetworkError, endpoint: Endpoint, statusCode: Int, data: Foundation.Data) {
        let httpMethod = endpoint.method.rawValue
        let statusCode = statusCode
        var message = "Failed to make | \(httpMethod) | " +
            "\(statusCode) | " +
        "request,\nwith error -" + (error.debugDescription)
        
        if let parsedData = parseData(data: data) {
            message += parsedData
        }

        Logger.error(message)
        
    }
    
    private func parseData(data: Foundation.Data?) -> String? {
        
        guard let data = data else { return nil }
        let parsedData: String?
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            guard JSONSerialization.isValidJSONObject(json) else {
                throw NetworkError.decodeError
            }
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted, .sortedKeys])
            parsedData = String(data: jsonData, encoding: .utf8)
        } catch {
            parsedData = String(data: data, encoding: .utf8)
        }
        if let tail = parsedData {
            return "\n\n \(tail)"
        } else {
            return nil
        }
        
    }
    
}
