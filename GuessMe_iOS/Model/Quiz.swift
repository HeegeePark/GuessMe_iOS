//
//  Quiz.swift
//  GuessMe_iOS
//
//  Created by 박희지 on 2022/01/09.
//

import Foundation

struct Quiz {
    var quizId: Int
    var content: String
    var answer: Int
    
    static func getDummy() -> [Quiz]{
        return [Quiz(quizId: 1, content: "CC(Campus Couple)를 한 적이 있다.", answer: 100), Quiz(quizId: 2,content: "파인애플 피자를 좋아하는 것을 숨긴 적 있다.", answer: 80), Quiz(quizId: 3,content: "방에 들어갈 때 '따라다라단~ 따라다라다단~' 한 적이 있다.", answer: 60), Quiz(quizId: 4,content: "집에 혼자 들어가면서 '거기 있는거 다 안다, 나와' 한 적이 있다.", answer: 40), Quiz(quizId: 5,content: "발을 헛디뎌 놓고 아무렇지 않은 척 걸어간 적 있다.", answer: 20)]
    }
}
