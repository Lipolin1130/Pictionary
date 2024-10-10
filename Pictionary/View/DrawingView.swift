//
//  DrawingVIew.swift
//  Pictionary
//


import SwiftUI
import PencilKit

struct DrawingView: UIViewRepresentable {
//    @EnvironmentObject var connectionManager: MPConnectionManager
    @EnvironmentObject var gameService: GameService
    @Binding var eraserEnabled: Bool
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        let wasDrawing = uiView.isUserInteractionEnabled
        uiView.isUserInteractionEnabled = gameService.mainPlayer.currentlyDrawing
        if !wasDrawing && gameService.mainPlayer.currentlyDrawing {
            uiView.drawing = PKDrawing()
        }
        
        if !uiView.isUserInteractionEnabled || !gameService.inGame {
            uiView.drawing = gameService.lastReceivedDrawing
        }
        
        uiView.tool = eraserEnabled ? PKEraserTool(.vector) : PKInkingTool(.pen, color: .black, width: 5)
    }
    
    func makeCoordinator() -> Coordinator {
//        Coordinator(connectionManager: connectionManager)
        Coordinator(gameService: gameService)
    }
    
    class Coordinator: NSObject, PKCanvasViewDelegate {
//        var connectionManager: MPConnectionManager
        var gameService: GameService
        
//        init(connectionManager: MPConnectionManager) {
//            self.connectionManager = connectionManager
//        }
        init(gameService: GameService) {
            self.gameService = gameService
        }
        
        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            guard canvasView.isUserInteractionEnabled else { return }
            
            let drawData = DrawData(drawing: canvasView.drawing.dataRepresentation())
            if let encodedData = try? JSONEncoder().encode(drawData) {
                let transData = TransData(type: .draw, payload: encodedData, sender: gameService.mainPlayer.name)
                gameService.connectionManager?.send(transData: transData)
            }
        }
    }
    
    func makeUIView(context: Context) -> PKCanvasView {
        let canvasView = PKCanvasView()
        
        canvasView.drawingPolicy = .anyInput
        canvasView.tool =  PKInkingTool(.pen, color: .black, width: 5)
        canvasView.delegate = context.coordinator
        canvasView.isUserInteractionEnabled = gameService.mainPlayer.currentlyDrawing
        
        return canvasView
    }
}

#Preview {
    DrawingView(eraserEnabled: .constant(false))
        .environmentObject(MPConnectionManager(yourName: "Sample"))
        .environmentObject(GameService())
        
}
