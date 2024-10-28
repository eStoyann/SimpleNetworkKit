//
//  HTTPClientTask.swift
//  NetworkRouter
//
//  Created by Evgeniy Stoyan on 09.09.2024.
//  Copyright © 2024 com.gmail@sev1001. All rights reserved.
//

import Foundation

public protocol HTTPClientTask {
    var status: URLSessionTask.State {get}
    func stop()
    func start()
}

extension URLSessionTask: HTTPClientTask {
    public func stop() {
        cancel()
    }
    public func start() {
        resume()
    }
    public var status: URLSessionTask.State {
        state
    }
}
