//
//  NetworkLayer.swift
//  NetworkRouter
//
//  Created by Evgeniy Stoyan on 29.08.2024.
//  Copyright © 2024 com.gmail@sev1001. All rights reserved.
//

import Foundation

public protocol HTTPService: Sendable {
    func fetch<Response>(_ endpoint: HTTPEndpoint,
                         type: Response.Type,
                         receiveOn queue: DispatchQueue,
                         validator: HTTPURLResponseValidatable,
                         _ finished: @escaping @Sendable (HTTPResult<Response, Error>) -> Void) where Response: Codable, Response: Sendable
    func fetch<Response>(_ endpoint: HTTPEndpoint,
                                validator: HTTPURLResponseValidatable) async throws -> Response where Response: Decodable
}
public final class HTTPManager: HTTPService {
    private let client: HTTPClient
    private let decoder: JSONDecoder
    
    public init(client: HTTPClient = URLSession.shared,
                decoder: JSONDecoder = JSONDecoder()) {
        self.client = client
        self.decoder = decoder
    }
    @preconcurrency
    public func fetch<Response>(_ endpoint: HTTPEndpoint,
                                type: Response.Type,
                                receiveOn queue: DispatchQueue,
                                validator: HTTPURLResponseValidatable = HTTPURLResponseValidator(),
                                _ finished: @escaping @Sendable (HTTPResult<Response, Error>) -> Void) where Response : Decodable, Response : Encodable, Response: Sendable {
        do {
            let request = try endpoint.request()
            let task = client.fetch(request: request) {[weak self] result in
                guard let self else {return}
                switch result {
                case let .success((data, httpResponse)):
                    do {
                        try validator.validate(httpResponse)
                        let decodedResponse = try decoder.decode(Response.self, from: data)
                        queue.async {
                            finished(.success(decodedResponse))
                        }
                    } catch {
                        queue.async {
                            finished(.failure(error))
                        }
                    }
                case let .failure(error):
                    queue.async {
                        finished(error.isURLRequestCancelled  ? .cancelled : .failure(error))
                    }
                }
            }
            task.start()
        } catch {
            queue.async {
                finished(.failure(error))
            }
        }
    }
    public func fetch<Response>(_ endpoint: HTTPEndpoint,
                                validator: HTTPURLResponseValidatable = HTTPURLResponseValidator()) async throws -> Response where Response: Decodable {
        let request = try endpoint.request()
        let (data, httpResponse) = try await client.fetch(request)
        try validator.validate(httpResponse)
        let response = try decoder.decode(Response.self, from: data)
        return response
    }
}
