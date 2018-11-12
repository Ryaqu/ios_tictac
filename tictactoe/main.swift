//
//  main.swift
//  tictactoe
//
//  Created by KM on 2018. 11. 05..
//  Copyright © 2018. KM. All rights reserved.
//

enum Piece: String
{
    case X = "X"
    case O = "O"
    case E = " "
    var opposite: Piece
    {
        switch self
        {
        case .X:
            return .O
        case .O:
            return .X
        case .E:
            return .E
        }
    }
    var value: String
    {
        switch self
        {
        case .X:
            return "X"
        case .O:
            return "O"
        case .E:
            return " "
        }
    }
}

typealias Move = Int

struct Board
{
    let position: [Piece]
    let turn: Piece
    let lastMove: Move

init(position: [Piece] = [.E, .E, .E, .E, .E, .E, .E, .E, .E], turn: Piece = .X, lastMove: Int = -1)
{
    self.position = position
    self.turn = turn
    self.lastMove = lastMove
}

func move(_ location: Move) -> Board
{
    var tempPosition = position
    tempPosition[location] = turn
    return Board(position: tempPosition, turn: turn.opposite, lastMove: location)
}
    var legalMoves: [Move]
    {
        return position.indices.filter {position[$0] == .E}
    }

var isWin: Bool
{
    return
        position[0] == position[1] && position[0] == position[2] && position[0] != .E || position[3] == position[4] && position[3] == position[5] && position[3] != .E || position[6] == position[7] && position[6] == position[8] && position[6] != .E || position[0] == position[3] && position[0] == position[6] && position[0] != .E || position[1] == position[4] && position[1] == position[7] && position[1] != .E || position[2] == position[5] && position[2] == position[8] && position[2] != .E || position[0] == position[4] && position[0] == position[8] && position[0] != .E || position[2] == position[4] && position[2] == position[6] && position[2] != .E
    }
    
    var isDraw: Bool
    {
        return !isWin && legalMoves.count == 0
    }
}

var table: [Piece] = [.E, .E, .E, .E, .E, .E, .E, .E, .E]
var test: Board = Board(position: table, turn: .O, lastMove: -1)

var isPlayerWin: Bool
{
    return table[0] == table[1] && table[0] == table[2] && table[0] == .O || table[3] == table[4] && table[3] == table[5] && table[3] == .O || table[6] == table[7] && table[6] == table[8] && table[6] == .O || table[0] == table[3] && table[0] == table[6] && table[0] == .O || table[1] == table[4] && table[1] == table[7] && table[1] == .O || table[2] == table[5] && table[2] == table[8] && table[2] == .O || table[0] == table[4] && table[0] == table[8] && table[0] == .O || table[2] == table[4] && table[2] == table[6] && table[2] == .O
}

var isAIWin: Bool
{
    return table[0] == table[1] && table[0] == table[2] && table[0] == .X || table[3] == table[4] && table[3] == table[5] && table[3] == .X || table[6] == table[7] && table[6] == table[8] && table[6] == .X || table[0] == table[3] && table[0] == table[6] && table[0] == .X || table[1] == table[4] && table[1] == table[7] && table[1] == .X || table[2] == table[5] && table[2] == table[8] && table[2] == .X || table[0] == table[4] && table[0] == table[8] && table[0] == .X || table[2] == table[4] && table[2] == table[6] && table[2] == .X
}

func minimax(_ board: Board, maximizing: Bool, originalPlayer: Piece) -> Int
{
    if board.isWin && originalPlayer == board.turn.opposite
    {
        return 1
    }
    else if board.isWin && originalPlayer != board.turn.opposite
    {
        return -1
    }
    else if board.isDraw
    {
        return 0
    }
    
    if maximizing
    {
        var bestEval = Int.min
        for move in board.legalMoves
        {
            let result = minimax(board.move(move), maximizing: false, originalPlayer: originalPlayer)
            bestEval = max(result,bestEval)
        }
        return bestEval
    }
    else
    {
        var worstEval = Int.max
        for move in board.legalMoves
        {
            let result = minimax(board.move(move), maximizing: true, originalPlayer: originalPlayer)
            worstEval = min(result,worstEval)
        }
        return worstEval
    }
}

func findBestMove(_ board: Board) -> Move
{
    var bestEval = Int.min
    var bestMove = -1
    for move in board.legalMoves
    {
        let result = minimax(board.move(move),maximizing: false,originalPlayer: board.turn)
        if result > bestEval
        {
            bestEval = result
            bestMove = move
        }
    }
    return bestMove
}



func clearTable()
{
    table = [.E, .E, .E, .E, .E, .E, .E, .E]
    test = Board(position: table, turn: .O, lastMove: -1)
}

var vege: Bool = false
func game()
{
    print("Hova raksz?")
    let playerMove = Int(readLine()!)
    if(playerMove == -1)
    {
        print("Kiléptél")
        vege = true
    }
    else if (playerMove != nil && playerMove! < 9 && playerMove! > -1 && table[playerMove!] == Piece.E)
    {
        table[playerMove!] = Piece.O
        if(table.contains(.E)){
            test = Board(position: table, turn: .X, lastMove: playerMove!)
            table[findBestMove(test)] = .X
        }
    }
    else
    {
        print("Ugye csak tesztelsz? - nem történt semmi, próbáld újra")
    }
    printGame()
    if(isPlayerWin)
    {
        print("Nyertél, ügyes vagy!")
        vege = true
    }
    else if (isAIWin)
    {
        print ("Nyert a gép, próbáld újra!")
        vege = true
        
    }
    else if (!isPlayerWin && !isAIWin && !table.contains(.E))
    {
        print ("Döntetlen, majd legközelebb!")
        vege = true
    }
}

func printGame()
{
    print("------")
    var my2d = [[Piece]]()
    my2d = [[table[0],table[1],table[2]],[table[3],table[4],table[5]],[table[6],table[7],table[8]]]
    var line : String = ""
    for i in 0...2
    {
        for j in 0...2
        {
            line.append(my2d[i][j].value)
            line.append(" ")
        }
        print(line)
        line = ""
    }
    print("------")
}

print("A játékban 0-8-ig adhatsz meg számot és aszerint tudod beírni a tippedet.")

while !vege
{
    game()
}
