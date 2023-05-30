//
//  UserCoreDataViewModel.swift
//  MotiQ
//
//  Created by Darie-Nistor Nicolae on 27.05.2023.
//

import Foundation
import CoreData

class UserCoreDataViewModel: ObservableObject {
    
    //MARK: Properties
    let userContainer: NSPersistentContainer
    @Published var userQuotesEntity: [UserQuotesEntity] = []
    
    init() {
        userContainer = NSPersistentContainer(name: "QuotesContainer")
        userContainer.loadPersistentStores { description, error in
            if let error = error {
                print("Problem printing CoreData: \(error.localizedDescription)")
            } else {
                print("Successfully loaded Core Data")
            }
            
        }
        fetchUserQuotes()
    }
    
    func deleteUserQuotes(quote: String, author: String) {
        guard let quoteToDelete = userQuotesEntity.first(where: { $0.quotes == quote && $0.author == author }) else {
            return
        }
        userContainer.viewContext.delete(quoteToDelete)
        saveUserData()
    }
    
    func deleteUserQuote(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let item = userQuotesEntity[index]
        userContainer.viewContext.delete(item)
        saveUserData()
    }
    
    func addUserQuote(quote: String, author: String) {
        let newQuote = UserQuotesEntity(context: userContainer.viewContext)
        newQuote.quotes = quote
        newQuote.author = author
        saveUserData()
    }

    
    func saveUserData() {
        do {
            try userContainer.viewContext.save()
            fetchUserQuotes()
        } catch {
            print("Error saving data: \(error.localizedDescription)")
        }
    }
    
    func fetchUserQuotes() {
        let request = NSFetchRequest<UserQuotesEntity>(entityName: "UserQuotesEntity")
        
        do {
            userQuotesEntity = try userContainer.viewContext.fetch(request)
        } catch let error {
            print("Problems with fetching:\(error.localizedDescription )")
        }
    }
    
    func filteredUserQuotes(searchText: String) -> [UserQuotesEntity] {
            if searchText.isEmpty {
                return userQuotesEntity
            } else {
                return userQuotesEntity.filter { quote in
                    let quoteText = quote.quotes ?? ""
                    let author = quote.author ?? ""
                    return quoteText.localizedCaseInsensitiveContains(searchText) ||
                        author.localizedCaseInsensitiveContains(searchText)
                }
            }
        }
}
