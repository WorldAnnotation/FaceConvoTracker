//
//  GroqManager.swift
//  prototype-ios
//
//  Created by 山口真 on 2024/03/09.
//



import Foundation
import Combine

class GroqManager {
    func generateExplanation(for keyword: String) -> AnyPublisher<String, Error> {
        let apiKey = "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"
        let urlString = "https://api.groq.com/v1/explain"
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        let parameters: [String: Any] = [
            "text": keyword
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .mapError { $0 as Error }
            .flatMap { data -> AnyPublisher<String, Error> in
                return Future<String, Error> { promise in
                    do {
                        guard let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                              let explanation = jsonResult["explanation"] as? String else {
                            promise(.failure(GroqError.invalidResponse))
                            return
                        }
                        promise(.success(explanation))
                    } catch {
                        promise(.failure(error))
                    }
                }
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}

enum GroqError: Error {
    case invalidResponse
}
