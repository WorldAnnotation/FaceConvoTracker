//
//  GPT4Manager.swift
//  prototype-ios
//
//  Created by 山口真 on 2024/03/09.
//

//import Foundation
//
//import Foundation
//import Combine
//
//class GPT4Manager {
//    func generateExplanation(for keyword: String) -> AnyPublisher<String, Error> {
//        let apiKey = ""
//        let urlString = "https://api.openai.com/v1/engines/gpt-4/completions"
//        guard let url = URL(string: urlString) else {
//            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
//        }
//        
//        let prompt = "Explain the meaning of the word '\(keyword)' in a concise manner."
//        let parameters: [String: Any] = [
//            "prompt": prompt,
//            "max_tokens": 100,
//            "n": 1,
//            "temperature": 0.7
//        ]
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
//        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
//        
//        return URLSession.shared.dataTaskPublisher(for: request)
//            .map { $0.data }
//            .mapError { $0 as Error }
//            .flatMap { data -> AnyPublisher<String, Error> in
//                return Future<String, Error> { promise in
//                    do {
//                        guard let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
//                              let choices = jsonResult["choices"] as? [[String: Any]],
//                              let explanation = choices.first?["text"] as? String else {
//                            promise(.failure(GPT4Error.invalidResponse))
//                            return
//                        }
//                        promise(.success(explanation.trimmingCharacters(in: .whitespacesAndNewlines)))
//                    } catch {
//                        promise(.failure(error))
//                    }
//                }
//                .eraseToAnyPublisher()
//            }
//            .eraseToAnyPublisher()
//    }
//}
//
//enum GPT4Error: Error {
//    case invalidResponse
//}
import Foundation
import Combine

class GPT4Manager {
    func generateExplanation(for keyword: String) -> AnyPublisher<String, Error> {
        let urlString = "https://api.openai.com/v1/chat/completions"
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        let messages = [
            ["role": "system", "content": "You are an AI assistant that provides concise explanations for given words."],
            ["role": "user", "content": "Explain the meaning of the word '\(keyword)' in a concise manner."]
        ]
        
        let parameters: [String: Any] = [
            "model": "gpt-4",
            "messages": messages,
            "max_tokens": 100,
            "n": 1,
            "temperature": 0.7
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: GPT4Response.self, decoder: JSONDecoder())
            .map { $0.choices[0].message.content.trimmingCharacters(in: .whitespacesAndNewlines) }
            .mapError { error -> Error in
                if let decodingError = error as? DecodingError {
                    return GPT4Error.invalidResponse(decodingError)
                }
                return error
            }
            .eraseToAnyPublisher()
    }
}

struct GPT4Response: Codable {
    let choices: [GPT4Choice]
}

struct GPT4Choice: Codable {
    let message: GPT4Message
}

struct GPT4Message: Codable {
    let content: String
}

enum GPT4Error: Error {
    case invalidResponse(Error)
}
