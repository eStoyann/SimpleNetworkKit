//
//  HTTPHeader.swift
//  NetworkRouter
//
//  Created by Evgeniy Stoyan on 09.09.2024.
//  Copyright © 2024 com.gmail@sev1001. All rights reserved.
//

import Foundation

public typealias HTTPHeaderKey = String
public typealias HTTPHeaderValue = String
public typealias HTTPHeaders = [HTTPHeaderKey: HTTPHeaderValue]
public let cHTTPHeaderContentTypeKey: HTTPHeaderKey = "Content-Type"
public let cHTTPHeaderContentTypeValue: HTTPHeaderValue = "application/json"
