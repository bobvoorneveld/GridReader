//
//  Webservice.swift
//  GridReader
//
//  Created by Bob Voorneveld on 11/02/2017.
//  Copyright © 2017 Purple Gorilla. All rights reserved.
//

import Foundation

public enum WebserviceError: Error {
    case unauthorized
    case forbidden
    case notFound
    case other(String)
}

public enum Result<A> {
    case success(A)
    case failure(Error)
}

public final class Webservice {
    /// Fires request to remote service
    ///
    /// - Parameters:
    ///   - resource: The resource that is requested
    ///   - completion: completionblock that will be called after the request has finished.
    ///         Completionblock will be called with WebserviceResult
    public static func load<A>(resource: Resource<A>, completion: @escaping (Result<A?>) -> ()) {
        let url = URL(string: "http://127.0.0.1:8080/\(resource.path)")!
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }

            let resp = response as! HTTPURLResponse
            switch resp.statusCode {
            case 401:
                completion(.failure(WebserviceError.unauthorized))
            case 403:
                completion(.failure(WebserviceError.forbidden))
            case 404:
                completion(.failure(WebserviceError.notFound))
            case let code where code / 100 != 2:
                completion(.failure(WebserviceError.other("Wrong status: \(resp.statusCode)")))
            default:
                let result = data.flatMap(resource.parse)
                completion(.success(result))
            }
        }.resume()
    }
}
