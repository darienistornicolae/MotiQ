//
//  CoreDataViewModel.swift
//  MotiQ
//
//  Created by Darie-Nistor Nicolae on 21.03.2023.
//

import Foundation
import CoreData

class CoreDataViewModel: ObservableObject {
    
    //MARK: Properties
    let container: NSPersistentContainer
    @Published var savedEntities: [QuotesEntity] = []
    
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
        newQuote.quotes = quote
        newQuote.author = author
        saveData()
    }
    
    func saveData() {
        do {
            try container.viewContext.save()
            fetchQuotes()
        } catch {
            print("Error saving data: \(error.localizedDescription)")
        }
    }

    func deleteQuotes(quote: String, author: String) {
        guard let quoteToDelete = savedEntities.first(where: { $0.quotes == quote && $0.author == author }) else {
            return
        }
        container.viewContext.delete(quoteToDelete)
        saveData()
    }
    
    func deleteQuote(indexSet: IndexSet) {
        guard let index = indexSet.first else {return}
        let item = savedEntities[index]
        container.viewContext.delete(item)
        saveData()
    }
    
    func filteredUserQuotes(searchText: String) -> [QuotesEntity] {
            if searchText.isEmpty {
                return savedEntities
            } else {
                return savedEntities.filter { quote in
                    let quoteText = quote.quotes ?? ""
                    let author = quote.author ?? ""
                    return quoteText.localizedCaseInsensitiveContains(searchText) ||
                        author.localizedCaseInsensitiveContains(searchText)
                }
            }
        }
}


