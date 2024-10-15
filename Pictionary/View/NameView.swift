//
//  SetNameVIew.swift
//  Pictionary
//
//TODO: change this Page UI

import SwiftUI

struct NameView: View {
    @AppStorage("yourName") var yourName = ""
    @State private var userName = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                TextField("Your Name", text: $userName)
                    .textFieldStyle(.roundedBorder)
                
                Text("This is the name that will be associated with this device.")
                
                Button("Set") {
                    yourName = userName
                }
                .buttonStyle(.borderedProminent)
                .disabled(userName.isEmpty)
            
                Spacer()
            }
            .padding()
            .navigationTitle("Buddy Battle")
        }
    }
}

#Preview {
    NameView()
}
