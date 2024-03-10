import SwiftUI

struct AddGoalView: View {

  @StateObject private var viewModel = UserGoalCoreDataViewModel()
  @State private var sliderValue: Double = 0.5
  @State private var userGoalTitle: String = ""
  @State private var userGoalDescription: String = ""
  @State private var isPressed: Bool = false
  @Environment(\.presentationMode) private var presentationMode
  @Environment(\.colorScheme) private var colorScheme
  
  init(viewModel: @autoclosure @escaping () -> UserGoalCoreDataViewModel) {
    self._viewModel = StateObject(wrappedValue: viewModel())
  }

  var body: some View {
    addGoal
      .navigationBarTitle("Goals", displayMode: .inline)
  }
}
struct AddGoalView_Previews: PreviewProvider {
  static var previews: some View {
    AddGoalView(viewModel: UserGoalCoreDataViewModel())
  }
}

fileprivate extension AddGoalView {

  var addGoal: some View {
    ScrollView {
      VStack(spacing: 25) {
        Text("Title")
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.horizontal)
          .font(.custom("Avenir Bold", size: 22))

        CustomTextFieldComponent(input: $userGoalTitle, placeholder: "")
          .frame(height: 40)
          .font(.custom("Avenir Bold", size: 26))
          .padding(.horizontal)
          .background(
            RoundedRectangle(cornerRadius: 10)
              .stroke(Color.gray, lineWidth: 2)
              .cornerRadius(10)
          )

        Text("Description")
          .font(.custom("Avenir Bold", size: 22))
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.horizontal)

        CustomTextFieldComponent(input: $userGoalDescription, placeholder: "Enter description")
          .frame(height: 100)
          .font(.custom("Avenir Bold", size: 26))
          .padding(.horizontal)
          .background(
            RoundedRectangle(cornerRadius: 10)
              .stroke(Color.gray, lineWidth: 2)
              .cornerRadius(10)
          )

        Text("Completion")
          .font(.custom("Avenir Bold", size: 26))
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.horizontal)
          .padding(.top)

        ZStack {

          Circle()
            .trim(from: 0, to: CGFloat(sliderValue))
            .stroke(getProgressCircleColor(), style: StrokeStyle(lineWidth: 20, lineCap:
                .round, lineJoin: .round))
            .frame(width: 150, height: 150, alignment: .center)
            .rotationEffect(.degrees(-90))
            .animation(.easeIn)
          
          Text("\(Int(sliderValue * 100))%")
            .font(.title)
            .fontWeight(.bold)
        }
        .padding(.top, 20)

        Slider(value: Binding(get: { sliderValue }, set: { sliderValue = $0 }))
          .padding(.horizontal)

        Spacer()
        Button {
          guard !userGoalDescription.isEmpty else { return }
          viewModel.addUserGoal(goalTitle: userGoalTitle,
                                goalDescription: userGoalDescription,
                                goalProgress: sliderValue)
          presentationMode.wrappedValue.dismiss()
          viewModel.fetchUserGoals()

        } label: {
          Text("Save")
            .foregroundColor(.iconColor)
            .font(.headline)
            .frame(height:55)
            .frame(maxWidth: .infinity)
            .background(Color.buttonColor)
            .cornerRadius(10)
            .alert(isPresented: $isPressed) {
              Alert(title: Text("Goal Saved!").font(.custom("Avenir", size: 24)),
                    message: nil,
                    dismissButton: .default(Text("OK")))
            }
        }
      }
      .padding()
    }
  }

  private func getProgressCircleColor() -> Color {
    let progress = sliderValue
    if progress < 0.05 {
      return colorScheme == .dark ? .black : .white
    } else if progress < 0.5 {
      return colorScheme == .dark ? Color("darkGray"): .gray
    } else if progress < 0.75 {
      return colorScheme == .dark ? .gray : Color(.darkGray)
    } else {
      return colorScheme == .dark ? .white : .black
    }
  }
}
