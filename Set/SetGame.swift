//
//  SetGame.swift
//  Set
//
//  Created by Theós on 08/05/2023.
//

import Foundation

class SetGame: ObservableObject {
    typealias Card = SetGameModel.Card
    
    static func createSetGame() -> SetGameModel {
        var newGame = SetGameModel()
        newGame.start()
        return newGame
    }
    
    @Published private var model = createSetGame()
    
    var cards: [Card] {
        model.cards
    }
    
    var deckCardsCount: Int {
        model.deck.count
    }
    
    
//    MARK: - Intent action(s)
    
    func dealNewCards() {
        model.dealNewCards()
    }
    
    func choose(_ card: Card) {
        model.choose(card)
    }
    
    func startNewGame() {
        model = SetGame.createSetGame()
    }
    
}
