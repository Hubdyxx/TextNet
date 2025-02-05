import SwiftUI

struct LoginView: View {
    
    @StateObject var viewModel = LoginViewModel()
    
    var body: some View {
        NavigationStack{
            VStack {
                
                Image("textnet-logo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 200)
                    .cornerRadius(20)
                    .padding(.vertical,70)
                
                VStack {
                    
                    TextField("Enter your email", text: $viewModel.email)
                        .autocapitalization(.none)
                        .modifier(TextFieldModifier())
                    SecureField("Enter your password", text: $viewModel.password)
                        .modifier(TextFieldModifier())

                }
                
                NavigationLink {
                    Text("Forgot password")
                } label: {
                    Text("Forgot password?")
                        .font(.footnote)
                        .fontWeight(.bold)
                        .padding(.top)
                        .padding(.trailing,20)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                
                Button {
                    Task { try await viewModel.login()}
                } label: {
                    Text("Login")
                        .modifier(SignButtonModifier())
                }
                Spacer()
                
                Divider()

                
                NavigationLink {
                    RegistrationView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    HStack{
                        Text("New here?")
                        Text("Sign up now!")
                            .fontWeight(.bold)
                    }
                    .foregroundColor(.black)
                    .font(.system(size: 18))
                    .font(.footnote)
                }
                .padding(.vertical)
            }
            
        }
        
    }
}

#Preview {
    LoginView()
}
