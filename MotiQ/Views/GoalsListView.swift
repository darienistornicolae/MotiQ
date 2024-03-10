import SwiftUI

struct GoalsListView: View {

  @StateObject private var viewModel = UserGoalCoreDataViewModel()
  @State private var searchText: String = ""

  init(viewModel: @autoclosure @escaping () -> UserGoalCoreDataViewModel) {
    self._viewModel = StateObject(wrappedValue: viewModel())
  }

  var body: some View {
    NavigationView {
      VStack {
        searchBar
        userGoal
          .onAppear(perform: viewModel.fetchUserGoals )
        Spacer()
      }
      .navigationTitle("Goals")
      .navigationBarTitleDisplayMode(.inline)
      .navigationBarItems(trailing: NavigationLink(destination: {
        AddGoalView(viewModel: UserGoalCoreDataViewModel())
      }, label: {
        Image(systemName: "plus")
          .foregroundColor(.buttonColor)
      }))
    }
  }
}

struct GoalSettingView_Previews: PreviewProvider {
  static var previews: some View {
    GoalsListView(viewModel: UserGoalCoreDataViewModel())
  }
}

fileprivate extension GoalsListView {
  var searchBar: some View {
    HStack {
      Image(systemName: "magnifyingglass").foregroundColor(.gray)
      TextField("Search goal...", text: $searchText)
    }
    .frame(maxWidth: 330)
    .padding(10)
    .background(Color(.systemGray5))
    .cornerRadius(20)
  }

  var userGoal: some View {
    List {
      ForEach(viewModel.filteredUserQuotes(searchText: searchText), id: \.self) { item in
        NavigationLink(
          destination: EditGoalView(goal: item,
                                    viewModel: UserGoalCoreDataViewModel()).environmentObject(viewModel),
          label: {
            GoalCardView(userGoalTitle: item.goalTitle ?? "",
                         userGoaldescription: item.goalDescription ?? "",
                         userGoalProgress: item.goalProgress, userGoal: UserGoalEntity()) {}
          }
        )
        .font(.custom("Avenir", size: 20))
      }
      .onDelete(perform: viewModel.deleteUserGoal)
    }
  }
  func navigateToEditGoal(userGoal: UserGoalEntity) {
    viewModel.selectedUserGoal = userGoal
    viewModel.isEditingGoal = true
  }
}
