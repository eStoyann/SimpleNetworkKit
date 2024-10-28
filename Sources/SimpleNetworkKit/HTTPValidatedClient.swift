//
//  HTTPValidatedClient.swift
//  Network
//
//  Created by Evgeniy Stoyan on 28.10.2024.
//
import Foundation

public final class HTTPValidatedClient: HTTPClient {
    private let client: HTTPClient
    private let validator: HTTPURLResponseValidatable
    
    public init(client: HTTPClient = URLSession.shared,
                validator: HTTPURLResponseValidatable = HTTPURLResponseValidator()) {
        self.client = client
        self.validator = validator
    }
    
    public func fetch(request: URLRequest,
               _ finished: @escaping CompletionHandler) -> HTTPClientTask {
        client.fetch(request: request) {[weak self] result in
            guard let self else {return}
            switch result {
            case let .success((data, response)):
                do {
                    try self.validator.validate(response)
                    finished(.success((data, response)))
                } catch {
                    finished(.failure(error))
                }
            case let .failure(error):
                finished(.failure(error))
            }
        }
    }
}
