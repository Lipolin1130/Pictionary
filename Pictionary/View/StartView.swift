//
//  StartView.swift
//  Pictionary
//

// 開始頁面

import SwiftUI

struct StartView: View {
    
    //variable
    @EnvironmentObject var gameService: GameService
    @State var connectionManager: MPConnectionManager? = nil
    @AppStorage("yourName") var yourName = ""
    
    @State private var startGame: Bool = false
    @State private var startSearching: Bool = false //
    @State private var tempName: String = ""
    @State private var showSheet: Bool = false
    
    //View
    var body: some View {
        NavigationStack {
            ZStack {
                Color.purple.ignoresSafeArea()
                    .opacity(0.4)
                
                VStack {
                    
                    if startSearching {
                        HStack {
                            Image(systemName: "pencil.and.scribble")
                                .font(.system(size: 30))
                            
                            Text("Buddy Battle")
                                .font(.custom(customFont, size: 30))
                            
                            Image(systemName: "flag.checkered.2.crossed")
                                .font(.system(size: 30))
                        }
                        .padding(.bottom, 40)
                        
                        if let connectionManager = connectionManager {
                            MPPeersView(startGame: $startGame)
                                .environmentObject(connectionManager)
                                .environmentObject(gameService)
                                .frame(width: 350)
                        }
                    } else {
                        Spacer()
                        
                        Text("Buddy\nBattle") // \n 換行
                            .font(.custom(customFont, size: 70))
                        
                        HStack {
                            Image(systemName: "pencil.and.scribble") // SF symbol
                            Image(systemName: "flag.checkered.2.crossed")
                        }
                        .font(.system(size: 50))
                    }
                    
                    Spacer() //空白，會推開所有 component
                    
                    Button {
                        withAnimation(.linear(duration: 0.5)) {
                            if !yourName.isEmpty {
                                startSearching.toggle()
                                // toggle true -> false Or false -> True
                            } else {
                                showSheet = true
                            }
                        }
                    } label: {
                        
                        // ?: 三元運算式
                        // Variable(True/False) ? true : false
                        Text(startSearching ? "Cancle" : "Start Game")
                            .fontWeight(.semibold)
                            .font(.custom(customFont, size: 25))
                            .padding(15)
                            .background(startSearching ? .red.opacity(0.7) : Color.cyan)
                            .cornerRadius(10)
                            .padding(10)
                            .foregroundStyle(.white)
                    }
                }
                .padding()
            }
        }
        .onAppear {
            if yourName.isEmpty {
                showSheet = true
            } else {
                initializeConnectionManager()
            }
        }
        .onChange(of: yourName) {
            initializeConnectionManager()
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
