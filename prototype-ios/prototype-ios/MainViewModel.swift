//
//  MainViewModel.swift
//  prototype-ios
//
//  Created by 山口真 on 2024/03/06.
//

//import Foundation
//import Combine
//
//class MainViewModel: ObservableObject {
//    @Published var recognizedText: String = ""
//    @Published var isRecording: Bool = false
//    @Published var wikipediaSearchResults: [String: String] = [:]
//    
//    private var cancellables: Set<AnyCancellable> = []
//    private let speechRecognizer = SpeechRecognizer()
//    private let wikipediaManager = WikipediaManager()
//    
//    var isRecognitionAvailable: Bool {
//        speechRecognizer.isRecognitionAvailable
//    }
//    
//    init() {
//        speechRecognizer.onRecognitionResult = { [weak self] text in
//            self?.recognizedText = text
//            self?.performWikipediaSearch(for: text)
//        }
//    }
//    
//    func startRecording() throws {
//        try speechRecognizer.startListening()
//    }
//    
//    func stopRecording() {
//        speechRecognizer.stopListening()
//    }
//    
//    private func performWikipediaSearch(for text: String) {
//        let keywords = TextProcessor.shared.extractKeywords(from: text)
//        
//        keywords.forEach { keyword in
//            wikipediaManager.searchWikipedia(for: keyword)
//                .receive(on: DispatchQueue.main)
//                .sink { [weak self] completion in
//                    if case .failure(let error) = completion {
//                        print("Error: \(error.localizedDescription)")
//                    }
//                } receiveValue: { [weak self] summary in
//                    self?.wikipediaSearchResults[keyword] = summary
//                }
//                .store(in: &cancellables)
//        }
//    }
//}

//import Foundation
//import Combine
//
//class MainViewModel: ObservableObject {
//    @Published var recognizedText: String = "" {
//        didSet {
//            performWikipediaSearch(for: recognizedText)
//        }
//    }
//    @Published var wikipediaSearchResults: [String: String] = [:]
//    
//    private var cancellables: Set<AnyCancellable> = []
//    private let wikipediaManager = WikipediaManager()
//    
//    init() {}
//    
//    private func performWikipediaSearch(for text: String) {
//        let keywords = TextProcessor.shared.extractKeywords(from: text)
//        
//        wikipediaSearchResults = [:] // 既存の検索結果をクリア
//        
//        keywords.forEach { keyword in
//            wikipediaManager.searchWikipedia(for: keyword)
//                .receive(on: DispatchQueue.main)
//                .sink { [weak self] completion in
//                    switch completion {
//                    case .failure(let error):
//                        print("Error: \(error.localizedDescription)")
//                        self?.wikipediaSearchResults[keyword] = "No summary found."
//                    case .finished:
//                        break
//                    }
//                } receiveValue: { [weak self] summary in
//                    self?.wikipediaSearchResults[keyword] = summary.isEmpty ? "No summary found." : summary
//                }
//                .store(in: &cancellables)
//        }
//    }
//}
//import Foundation
//import Combine
//
//class MainViewModel: ObservableObject {
//    @Published var recognizedText: String = "" {
//        didSet {
//            performWikipediaSearch(for: recognizedText)
//        }
//    }
//    @Published var wikipediaSearchResults: [String: String] = [:]
//    @Published var errorMessage: String?
//    
//    private var cancellables: Set<AnyCancellable> = []
//    private let wikipediaManager = WikipediaManager()
//    
//    init() {}
//    
//    private func performWikipediaSearch(for text: String) {
//        let keywords = TextProcessor.shared.extractKeywords(from: text)
//        
//        wikipediaSearchResults = [:] // 既存の検索結果をクリア
//        errorMessage = nil // エラーメッセージをクリア
//        
//        guard !keywords.isEmpty else {
//            errorMessage = "No keywords found in the recognized text."
//            return
//        }
//        
//        keywords.forEach { keyword in
//            wikipediaManager.searchWikipedia(for: keyword)
//                .receive(on: DispatchQueue.main)
//                .sink { [weak self] completion in
//                    if case .failure(let error) = completion {
//                        self?.handleError(error)
//                    }
//                } receiveValue: { [weak self] summary in
//                    self?.wikipediaSearchResults[keyword] = summary.isEmpty ? "No summary found." : summary
//                }
//                .store(in: &cancellables)
//        }
//    }
//    
//    private func handleError(_ error: Error) {
//        if let wikipediaError = error as? WikipediaError {
//            switch wikipediaError {
//            case .invalidURL:
//                errorMessage = "Invalid Wikipedia URL."
//            case .network(let urlError):
//                errorMessage = "Network error: \(urlError.localizedDescription)"
//            case .invalidResponse:
//                errorMessage = "Invalid response from Wikipedia API."
//            case .apiError(let statusCode):
//                errorMessage = "Wikipedia API error: \(statusCode)"
//            case .decoding:
//                errorMessage = "Failed to decode Wikipedia response."
//            case .htmlParsing(let error):
//                errorMessage = "Failed to parse Wikipedia HTML: \(error.localizedDescription)"
//            case .unknown(let error):
//                errorMessage = "Unknown error: \(error.localizedDescription)"
//            }
//        } else {
//            errorMessage = "Unknown error: \(error.localizedDescription)"
//        }
//    }
//}
import Foundation
import Combine

