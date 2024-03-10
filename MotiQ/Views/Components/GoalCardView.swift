import SwiftUI

struct GoalCardView: View {

  let userGoalTitle: String
  let userGoaldescription: String
  let userGoalProgress: Double
  let userGoal: UserGoalEntity
  let editAction: () -> Void

  @AppStorage("isDarkMode") private var isDarkMode: Bool = false

  var body: some View {
    VStack(alignment: .leading) {
      Text("Title: \(userGoalTitle)")
      Text("Description: \(userGoaldescription)")
      Text("Progress: \(String(format: "%.0f", userGoalProgress * 100))%")
    }
    .frame(width: 300, height: 80, alignment: .leading)
    .padding(.leading, 20)
    .preferredColorScheme(isDarkMode ? .dark : .light)
    .cornerRadius(10)
    .contextMenu {
      Button(action: {
        editAction()
      }) {
        Label("Edit", systemImage: "pencil")
      }
    }
  }
}
