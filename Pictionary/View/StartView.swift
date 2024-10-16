//
//  StartView.swift
//  Pictionary
//
//TODO: change this Page UI

import SwiftUI

struct StartView: View {
    @EnvironmentObject var gameService: GameService
    @State var connectionManager: MPConnectionManager? = nil
    @AppStorage("yourName") var yourName = ""
    
    @State private var startGame: Bool = false
    @State private var startSearching: Bool = false
    @State private var tempName: String = ""
    @State private var showSheet: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Image(systemName: "pencil.and.scribble")
                        .font(.system(size: 35))
                    
                    Text("Buddy Battle")
                        .font(.custom(customFont, size: 35))
                }
                .padding(.bottom, 40)
                
                
                if startSearching {
                    if let connectionManager = connectionManager {
                        MPPeersView(startGame: $startGame)
                            .environmentObject(connectionManager)
                            .environmentObject(gameService)
                            .frame(width: 350)
                    }
                }
                
                Spacer()
                
                Button {
                    withAnimation(.linear) {
                        if !yourName.isEmpty {
                            startSearching.toggle()
                        } else {
                            showSheet = true
                        }
                    }
                } label: {
                    Text(startSearching ? "Cancle" : "Start Game")
                        .fontWeight(.semibold)
                        .font(.custom(customFont, size: 25))
                        .padding(15)
                        .background(startSearching ? .red : .blue)
                        .cornerRadius(10)
                        .padding(10)
                        .foregroundStyle(.white)
                }
            }
            .padding()
        }
        .onAppear {
            if yourName.isEmpty {
                showSheet = true
            } else {
                initializeConnectionManager()
            }
        }
        .sheet(isPresented: $showSheet) {
            VStack(spacing: 20) {
                Text("We need your name to play")
                    .font(.title)
                    .bold()
                    .padding()
                
                Text("This is the name that will be associated with this device.")
                    .font(.subheadline)
                
                TextField("Your Name", text: $tempName)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                
                HStack {
                    Button("Cancel", role: .destructive) {
                        showSheet = false
                    }
                    .padding()
                    
                    Button("OK") {
                        yourName = tempName
                        showSheet = false
                    }
                    .disabled(tempName.isEmpty)
                    .padding()
                    
                }
                .buttonStyle(.borderedProminent)
            }
            .presentationDetents([.height(350), .medium])
            .presentationDragIndicator(.hidden)
        }
        .fullScreenCover(isPresented: $startGame) {
            if let connectionManager = connectionManager {
                GameView()
                    .environmentObject(connectionManager)
            }
        }
    }
    
    private func initializeConnectionManager() {
        connectionManager = MPConnectionManager(yourName: yourName)
    }
}

#Preview {
    NavigationStack {
        StartView(yourName: "Sample")
            .environmentObject(GameService())
    }
}
