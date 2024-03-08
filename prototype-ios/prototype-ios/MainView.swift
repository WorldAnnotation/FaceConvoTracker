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
//import SwiftUI
//import Combine
//
//struct MainView: View {
//    @StateObject private var viewModel = MainViewModel()
//    
//    var body: some View {
//        VStack {
//            // トグルボタン
//            Toggle("Recording", isOn: $viewModel.isRecording)
//                .padding()
//                .onChange(of: viewModel.isRecording) { isRecording in
//                    if isRecording {
//                        try? viewModel.startRecording()
//                    } else {
//                        viewModel.stopRecording()
//                    }
//                }
//            
//            // 書き起こしテキスト
//            if viewModel.isRecognitionAvailable {
//                TextEditor(text: $viewModel.recognizedText)
//                    .padding()
//                    .frame(minHeight: 100) // テキストエリアの最小高さを指定
//            } else {
//                Text("Speech recognition is not available on this device.")
//                    .padding()
//            }
//            
//            Divider()
//            
//            // Wikipedia検索結果の表示
//            ScrollView {
//                VStack(alignment: .leading) {
//                    ForEach(viewModel.wikipediaSearchResults.keys.sorted(), id: \.self) { key in
//                        if let summary = viewModel.wikipediaSearchResults[key] {
//                            Text("\(key): \(summary)")
//                                .padding()
//                        }
//                    }
//                }
//            }
//        }
//    }
//}

//import SwiftUI
//import Combine
//
//struct MainView: View {
//    @StateObject private var viewModel = MainViewModel()
//    
//    var body: some View {
//        VStack {
//            // ユーザー入力テキスト
//            TextEditor(text: $viewModel.recognizedText)
//                .padding()
//                .frame(minHeight: 100) // テキストエリアの最小高さを指定
//                .border(Color.gray, width: 1) // ボーダーを追加して視覚的に区別
//                .onChange(of: viewModel.recognizedText) { newText in
//                    // テキストが変更されるたびにWikipedia検索をトリガー
//                    // ViewModel内でrecognizedTextの変更を監視し、検索が実行されるため、ここでは特にアクションは不要
//                }
//            
//            Divider()
//            
//            // Wikipedia検索結果の表示
//            ScrollView {
//                VStack(alignment: .leading) {
//                    ForEach(viewModel.wikipediaSearchResults.keys.sorted(), id: \.self) { key in
//                        if let summary = viewModel.wikipediaSearchResults[key] {
//                            Text("\(key): \(summary)")
//                                .padding()
//                        }
//                    }
//                }
//            }
//        }
//    }
//}

import SwiftUI
import Combine

struct MainView: View {
    @StateObject private var viewModel = MainViewModel()
    
    var body: some View {
        VStack {
            // ユーザー入力テキスト
            TextEditor(text: $viewModel.recognizedText)
                .padding()
                .frame(minHeight: 50) // テキストエリアの最小高さを指定
                .border(Color.gray, width: 1) // ボーダーを追加して視覚的に区別
                .onChange(of: viewModel.recognizedText) { newText in
                    // テキストが変更されるたびに単語の説明生成をトリガー
                    // ViewModel内でrecognizedTextの変更を監視し、説明生成が実行されるため、ここでは特にアクションは不要
                }
            
            Divider()
            
            // 単語の説明結果の表示
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(viewModel.explanationResults.keys.sorted(), id: \.self) { key in
                        if let explanation = viewModel.explanationResults[key] {
                            Text("\(key): \(explanation)")
                                .padding()
                        }
                    }
                }
            }
        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}
//import SwiftUI
//import Combine
//
//struct MainView: View {
//    @StateObject private var viewModel = MainViewModel()
//    
//    var body: some View {
//        VStack {
//            // ユーザー入力テキスト
//            TextEditor(text: $viewModel.recognizedText)
//                .padding()
//                .frame(minHeight: 100) // テキストエリアの最小高さを指定
//                .border(Color.gray, width: 1) // ボーダーを追加して視覚的に区別
//                .onChange(of: viewModel.recognizedText) { newText in
//                    // テキストが変更されるたびに単語の説明生成をトリガー
//                    // ViewModel内でrecognizedTextの変更を監視し、説明生成が実行されるため、ここでは特にアクションは不要
//                }
//            
//            Divider()
//            
//            // 単語の説明結果の表示
//            ScrollView {
//                VStack(alignment: .leading) {
//                    ForEach(viewModel.explanationResults.keys.sorted(), id: \.self) { key in
//                        if let explanation = viewModel.explanationResults[key] {
//                            Text("\(key): \(explanation)")
//                                .padding()
//                        }
//                    }
//                }
//            }
//        }
//    }
//}
