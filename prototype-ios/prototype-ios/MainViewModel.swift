//
//  MainViewModel.swift
//  prototype-ios
//
//  Created by 山口真 on 2024/03/06.
//

import Foundation
import Combine

class MainViewModel: ObservableObject {
    @Published var recognizedText: String = ""
    @Published var isRecording: Bool = false
    @Published var wikipediaSearchResults: [String: String] = [:]
    
    private var cancellables: Set<AnyCancellable> = []
    private let speechRecognizer = SpeechRecognizer()
    private let wikipediaManager = WikipediaManager()
    
    var isRecognitionAvailable: Bool {
        speechRecognizer.isRecognitionAvailable
    }
    
    init() {
        speechRecognizer.onRecognitionResult = { [weak self] text in
            self?.recognizedText = text
            self?.performWikipediaSearch(for: text)
        }
    }
    
    func startRecording() throws {
        try speechRecognizer.startListening()
    }
    
    func stopRecording() {
        speechRecognizer.stopListening()
    }
    
    private func performWikipediaSearch(for text: String) {
        let keywords = TextProcessor.shared.extractKeywords(from: text)
        
        // 既存の検索結果をクリア
        wikipediaSearchResults = [:]
        
        keywords.forEach { keyword in
            wikipediaManager.searchWikipedia(for: keyword)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] completion in
                    if case .failure(let error) = completion {
                        print("Error: \(error.localizedDescription)")
                        // エラー時は空の結果を設定
                        self?.wikipediaSearchResults[keyword] = "No summary found."
                    }
                } receiveValue: { [weak self] summary in
                    // 検索結果が空の場合は、適切なメッセージを設定
                    let result = summary.isEmpty ? "No summary found." : summary
                    self?.wikipediaSearchResults[keyword] = result
                }
                .store(in: &cancellables)
        }
    }
}
