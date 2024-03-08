//
//  MainViewModel.swift
//  prototype-ios
//
//  Created by 山口真 on 2024/03/06.
//

import Foundation
import Combine

class MainViewModel: ObservableObject {
    private let speechRecognizer = SpeechRecognizer()
    private let textProcessor = TextProcessor.shared
    private var cancellables = Set<AnyCancellable>()
    
    @Published var isRecording = false
    @Published var recognizedText = "" {
        didSet {
            updateKeywords()
        }
    }
    @Published var keywords = [String]()
    
    var isRecognitionAvailable: Bool {
        speechRecognizer.isRecognitionAvailable
    }
    
    private var previousResult = ""
    
    init() {
        speechRecognizer.onRecognitionResult = { [weak self] result in
            DispatchQueue.main.async {
                // 前回の結果と重複していない部分のみ追加
                let newText = String(result.dropFirst(self?.previousResult.count ?? 0))
                self?.recognizedText += newText
                self?.previousResult = result
            }
        }
    }
    
    func startRecording() throws {
        try speechRecognizer.startListening()
    }
    
    func stopRecording() {
        speechRecognizer.stopListening()
        previousResult = ""
    }
    
    private func updateKeywords() {
        keywords = textProcessor.extractKeywords(from: recognizedText)
    }
}
