//
//  AddUserQuoteViewModel.swift
//  MotiQ
//
//  Created by Darie-Nistor Nicolae on 30.03.2023.
//

import Foundation

class AddUserQuotesViewModel: ObservableObject {
   
    @Published var items: [QuotesModel] = [] {
        didSet {
            saveItems()
        }
    }
    let itemsKey: String = "items_list"
    
    init() {
        getItems()
    }
    
    func getItems() {
        guard
            let data = UserDefaults.standard.data(forKey: itemsKey),
            let savedItems = try? JSONDecoder().decode([QuotesModel].self, from: data)
        else { return }
        
        self.items = savedItems
        
    }
    
    func deleteItem(indexSet: IndexSet) {
        items.remove(atOffsets: indexSet)
    }
    
    func moveItem(from: IndexSet, to: Int) {
        items.move(fromOffsets: from, toOffset: to)
    }
    
    func addItem(q: String) {
        let newItem = QuotesModel(q: q, a: "")
        items.append(newItem)
    }
    
    func updateItem(item: QuotesModel) {
        if let index = items.firstIndex(where: { $0.q == item.q}) {
            items[index] = item.updateCompletition()
        }
    }
    
    func saveItems() {
        if let encodedData = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encodedData, forKey: itemsKey)
        }
    }
}
