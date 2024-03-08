//
//  WikipediaManager.swift
//  
//
//  Created by 山口真 on 2024/03/08.
//
// WikipediaManager.swift
import Foundation
import SwiftSoup

class WikipediaManager {
    func searchKeyword(_ keyword: String, completion: @escaping (Result<String, Error>) -> Void) {
        if let pageHTML = getWikipediaPage(searchWord: keyword),
           let summary = extractSummary(htmlContent: pageHTML) {
            completion(.success(summary))
        } else {
            completion(.failure(NSError(domain: "WikipediaManagerError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch summary for keyword: \(keyword)"])))
        }
    }
    
    private func getWikipediaPage(searchWord: String) -> String? {
        let url = URL(string: "https://ja.wikipedia.org/wiki/\(searchWord)")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, let html = String(data: data, encoding: .utf8) {
                return html
            }
            return nil
        }
        task.resume()
        let result = task.result?.get()
        return result
    }
    
    private func extractSummary(htmlContent: String) -> String? {
        do {
            let doc = try SwiftSoup.parse(htmlContent)
            let summary = try doc.select("#bodyContent").first()?.select("p").first()?.text()
            return summary
        } catch {
            print(error)
            return nil
        }
    }
}
