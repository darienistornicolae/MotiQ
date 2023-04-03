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
    
    func addQuote(quote: String) {
        let newQuote = QuotesEntity(context: container.viewContext)
        newQuote.quotes = quote
        saveData()
    }
    
    func saveData() {
        try? container.viewContext.save()
          fetchQuotes()
    }
    
    func deleteQuote(indexSet: IndexSet) {
        guard let index = indexSet.first else {return}
        let item = savedEntities[index]
        container.viewContext.delete(item)
        saveData()
    }
    
    func modifyQuote(at index: Int, newQuote: String) {
        savedEntities[index].quotes = newQuote
        saveData()
    }

    
}
