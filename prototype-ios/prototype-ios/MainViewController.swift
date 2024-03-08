import UIKit
import Speech
import NaturalLanguage

class MainViewController: UIViewController {
    
    private let speechRecognizer = SpeechRecognizer()
    private let textProcessor = TextProcessor()
    private let wikipediaAPIManager = WikipediaAPIManager()
    
    private var transcribedText = "" {
        didSet {
            processTranscribedText(oldValue)
        }
    }
    
    private var attributedTranscribedText = NSMutableAttributedString()
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.font = .systemFont(ofSize: 16)
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupSpeechRecognizer()
        
        textView.delegate = self
    }
    
    private func setupViews() {
        view.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
    }
    
    private func setupSpeechRecognizer() {
        speechRecognizer.onRecognitionResult = { [weak self] result in
            self?.transcribedText += result
        }
        
        do {
            try speechRecognizer.startListening()
        } catch {
            print("Speech recognition failed to start: \(error)")
        }
    }
    
    private func processTranscribedText(_ oldValue: String) {
        let newText = String(transcribedText.dropFirst(oldValue.count))
        attributedTranscribedText = NSMutableAttributedString(attributedString: attributedTranscribedText)
        
        let keywords = textProcessor.extractKeywords(from: newText)
        keywords.forEach { keyword in
            searchWikipediaFor(keyword)
        }
        
        updateTextView()
    }
    
    private func searchWikipediaFor(_ keyword: String) {
        wikipediaAPIManager.searchKeyword(keyword) { [weak self] result in
            switch result {
            case .success(let extract):
                self?.updateTextViewWithWikipediaLink(for: keyword, extract: extract)
            case .failure(let error):
                print("Wikipedia search failed: \(error)")
            }
        }
    }
    
    private func updateTextViewWithWikipediaLink(for keyword: String, extract: String) {
        DispatchQueue.main.async {
            let range = (self.transcribedText as NSString).range(of: keyword)
            let existingAttributes = self.attributedTranscribedText.attributes(at: range.location, effectiveRange: nil)
            
            if existingAttributes[.link] == nil {
                let attributedString = NSMutableAttributedString(attributedString: self.attributedTranscribedText)
                let url = URL(string: "wikipedia://\(extract)")!
                attributedString.addAttribute(.link, value: url, range: range)
                
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .natural
                
                attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
                
                self.attributedTranscribedText = attributedString
                self.textView.attributedText = self.attributedTranscribedText
            }
        }
    }
    
    private func updateTextView() {
        DispatchQueue.main.async {
            self.textView.attributedText = self.attributedTranscribedText
        }
    }
}

extension MainViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        guard URL.scheme == "wikipedia" else {
            return false
        }
        
        presentWikipediaExtract(URL.host ?? "")
        return false
    }
    
    private func presentWikipediaExtract(_ extract: String) {
        let alertController = UIAlertController(title: nil, message: extract, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
