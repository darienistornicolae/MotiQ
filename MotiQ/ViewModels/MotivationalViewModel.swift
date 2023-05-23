//
//  MotivationalViewModel.swift
//  MotiQ
//
//  Created by Darie-Nistor Nicolae on 20.03.2023.
//

import Foundation
import Combine


class MotivationalViewModel: ObservableObject {
    // MARK: Properties
    let apiService = MotivationalAPI(quotes: QuotesModel(q: "", a: ""))
    let coreData = CoreDataViewModel()
    var cancellables = Set<AnyCancellable>()
    @Published var q: String = ""
    @Published var a: String = ""
    var index: Int = 0
    
    init() {
        getData()
    }
    
    func getData() {
        apiService.$quotes
            .map { quote in
                let stringQuote = quote.first?.q ?? "Unkwon"
                return stringQuote
            }
            .sink { [weak self] newString in
                self?.q = newString
            }
            .store(in: &cancellables)
        
        apiService.$quotes
            .map { author in
                let stringAuthor = author.first?.a ?? "Unknown"
                return stringAuthor
            }
            .sink { [weak self] newString in
                self?.a = newString
            }
            .store(in: &cancellables)
        //startTimer()
    }
    
    func startTimer() {
        Timer.publish(every: 15, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                let endIndex = min(index + 1, self.apiService.quotes.count)
                let slice = Array(self.apiService.quotes[index..<endIndex])
                if let quote = slice.first?.q {
                    self.q = quote
                }
                if let author = slice.first?.a {
                    self.a = author
                }
                index = (index + 1) % self.apiService.quotes.count
            }
            .store(in: &cancellables)
    }
    
    func nextQuote() {
        let isLastQuote = index == apiService.quotes.count - 1
        if isLastQuote {
            apiService.getQuotes()
        }
        
        let quoteIndex = isLastQuote ? 0 : index + 1
        let quote = apiService.quotes[quoteIndex]
        q = quote.q
        a = quote.a
        
        index = quoteIndex
    }
    
    func previousQuote() {
        let isFirstQuote = index == 0
        let quoteIndex = isFirstQuote ? apiService.quotes.count - 1 : index - 1
        let quote = apiService.quotes[quoteIndex]
        q = quote.q
        a = quote.a
        
        index = quoteIndex
    }

    
    func saveQuote() {
        coreData.addQuote(quote: q, author: a)
    }
    
    
}
