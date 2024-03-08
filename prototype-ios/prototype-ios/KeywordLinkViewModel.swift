//
//  KeywordLinkViewModel.swift
//  prototype-ios
//
//  Created by 山口真 on 2024/03/06.
//
import Foundation
import Combine

class KeywordLinkViewModel: ObservableObject {
    @Published var summary: String?
    private var cancellables = Set<AnyCancellable>()
    private let wikipediaAPIManager = WikipediaAPIManager()
    
    func fetchSummary(for keyword: String) {
        wikipediaAPIManager.searchKeyword(keyword) { result in
            switch result {
            case .success(let summary):
                DispatchQueue.main.async {
                    self.summary = summary
                }
            case .failure(let error):
                print("Error fetching summary: \(error)")
            }
        }
    }
}
