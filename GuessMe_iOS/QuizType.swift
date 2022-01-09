//
//  QuizType.swift
//  GuessMe_iOS
//
//  Created by 박희지 on 2022/01/09.
//

import Foundation

public enum QuizType {
    case create(String)
    case solve(String)
    
    var title: String {
        switch self {
        case .create(let id):
            return "\(id)님 퀴즈를 만들어 보세요!"
        case .solve(let id):
            return "\(id)님 퀴즈를 풀어 보세요!"
        }
    }
    
    var description: String {
        switch self {
        case .create: return
            """
            랜덤으로 5가지의 질문이 뽑혔어요!
            본인만의 답변을 체크하고 친구들에게 공유하세요~!
            """
        case .solve: return
            """
            퀴즈를 풀고, 높은 점수를 받아서
            친구와의 우정을 다져보세요!
            """
        }
    }
    
    var buttonText: String {
        switch self {
        case .create: return "퀴즈 생성 완료"
        case .solve: return "퀴즈 제출하기"
        }
    }
}
