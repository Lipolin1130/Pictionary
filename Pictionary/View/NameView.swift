//
//  SetNameVIew.swift
//  Pictionary
//


import SwiftUI

struct NameView: View {
    @AppStorage("yourName") var yourName = ""
    @State private var userName = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("This is the name that will be associated with this device.")
                
                TextField("Your Name", text: $userName)
                    .textFieldStyle(.roundedBorder)
                
                Button("Set") {
                    yourName = userName
                }
                .buttonStyle(.borderedProminent)
                .disabled(userName.isEmpty)
            
                Spacer()
            }
            .padding()
            .navigationTitle("Pictionary")
        }
    }
}

#Preview {
    NameView()
}
