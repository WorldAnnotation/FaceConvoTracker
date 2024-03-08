//
//  ContentView.swift
//  prototype-ios
//
//  Created by 山口真 on 2024/03/06.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = MainViewModel()
    
    var body: some View {
        VStack {
            TextEditor(text: $viewModel.transcribedText)
                .font(.body)
                .padding()
            
            Button(action: {
                viewModel.toggleRecording()
            }) {
                Text(viewModel.isRecording ? "停止" : "録音開始")
                    .foregroundColor(.white)
                    .padding()
                    .background(viewModel.isRecording ? Color.red : Color.green)
                    .cornerRadius(8)
            }
        }
    }
}
