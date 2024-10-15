//
//  GameView.swift
//  Pictionary
//


import SwiftUI

struct GameView: View {
    @EnvironmentObject var gameService: GameService
    @EnvironmentObject var connectionManager: MPConnectionManager
    @Environment(\.dismiss) var dismiss
    
    @State var eraserEnabled = false
    @State var drawingGuess = ""
    
    func makeGuess() {
        guard drawingGuess != "" else { return }
        let guessData: GuessData = GuessData(message: drawingGuess)
        
        if let encodedGuessData = try? JSONEncoder().encode(guessData) {
            gameService.connectionManager?.send(transData: TransData(
                type: .guess,
                payload: encodedGuessData,
                sender: gameService.mainPlayer.name))
        }
        drawingGuess = ""
    }
    
    var body: some View {
        ZStack {
            if gameService.isGameOver {
                GameOverView()
                    .environmentObject(gameService)
            } else {
                GeometryReader { _ in
                    Image(gameService.mainPlayer.currentlyDrawing ? "drawerBg" : "guesserBg")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                        .scaleEffect(1.1)
                    
                    VStack{
                        topBar
                        
                        ZStack {
                            DrawingView(gameService: _gameService, eraserEnabled: $eraserEnabled)
                                .aspectRatio(contentMode: .fit)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.black, lineWidth: 10)
                                }
                            
                            VStack {
                                HStack {
                                    Spacer()
                                    
                                    if gameService.mainPlayer.currentlyDrawing {
                                        Button {
                                            eraserEnabled.toggle()
                                        } label: {
                                            Image(systemName: eraserEnabled ? "eraser.fill" : "eraser")
                                                .font(.title)
                                                .foregroundStyle(Color("primaryPurple"))
                                                .padding(.top, 10)
                                        }
                                        
                                    }
                                }
                                
                                Spacer()
                            }
                            .padding()
                        }
                        pastGuesses
                    }
                    .padding(.horizontal, 30)
                    .ignoresSafeArea(.keyboard, edges: .bottom)
                }
                
                VStack {
                    Spacer()
                    
                    promptGroup
                }
                .ignoresSafeArea(.container)
            }
        }
        .onReceive(coutdownTimer) { _ in
            guard gameService.isTimeKeeper else { return }
            gameService.remainingTime -= 1
        }
    }
    
    var topBar: some View {
        ZStack {
            HStack {
                Button {
                    connectionManager.session.disconnect()
                } label: {
                    Image(systemName: "arrowshape.turn.up.left.circle.fill")
                        .font(.largeTitle)
                        .tint(Color(gameService.mainPlayer.currentlyDrawing ? "primaryYellow" : "primaryPurple"))
                }
                
                Spacer()
                
                Label("\(gameService.remainingTime)", systemImage: "clock.fill")
                    .bold()
                    .font(.title2)
                    .foregroundStyle(Color(gameService.mainPlayer.currentlyDrawing ? "primaryYellow" : "primaryPurple"))
            }
            
            Text("Score: \(gameService.score)")
                .bold()
                .font(.title)
                .foregroundStyle(Color(gameService.mainPlayer.currentlyDrawing ? "primaryYellow": "primaryPurple"))
        }
    }//TODO: component to another file
    
    var pastGuesses: some View {
        ScrollView {
            ForEach(gameService.pastGuesses) {guess in
                HStack {
                    Text(guess.message)
                        .font(.title2)
                        .bold(guess.isCorrect ?? false)
                    
                    if guess.isCorrect ?? false {
                        Image(systemName: "hand.thumbsup.fill")
                            .foregroundStyle(gameService.mainPlayer.currentlyDrawing ?
                                             Color(red: 0.808, green: 0.345, blue: 0.776):
                                                Color(red: 0.243, green: 0.773, blue: 0.745)
                            )
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 1)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background((
            gameService.mainPlayer.currentlyDrawing ?
            Color(red: 0.243, green: 0.773, blue: 0.745) : Color("primaryYellow"))
            .brightness(-0.2)
            .opacity(0.5)
        )
        .cornerRadius(20)
        .padding(.vertical)
        .padding(.bottom, 130)
    }//TODO: component to another file
    
    var promptGroup: some View {
        VStack {
            if gameService.mainPlayer.currentlyDrawing {
                Label("DRAW", systemImage: "exclamationmark.bubble.fill")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
                
                Text(gameService.drawPrompt.uppercased())
                    .font(.largeTitle)
                    .bold()
                    .padding()
                    .foregroundColor(Color("primaryYellow"))
            } else {
                HStack {
                    Label("GUESS THE DRAWING!:", systemImage: "exclamationmark.bubble.fill")
                        .font(.title2)
                        .bold()
                        .foregroundColor(Color("primaryPurple"))
                    Spacer()
                }
                
                HStack {
                    TextField("Type your guess", text: $drawingGuess)
                        .padding()
                        .background(
                            Capsule(style: .circular)
                                .fill(.white)
                        )
                        .onSubmit(makeGuess)
                    Button {
                        makeGuess()
                        drawingGuess = ""
                    } label: {
                        Image(systemName: "chevron.right.circle.fill")
                            .renderingMode(.original)
                            .foregroundStyle(Color("primaryPurple"))
                            .font(.system(size: 50))
                    }
                    
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding([.horizontal, .bottom], 30)
        .padding(.vertical)
        .background((
            gameService.mainPlayer.currentlyDrawing ? Color(red: 0.243, green: 0.773, blue: 0.745) : Color("primaryYellow")
        )
            .opacity(0.5)
            .brightness(-0.2)
        )
    }//TODO: component to another file
}

#Preview {
    NavigationStack {
        GameView()
            .environmentObject(GameService())
            .environmentObject(MPConnectionManager(yourName: "Sample"))
    }
}
