//
//  Quiz.swift
//  GuessMe_iOS
//
//  Created by 박희지 on 2022/01/09.
//

import Foundation
import Alamofire

struct Quiz {
    var quizId: Int
    var content: String
    var answer: Int
    
    public func toParameters() -> Parameters {
        let dict: Parameters = [
            "quizId": String(self.quizId),
            "content": self.content,
            "answer": String(self.answer)
        ]
        return dict
    }
}
