import SwiftUI

struct UserAddedQuotesListView: View {
  
  @StateObject var viewModel = UserCoreDataViewModel()
  @State private var searchText = ""
  
  init(viewModel: @autoclosure @escaping () -> UserCoreDataViewModel) {
    self._viewModel = StateObject(wrappedValue: viewModel())
  }
  
  var body: some View {
    searchBar
    userQuotes
      .onAppear(perform: viewModel.fetchUserQuotes)
  }
}

struct UserAddedQuotes_Previews: PreviewProvider {
  static var previews: some View {
    UserAddedQuotesListView(viewModel: UserCoreDataViewModel())
  }
}

fileprivate extension UserAddedQuotesListView {
  
  var searchBar: some View {
    HStack {
      Image(systemName: "magnifyingglass").foregroundColor(.gray)
      TextField("Search quote or author...", text: $searchText)
    }
    .frame(maxWidth: 350)
    .padding(10)
    .background(Color(.systemGray5))
    .cornerRadius(20)
  }
  
  var userQuotes: some View {
    List {
      ForEach(viewModel.filteredUserQuotes(searchText: searchText), id: \.self) { item in
        QuoteCardView(quote: item.quotes ?? "No Quote", author: item.author ?? "Your Quote")
          .font(.custom("Avenir", size: 20))
      }
      .onDelete(perform: viewModel.deleteUserQuote)
      
    }
    .navigationTitle("Quotes")
  }

  
}
