//
//  CoreDataViewModel.swift
//  MotiQ
//
//  Created by Darie-Nistor Nicolae on 21.03.2023.
//

import Foundation
import CoreData

class CoreDataViewModel: ObservableObject {
    let container: NSPersistentContainer
    @Published var savedEntities: [QuotesEntity] = []
    let service = MotivationalAPI(quotes: QuotesModel(q: "", a: ""))
    
    
    init() {
        container = NSPersistentContainer(name: "QuotesContainer")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Problem printing CoreData: \(error.localizedDescription)")
            } else {
                print("Successfully loaded Core Data")
            }
            
        }
        fetchQuotes()
    }
    
    func fetchQuotes() {
        let request = NSFetchRequest<QuotesEntity>(entityName: "QuotesEntity")
        
        do {
          savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Problems with fetching:\(error.localizedDescription )")
        }
    }
    
    func addQuote(quote: String, author: String) {
        let newQuote = QuotesEntity(context: container.viewContext)
        let newAuthor = QuotesEntity(context: container.viewContext)
        newQuote.quotes = quote
        newAuthor.author = author
        saveData()
    }
    
    func saveData() {
        do {
            try container.viewContext.save()
            fetchQuotes()
        } catch let error {
            print("Problem with saving the data: \(error.localizedDescription)")
        }
    }
}
