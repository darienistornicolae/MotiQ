//
//  MotivationalViewModel.swift
//  MotiQ
//
//  Created by Darie-Nistor Nicolae on 20.03.2023.
//

import Foundation
import Combine

class MotivationalViewModel: ObservableObject {
    let apiService = MotivationalAPI(quotes: QuotesModel(q: "", a: ""))
    var cancellables = Set<AnyCancellable>()
    var quotesList: [QuotesModel] = []
    var currentIndex: Int = 0
    
    init() {
        startTimer()
    }
    
     func refreshTimer() {
            currentIndex += 1
            if currentIndex >= apiService.quotes.count {
               return currentIndex = 0
            }
        
    }
    
     func startTimer() {
         Timer
             .publish(every: 1, on: .main, in: .common)
             .autoconnect()
             .sink { [weak self] _ in
                 guard let self = self else {return}
                 self.currentIndex += 1
                 
                 if self.currentIndex >= self.apiService.quotes.count {
                     return self.currentIndex = 0
                 }
             }
             .store(in: &cancellables)
//        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
//            self.currentIndex += 1
//            if self.currentIndex >= self.apiService.quotes.count {
//                return self.currentIndex = 0
//            }
//        }
    }
    
//    func setupQuotesSubscriber() {
//
//        /* TODO: appen the results from the API into an array
//           TODO: The possibilities to do this can differ. You may need a dictionary/Core Data/UserDefaults
//         */
//        apiService.$quotes
//                .sink { [weak self] quotes in
//                    guard let self = self else { return }
//                    self.quotesList.append(contentsOf: quotes)
//                }
//                .store(in: &cancellables)
//    }
}
