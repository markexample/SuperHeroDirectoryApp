//
//  GenericApiClient.swift
//  Marvel
//
//  Created by Mark Dalton on 7/3/21.
//

import UIKit
import Alamofire

/// API error types.
enum APIError: String, Error {
    case clientError
    case serverError
    case noData
    case dataDecodingError
}

/// API client protocol.
protocol APIClientProtocol {
    func fetchInfo<T: Decodable>(_ type: RequestType, decode: @escaping (Decodable) -> T?, complete:@escaping (Result<T,APIError> )->())
}

extension APIClientProtocol {
    
    /// Fetch info from api.
    /// - Parameters:
    ///   - type: Request type used.
    ///   - decode: Decoding handler.
    ///   - completion: Completion of result decoded response.
    func fetchInfo<T: Decodable>(_ type: RequestType, decode: @escaping (Decodable) -> T?, complete completion: @escaping (Result<T, APIError>) -> Void) {
        AF.request(type.urlComponents).responseData { response in
            
            // Check for client error.
            if let _ = response.error {
                completion(.failure(.clientError))
                return
            }
            
            // Check for server error.
            guard let statusCode = response.response?.statusCode, 200...299 ~= statusCode else {
                completion(.failure(.serverError))
                return
            }
            
            // Check data exists.
            guard let data = response.data else {
                completion(.failure(.noData))
                return
            }
            
            // Decoder.
            let decoder = JSONDecoder()
            do {
                
                // Decode.
                let value = try decoder.decode(T.self, from: data)

                // If result is valid, send in completion.
                if let result = decode(value) {
                    completion(.success(result))
                }
            } catch {
                
                // Error decoding data.
                print(String(describing: error))
                completion(.failure(.dataDecodingError))
            }
        }
    }
}
