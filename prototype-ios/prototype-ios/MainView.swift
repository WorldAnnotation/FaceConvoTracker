//
//  MainView.swift
//  prototype-ios
//
//  Created by 山口真 on 2024/03/06.
//
// MainView.swift
import SwiftUI
import Combine

struct MainView: View {
    @StateObject private var viewModel = MainViewModel()
    
    var body: some View {
        VStack {
            if viewModel.isRecognitionAvailable {
                TextEditor(text: $viewModel.recognizedText)
                    .overlay(
                        viewModel.keywords.isEmpty ? nil : KeywordOverlay(keywords: viewModel.keywords)
                    )
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

struct KeywordOverlay: View {
    let keywords: [String]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                ForEach(keywords, id: \.self) { keyword in
                    KeywordLink(keyword: keyword, size: geometry.size)
                }
            }
        }
    }
}

struct KeywordLink: View {
    let keyword: String
    let size: CGSize
    
    @StateObject private var viewModel = KeywordLinkViewModel()
    
    var body: some View {
        ZStack {
            if let summary = viewModel.summary {
                Text(summary)
                    .padding()
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(10)
                    .onTapGesture {
                        viewModel.summary = nil
                    }
            }
        }
        .onAppear {
            viewModel.fetchSummary(for: keyword)
        }
        .frame(width: size.width, height: size.height)
    }
}
