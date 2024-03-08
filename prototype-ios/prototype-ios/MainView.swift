//
//  MainView.swift
//  prototype-ios
//
//  Created by 山口真 on 2024/03/06.
//
// MainView.swift
//

//
//
//  Created by 山口真 on 2024/03/08.
//
//  MainView.swift
import SwiftUI
import Combine

struct MainView: View {
    @StateObject private var viewModel = MainViewModel()
    
    var body: some View {
        VStack {
            // トグルボタン
            Toggle("Recording", isOn: $viewModel.isRecording)
                .padding()
                .onChange(of: viewModel.isRecording) { isRecording in
                    if isRecording {
                        try? viewModel.startRecording()
                    } else {
                        viewModel.stopRecording()
                    }
                }
            
            // 書き起こしテキスト
            if viewModel.isRecognitionAvailable {
                TextEditor(text: $viewModel.recognizedText)
                    .padding()
                    .frame(minHeight: 100) // テキストエリアの最小高さを指定
            } else {
                Text("Speech recognition is not available on this device.")
                    .padding()
            }
            
            Divider()
            
            // Wikipedia検索結果の表示
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(viewModel.wikipediaSearchResults.keys.sorted(), id: \.self) { key in
                        if let summary = viewModel.wikipediaSearchResults[key] {
                            Text("\(key): \(summary)")
                                .padding()
                        }
                    }
                }
            }
        }
    }
}



