//
//  SetGameView.swift
//  Set
//
//  Created by Theós on 08/05/2023.
//

import SwiftUI

struct SetGameView: View {
    @ObservedObject var game: SetGame
    
    var body: some View {
        VStack {
            Text("Set Game")
                .font(.title)
            AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in
                CardView(card: card)
                    .onTapGesture {
                        game.choose(card)
                    }
                    .padding(2)
            }
            buttons
            .font(.title3)
        }
        .foregroundColor(.blue)
        .padding(.horizontal)
    }
    
    var buttons: some View {
        HStack {
            Button("New Game") {
                game.startNewGame()
            }
            Spacer()
            Button("Deal 3 More Cards") {
                game.dealNewCards()
            }
            .disabled(game.deckCardsCount < 1)
        }
    }
}


struct CardView: View {
    var card: SetGame.Card
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                background
                VStack(alignment: .center) {
                    ForEach(1...card.count.rawValue, id: \.self) { _ in
                        symbol
                            .aspectRatio(2, contentMode: .fit)
                            .foregroundColor(color)
                            
                    }
                }
                    .padding(.horizontal, geometry.size.width * 0.125)
                    .padding(.vertical, geometry.size.height * 0.125)
            }
        }
    }
    
    @ViewBuilder
    private var background: some View {
        let shape = RoundedRectangle(cornerRadius: 10)
        if card.isSelected {
            shape.fill(.yellow)
                .opacity(0.2)
        } else {
            shape.fill(card.match.color)
                .opacity(card.match == .unmatched ? 1 : 0.3)
        }
        shape.strokeBorder(lineWidth: 3)
            .opacity(0.5)
    }
    
    @ViewBuilder
    private var symbol: some View {
        switch card.symbol {
        case .oval:
            Capsule()
                .customStyle(card.shading)
        case .squiggle:
            Rectangle()
                .customStyle(card.shading)
        case .diamond:
            Diamond()
                .customStyle(card.shading)
        }
    }
    
    private var color: Color {
        switch card.color {
        case .red:
            return Color.red
        case .green:
            return Color.green
        case .purple:
            return Color.purple
        }
    }
}


extension Shape {
    @ViewBuilder
    func customStyle(_ shade: SetGameModel.Card.Shading) -> some View {
        switch shade {
        case .open:
            self.stroke(style: StrokeStyle(lineWidth: 1.5))
        case .stripped:
            self.opacity(0.35)
        case .solid:
            self.opacity(1)
        }
    }
}

extension SetGameModel.Card.MatchStatus {
    fileprivate var color: Color {
        switch self {
        case .unmatched:
            return Color.white
        case .mismatched:
            return Color.red
        case .matched:
            return Color.green
        }
    }
}


struct SetGameView_Previews: PreviewProvider {
    static var previews: some View {
        let game = SetGame()
        SetGameView(game: game)
    }
}
