//
//  WikipediaAPIManager.swift
//  prototype-ios
//
//  Created by 山口真 on 2024/03/06.
//

import Foundation

class WikipediaAPIManager {
    
    /// Wikipediaでキーワードに関連する情報を検索する
    /// - Parameters:
    ///   - keyword: 検索するキーワード
    ///   - completion: 検索結果を受け取るためのコールバック。成功時はString、失敗時はErrorを返す。
    func searchKeyword(_ keyword: String, completion: @escaping (Result<String, Error>) -> Void) {
        let baseUrl = "https://ja.wikipedia.org/w/api.php"
        let parameters = [
            "format": "json",
            "action": "query",
            "prop": "extracts",
            "exintro": "",
            "explaintext": "",
            "titles": keyword
        ]
        
        var urlComponents = URLComponents(string: baseUrl)!
        urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        guard let url = urlComponents.url else {
            completion(.failure(NSError(domain: "WikipediaAPIManagerError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let query = json["query"] as? [String: Any],
                  let pages = query["pages"] as? [String: Any],
                  let pageId = pages.keys.first,
                  let pageInfo = pages[pageId] as? [String: Any],
                  let extract = pageInfo["extract"] as? String else {
                completion(.failure(NSError(domain: "WikipediaAPIManagerError", code: -2, userInfo: [NSLocalizedDescriptionKey: "Failed to parse JSON"])))
                return
            }
            
            completion(.success(extract))
        }
        
        task.resume()
    }
}
