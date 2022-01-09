//
//  Rank.swift
//  GuessMe_iOS
//
//  Created by 유호준 on 2022/01/07.
//

import Foundation

struct Rank{
    var rank: Int
    var nickname: String
    var score: Int
    
    static func getDummy() -> [Rank]{
        return [Rank(rank: 1, nickname: "바키지", score: 100), Rank(rank: 2,nickname: "도워니", score: 80), Rank(rank: 3,nickname: "머쨍이호준", score: 60), Rank(rank: 4,nickname: "윤한쓰", score: 40), Rank(rank: 5,nickname: "저닝", score: 20)]
    }
}
