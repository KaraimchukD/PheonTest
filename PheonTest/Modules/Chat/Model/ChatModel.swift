//
//  ChatModel.swift
//  PheonTest
//
//  Created by karaimchuk on 24.01.24.
//

import Foundation

struct ChatModel: Equatable {
    let text: String
    let owner: Owner
}

enum Owner {
    case `self`
    case another
}
