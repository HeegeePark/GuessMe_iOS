//
//  ViewQuiz.swift
//  GuessMe_iOS
//
//  Created by 박희지 on 2022/01/09.
//

import Foundation

struct ViewQuiz {
    var quizId: Int
    var content: String
    var answer: Int
    
    init(_ item: Quiz) {
        quizId = item.quizId
        content = item.content
        answer = 0
    }
    
    init(quizId: Int, content: String, answer: Int) {
        self.quizId = quizId
        self.content = content
        self.answer = answer
    }
    
//    func answerUpdated(_ answer: Int) {
//        return Quiz(quizId: quizId, content: content, answer: answer)
//    }
    
    func asQuizItem() -> Quiz {
        return Quiz(quizId: quizId, content: content, answer: answer)
    }
}
