//
//  HTTPURLResponseValidatable.swift
//  NetworkAPI
//
//  Created by Evgeniy Stoyan on 28.10.2024.
//

import Foundation

public protocol HTTPURLResponseValidatable: Sendable {
    func validate(_ response: HTTPURLResponse) throws
}
public struct HTTPURLResponseValidator: HTTPURLResponseValidatable {
    enum Errors: Error {
        case invalid(_ statusCode: Int)
    }
    private let statusCode: ClosedRange<Int>
    
    public init(statusCode: ClosedRange<Int> = 200...299) {
        self.statusCode = statusCode
    }
    
    public func validate(_ httpResponse: HTTPURLResponse) throws {
        guard statusCode ~= httpResponse.statusCode else {
            throw Errors.invalid(httpResponse.statusCode)
        }
    }
}
