//
//  HTTPURLBuilder.swift
//  NetworkRouter
//
//  Created by Evgeniy Stoyan on 09.09.2024.
//  Copyright © 2024 com.gmail@sev1001. All rights reserved.
//

import Foundation

public protocol HTTPURLBuilder {
    var url: URL?{get}
}

public struct URLBuilder: HTTPURLBuilder {
    typealias QueryParameters = [String: String]
    private var components: URLComponents
    
    public var url: URL? {
        components.url
    }
    public init(scheme: HTTPScheme = .https,
         host: String,
         path: String,
         queryParameters: QueryParameters? = nil) {
        self.components = URLComponents()
        self.components.scheme = scheme.rawValue
        self.components.host = host
        self.components.path = path
        self.components.percentEncodedQueryItems = queryParameters?.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
    }
}
