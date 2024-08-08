import SwiftUI

struct LogInView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var navigateToMap_View = false
    @State private var showingRegistrationAlert = false

    var body: some View {
        NavigationView {
            VStack {
                Spacer()

                Text("Welcome to Park-Smart")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()

                TextField("Username", text: $username)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                    .padding(.horizontal)

                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                    .padding(.horizontal)

                Button("Log In") {
                    self.navigateToMap_View = true
                }
                .buttonStyle(PrimaryButtonStyle())

                Button("Register") {
                    self.showingRegistrationAlert = true
                }
                .buttonStyle(SecondaryButtonStyle())

                Spacer()

                NavigationLink(
                    destination: ContentView(),
                    isActive: $navigateToMap_View,
                    label: { EmptyView() }
                ).hidden()
            }
            .padding()
            .alert(isPresented: $showingRegistrationAlert) {
                Alert(title: Text("Registration Unavailable"), message: Text("This feature is not yet active."), dismissButton: .default(Text("OK")))
            }
        }
    }
}

// Primary button style
struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

// Secondary button style
struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.gray)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