class MainViewModel: ObservableObject {
    @Published var recognizedText: String = "" {
        didSet {
            performExplanationGeneration(for: recognizedText)
        }
    }
    @Published var explanationResults: [String: String] = [:]
    
    private var cancellables: Set<AnyCancellable> = []
    private let gpt4Manager = GPT4Manager()
    
    init() {}
    
    private func performExplanationGeneration(for text: String) {
        do {
            let keywords = try TextProcessor.shared.extractKeywords(from: text)
            
            explanationResults = [:] // 既存の結果をクリア
            
            keywords.forEach { keyword in
                gpt4Manager.generateExplanation(for: keyword)
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] completion in
                        switch completion {
                        case .failure(let error):
                            print("Error: \(error.localizedDescription)")
                            self?.explanationResults[keyword] = "No explanation found."
                        case .finished:
                            break
                        }
                    } receiveValue: { [weak self] explanation in
                        self?.explanationResults[keyword] = explanation
                    }
                    .store(in: &cancellables)
            }
        } catch TextProcessorError.noKeywordsFound {
            explanationResults = [:]
            print("No keywords found in the text.")
        } catch {
            explanationResults = [:]
            print("Error: \(error.localizedDescription)")
        }
    }
}
//import Foundation
//import Combine
//
//class MainViewModel: ObservableObject {
//    @Published var recognizedText: String = "" {
//        didSet {
//            performExplanationGeneration(for: recognizedText)
//        }
//    }
//    @Published var explanationResults: [String: String] = [:]
//    
//    private var cancellables: Set<AnyCancellable> = []
//    private let groqManager = GroqManager()
//    
//    init() {}
//    
//    private func performExplanationGeneration(for text: String) {
//        let keywords = TextProcessor.shared.extractKeywords(from: text)
//        
//        explanationResults = [:] // 既存の結果をクリア
//        
//        keywords.forEach { keyword in
//            groqManager.generateExplanation(for: keyword)
//                .receive(on: DispatchQueue.main)
//                .sink { [weak self] completion in
//                    switch completion {
//                    case .failure(let error):
//                        print("Error: \(error.localizedDescription)")
//                        self?.explanationResults[keyword] = "No explanation found."
//                    case .finished:
//                        break
//                    }
//                } receiveValue: { [weak self] explanation in
//                    self?.explanationResults[keyword] = explanation
//                }
//                .store(in: &cancellables)
//        }
//    }
//}
