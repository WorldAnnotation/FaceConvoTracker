//
//
//  prototype-ios
//
//  Created by 山口真 on 2024/03/06.
// TextProcessor.swift
//import Foundation
//import NaturalLanguage
//
//class TextProcessor {
//    
//    static let shared = TextProcessor()
//    
//    private init() {} // シングルトンのためのプライベートイニシャライザ
//    
//    /// テキストから六文字以上の名詞を抽出する
//    /// - Parameter text: 抽出元のテキスト
//    /// - Returns: 条件にマッチする名詞の配列
//    /// - Throws: TextProcessorError
//    func extractKeywords(from text: String) throws -> [String] {
//        print("解析前の文章: \(text)")
//        let wordTokenizer = NLTokenizer(unit: .word)
//        var keywords: [String] = []
//        let tagger = NLTagger(tagSchemes: [.lexicalClass])
//        tagger.string = text
//        let options: NLTagger.Options = [.omitWhitespace, .joinNames]
//        
//        tagger.enumerateTags(in: text.startIndex..<text.endIndex, unit: .word, scheme: .lexicalClass, options: options) { tag, tokenRange in
//            // 名詞であり、かつ6文字以上であるかどうかを判断
//            if tag == .noun {
//                let word = String(text[tokenRange]).trimmingCharacters(in: .whitespacesAndNewlines)
//                if word.count >= 2 {
//                    keywords.append(word)
//                }
//            }
//            return true
//        }
//        
//        // 配列が空の場合はエラーをスロー
//        if keywords.isEmpty {
//            throw TextProcessorError.noKeywordsFound
//        }
//        
//        return keywords
//    }
//}
//
//enum TextProcessorError: Error {
//    case noKeywordsFound
//}
//import Foundation
//
//class TextProcessor {
//    
//    static let shared = TextProcessor()
//    
//    private init() {} // シングルトンのためのプライベートイニシャライザ
//    
//    /// テキストから六文字以上の名詞を抽出する
//    /// - Parameter text: 抽出元のテキスト
//    /// - Returns: 条件にマッチする名詞の配列
//    /// - Throws: TextProcessorError
//    func extractKeywords(from text: String) throws -> [String] {
//        print("解析前の文章: \(text)")
//        let tokenizer = Tokenizer()
//        var keywords: [String] = []
//        let tokens = tokenizer.parse(text)
//        let options: NLTagger.Options = [.omitWhitespace, .joinNames]
//        
//        tagger.enumerateTags(in: text.startIndex..<text.endIndex, unit: .word, scheme: .lexicalClass, options: options) { tag, tokenRange in
//            // 名詞であり、かつ6文字以上であるかどうかを判断
//            if tag == .noun {
//                let word = String(text[tokenRange]).trimmingCharacters(in: .whitespacesAndNewlines)
//                if word.count >= 2 {
//                    keywords.append(word)
//                }
//            }
//            return true
//        }
//        
//        // 配列が空の場合はエラーをスロー
//        if keywords.isEmpty {
//            throw TextProcessorError.noKeywordsFound
//        }
//        
//        return keywords
//    }
//}
//
//enum TextProcessorError: Error {
//    case noKeywordsFound
//}
//import Foundation
//
//class TextProcessor {
//    
//    static let shared = TextProcessor()
//    
//    private var tokenizer: Tokenizer?
//    
//    private init() {
//        // Tokenizerのインスタンスを初期化
//        tokenizer = Tokenizer()
//    }
//    
//    /// テキストから三文字以上のトークンを抽出する
//    /// - Parameter text: 抽出元のテキスト
//    /// - Returns: 条件にマッチするトークンの配列
//    /// - Throws: TextProcessorError
//    func extractKeywords(from text: String) throws -> [String] {
//        print("解析前の文章: \(text)")
//        var keywords: [String] = []
//        
//        // Tokenizerを使用してテキストを解析
//        guard let tokenizer = tokenizer else {
//            throw TextProcessorError.tokenizerNotInitialized
//        }
//        let tokens = tokenizer.parse(text)
//        
//        // 解析結果からトークンを抽出
//        for token in tokens {
//            let word = token.surface
//            if word.count >= 5 {
//                keywords.append(word)
//            }
//        }
//        
//        // 配列が空の場合はエラーをスロー
//        if keywords.isEmpty {
//            throw TextProcessorError.noKeywordsFound
//        }
//        
//        return keywords
//    }
//}
//
//enum TextProcessorError: Error {
//    case noKeywordsFound
//    case tokenizerNotInitialized
//}
import Foundation
import NaturalLanguage

class TextProcessor {
    
    static let shared = TextProcessor()
    
    private init() {} // シングルトンのためのプライベートイニシャライザ
    
    /// テキストから指定された文字数以上のトークンを抽出する
    /// - Parameter text: 抽出元のテキスト
    /// - Returns: 条件にマッチするトークンの配列
    /// - Throws: TextProcessorError
    func extractKeywords(from text: String) throws -> [String] {
        print("解析前の文章: \(text)")
        let wordTokenizer = NLTokenizer(unit: .word)
        wordTokenizer.string = text
        
        var keywords: [String] = []
        let tokens = wordTokenizer.tokens(for: text.startIndex ..< text.endIndex)
        
        for token in tokens {
            let tokenStartIndex = token.lowerBound
            let tokenEndIndex = token.upperBound
            let tokenText = String(text[tokenStartIndex ..< tokenEndIndex])
            
            if tokenText.count >= 5 {
                keywords.append(tokenText)
            }
        }
        
        // 配列が空の場合はエラーをスロー
        if keywords.isEmpty {
            throw TextProcessorError.noKeywordsFound
        }
        
        return keywords
    }
}

enum TextProcessorError: Error {
    case noKeywordsFound
}
