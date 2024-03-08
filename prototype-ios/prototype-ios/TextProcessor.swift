//
//  TextProcessor.swift
//  prototype-ios
//
//  Created by 山口真 on 2024/03/06.
//
import Foundation
import NaturalLanguage

class TextProcessor {
    
    static let shared = TextProcessor()
    
    private init() {} // シングルトンのためのプライベートイニシャライザ
    
    /// テキストから六文字以上の名詞を抽出する
    /// - Parameter text: 抽出元のテキスト
    /// - Returns: 条件にマッチする名詞の配列
    func extractKeywords(from text: String) -> [String] {
        var keywords: [String] = []
        let tagger = NLTagger(tagSchemes: [.lexicalClass])
        tagger.string = text
        let options: NLTagger.Options = [.omitWhitespace, .joinNames]
        
        tagger.enumerateTags(in: text.startIndex..<text.endIndex, unit: .word, scheme: .lexicalClass, options: options) { tag, tokenRange in
            // 名詞であり、かつ6文字以上であるかどうかを判断
            if tag == .noun {
                let word = String(text[tokenRange]).trimmingCharacters(in: .whitespacesAndNewlines)
                if word.count >= 6 {
                    keywords.append(word)
                }
            }
            return true
        }
        
        return keywords
    }
}
