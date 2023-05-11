//
//  SetGameModel.swift
//  Set
//
//  Created by Theós on 08/05/2023.
//

import Foundation

struct SetGameModel {
    private(set) var deck: [Card] = {
        var tempDeck = Array<Card>()
        var deckCount = 0
        for count in Card.Count.allCases {
            for shade in Card.Shading.allCases {
                for shape in Card.Symbol.allCases {
                    for color in Card.Color.allCases {
                        deckCount += 1
                        tempDeck.append(Card(id: deckCount, count: count, shading: shade, symbol: shape, color: color))
                    }
                }
            }
        }
        return tempDeck.shuffled()
    }()
    
    private(set) var cards: [Card] = []
    
    private var selectedCardsIndices: (Int, Int)? {
        get { cards.indices.filter { cards[$0].isSelected && cards[$0].match == .unmatched }.onlyTwo }
        set { cards.indices.forEach{ cards[$0].isSelected = false } }
    }
    
    private var mismatchedCardsIndices: [Int] {
        cards.indices.filter { cards[$0].match == .mismatched }
    }
    
    private var matchedCardsIndices: [Int] {
        cards.indices.filter { cards[$0].match == .matched }
    }
    
    mutating func start() {
        deal(cards: 12)
    }
    
    mutating func dealNewCards() {
        if matchedCardsIndices.count > 0 {
            replaceOrRemoveMatchedCards()
        } else {
            deal(cards: 3)
        }
    }
    
    private mutating func deal(cards count: Int) {
        let cardCount = min(count, deck.count)
        for _ in 0..<cardCount {
            cards.append(deck.removeFirst())
        }
    }
    
    mutating func choose(_ card: Card) {
        replaceOrRemoveMatchedCards()
        resetMismatchedCards()
        
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }),
           cards[chosenIndex].match != .matched
        {
            if let (firstIndex, secondIndex) = selectedCardsIndices,
               firstIndex != chosenIndex,
               secondIndex != chosenIndex
            {
                let isMatched = isSet(first: cards[firstIndex], second: cards[secondIndex], third: cards[chosenIndex])
                cards[firstIndex].match = isMatched ? .matched : .mismatched
                cards[secondIndex].match = isMatched ? .matched : .mismatched
                cards[chosenIndex].match = isMatched ? .matched : .mismatched
                selectedCardsIndices = nil
            } else {
                cards[chosenIndex].isSelected.toggle()
            }
        }
    }
    
    mutating func resetMismatchedCards() {
        mismatchedCardsIndices.forEach { cards[$0].match = .unmatched }
    }
    
    mutating func replaceOrRemoveMatchedCards() {
        let matchedCardsCount = matchedCardsIndices.count
        if deck.count >= 3   {
            matchedCardsIndices.forEach { cards[$0] = deck.removeFirst() }
        } else {
            for _ in 0..<matchedCardsCount {
                cards.remove(at: matchedCardsIndices.first!)
            }
        }
    }
    
    func isSet(first card1: Card, second card2: Card, third card3: Card) -> Bool {
        if card1.color == card2.color && card2.color == card3.color ||
            card1.color != card2.color && card2.color != card3.color &&
            card1.color != card3.color,
            card1.symbol == card2.symbol && card2.symbol == card3.symbol ||
            card1.symbol != card2.symbol && card2.symbol != card3.symbol &&
            card1.symbol != card3.symbol,
            card1.shading == card2.shading && card2.shading == card3.shading ||
            card1.shading != card2.shading && card2.shading != card3.shading &&
            card1.shading != card3.shading,
            card1.count == card2.count && card2.count == card3.count ||
            card1.count != card2.count && card2.count != card3.count &&
            card1.count != card3.count {
                return true
        }
        return false
    }

    
    struct Card: Identifiable {
        enum Count: Int, CaseIterable {
            case one = 1, two, three
        }
        
        enum Shading: CaseIterable {
            case solid
            case stripped
            case open
        }
        
        enum Symbol: CaseIterable {
            case diamond
            case squiggle
            case oval
        }
        
        enum Color: CaseIterable {
            case red
            case green
            case purple
        }
        
        enum MatchStatus {
            case matched
            case mismatched
            case unmatched
        }
        
        var isSelected = false
        var match: MatchStatus = .unmatched
        let id: Int
        let count: Count
        let shading: Shading
        let symbol: Symbol
        let color: Color
    }
    
}


extension Array {
    var onlyTwo: (Element, Element)? {
        if count == 2 {
            return (self[0], self[1])
        } else {
            return nil
        }
    }
}

