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
        apiService.getQuotes()
        refreshData()
    }
    
    func refreshData() {
        DispatchQueue.global(qos: .background).async {
            Timer.publish(every: 150, on: .main, in: .common)
                .autoconnect()
                .sink { [weak self] _ in
                    self?.apiService.getQuotes()
                }
                .store(in: &self.cancellables)
        }
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
        startTimer()
    }
    
    func startTimer() {
        Timer.publish(every: 5, on: .main, in: .common)
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
        index = (index + 1) % apiService.quotes.count
        let slice = Array(apiService.quotes[index..<min(index + 1, apiService.quotes.count)])
        if let quote = slice.first?.q {
            q = quote
        }
        if let author = slice.first?.a {
            a = author
        }
    }
    
    func saveQuote() {
        coreData.addQuote(quote: q, author: a)
    }
    
    
}
