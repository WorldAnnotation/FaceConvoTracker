//
//  MainView.swift
//  
//
//  Created by 山口真 on 2024/03/08.
//

import Foundation
import SwiftUI
import Combine
import SwiftSoup

struct MainView: View {
    @StateObject private var viewModel = MainViewModel()
    
    var body: some View {
        VStack {
            if viewModel.isRecognitionAvailable {
                TextEditor(text: $viewModel.recognizedText)
                    .padding()
                
                Divider()
                
                Toggle("Recording", isOn: $viewModel.isRecording)
                    .padding()
                    .onChange(of: viewModel.isRecording) { isRecording in
                        if isRecording {
                            try? viewModel.startRecording()
                        } else {
                            viewModel.stopRecording()
                        }
                    }
            } else {
                Text("Speech recognition is not available on this device.")
            }
        }
    }
}

class MainViewModel: ObservableObject {
    private let speechRecognizer = SpeechRecognizer()
    private let textProcessor = TextProcessor.shared
    private let wikipediaManager = WikipediaManager()
    private var cancellables = Set<AnyCancellable>()
    
    @Published var isRecording = false
    @Published var recognizedText = ""
    
    var isRecognitionAvailable: Bool {
        speechRecognizer.isRecognitionAvailable
    }
    
    init() {
        speechRecognizer.onRecognitionResult = { [weak self] result in
            DispatchQueue.main.async {
                self?.recognizedText += result
                self?.processRecognizedText()
            }
        }
    }
    
    func startRecording() throws {
        try speechRecognizer.startListening()
    }
    
    func stopRecording() {
        speechRecognizer.stopListening()
    }
    
    private func processRecognizedText() {
        let keywords = textProcessor.extractKeywords(from: recognizedText)
        for keyword in keywords {
            fetchWikipediaSummary(for: keyword)
        }
    }
    
    private func fetchWikipediaSummary(for keyword: String) {
        wikipediaManager.searchKeyword(keyword) { [weak self] result in
            switch result {
            case .success(let summary):
                print("\(keyword):")
                print(summary)
            case .failure(let error):
                print("Error fetching summary: \(error)")
            }
        }
    }
}
