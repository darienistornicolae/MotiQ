//
//  MotivationalAPI.swift
//  MotiQ
//
//  Created by Darie-Nistor Nicolae on 20.03.2023.
//

import Foundation
import Combine

class MotivationalAPI {
    
    @Published var quotes: [QuotesModel]
    var cancellables = Set<AnyCancellable>()
    
    init(cancellables: Set<AnyCancellable> = Set<AnyCancellable>(), quotes: QuotesModel) {
        self.quotes = [quotes]
        self.cancellables = cancellables
    }
    
    
    func getQuotes() {
        let url: String = "https://zenquotes.io/api/quotes/"
        
        guard let url = URL(string: url) else { return }
        URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .tryMap(handleOutput)
            .decode(type: [QuotesModel].self, decoder: JSONDecoder())
            .sink { completion in
                switch completion {
                case .finished:
                    print("Succesfull connection")
                    print(completion)
                    
                case .failure(let error):
                    print("\(error)")
                }
            } receiveValue: { [weak self] returnedQuotes in
                self?.quotes = returnedQuotes
            }
            .store(in: &cancellables)
    }
    
    
    func handleOutput(output: URLSession.DataTaskPublisher.Output) throws -> Data {
        guard
            let response = output.response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300 else {
            throw URLError(.badServerResponse)
        }
        
        return output.data
        
    }
    
}
