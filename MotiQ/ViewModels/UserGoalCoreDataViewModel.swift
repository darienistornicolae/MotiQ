//
//  UserGoalCoreDataViewModel.swift
//  MotiQ
//
//  Created by Darie-Nistor Nicolae on 03.07.2023.
//

import Foundation
import CoreData

class UserGoalCoreDataViewModel: ObservableObject {
    
    //MARK: Properties
    let userGoalContainer: NSPersistentContainer
    @Published var userGoalEntity: [UserGoalEntity] = []
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var selectedUserGoal: UserGoalEntity?
    @Published var isEditingGoal: Bool = false

    init() {
        userGoalContainer = NSPersistentContainer(name: "GoalContainer")
        userGoalContainer.loadPersistentStores { description, error in
            if let error = error {
                print("Problem printing CoreData: \(error.localizedDescription)")
            } else {
                print("Successfully loaded User Goals Core Data")
            }
            
        }
        fetchUserGoals()
    }
    
    func deleteUserGoal(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let item = userGoalEntity[index]
        userGoalContainer.viewContext.delete(item)
        saveUserData()
    }
    
    func updateUserGoal(goal: UserGoalEntity, newTitle: String, newDescription: String, newProgress: Double) {
            goal.goalTitle = newTitle
            goal.goalDescription = newDescription
            goal.goalProgress = newProgress
            saveUserData()
        }
    
    func addUserGoal(goalTitle: String, goalDescription: String, goalProgress: Double) {
        let newGoal = UserGoalEntity(context: userGoalContainer.viewContext)
        newGoal.goalTitle = goalTitle
        newGoal.goalDescription = goalDescription
        newGoal.goalProgress = goalProgress
        saveUserData()
    }

    func saveUserData() {
        do {
            try userGoalContainer.viewContext.save()
            fetchUserGoals()
        } catch {
            print("Error saving data: \(error.localizedDescription)")
        }
    }
    
    func fetchUserGoals() {
        let request = NSFetchRequest<UserGoalEntity>(entityName: "UserGoalEntity")
        
        do {
            userGoalEntity = try userGoalContainer.viewContext.fetch(request)
        } catch let error {
            print("Problems with fetching:\(error.localizedDescription )")
        }
    }



    
    func filteredUserQuotes(searchText: String) -> [UserGoalEntity] {
        if searchText.isEmpty {
            return userGoalEntity
        } else {
            return userGoalEntity.filter { goal in
                let goalTitle = goal.goalTitle ?? ""
                let goalDescription = goal.goalDescription ?? ""
                return goalDescription.localizedCaseInsensitiveContains(searchText) ||
                goalTitle.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
}
