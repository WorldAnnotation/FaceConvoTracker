//
//  WikiopediaManager.swift
//  prototype-ios
//
//  Created by 山口真 on 2024/03/08.
//

import Foundation
import Combine
import SwiftSoup

class WikipediaManager {
    func searchWikipedia(for keyword: String) -> AnyPublisher<String, Error> {
        let urlString = "https://ja.wikipedia.org/wiki/\(keyword)"
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .mapError { $0 as Error } // URLErrorをErrorプロトコルに準拠させる
            .flatMap { data -> AnyPublisher<String, Error> in
                return Future<String, Error> { promise in
                    do {
                        let html = String(data: data, encoding: .utf8) ?? ""
                        let doc: Document = try SwiftSoup.parse(html)
                        let summary = try doc.select("div.mw-parser-output > p:first-of-type").text()
                        promise(.success(summary))
                    } catch {
                        promise(.failure(error))
                    }
                }
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}

