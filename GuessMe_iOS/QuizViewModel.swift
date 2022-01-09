//
//  QuizViewModel.swift
//  GuessMe_iOS
//
//  Created by 박희지 on 2022/01/09.
//

import Foundation
import RxSwift
import RxCocoa

final class QuizViewModel {
    let input = Input()
    let output = Output()
    
    private let disposeBag = DisposeBag()
    private var currentAnswers: [Int] = []
    
    struct Input {
        let quizType = PublishSubject<QuizType>()
        var quizList = PublishSubject<[Quiz]>()
        let tapButton = PublishSubject<Void>()
    }
    
    struct Output {
        let showErrorAlert = PublishRelay<Void>()
        let score = PublishRelay<Int>()
    }
    
    init() {
        self.input.tapButton
            .subscribe(onNext: self.onTapButton)
            .disposed(by: self.disposeBag)
    }
    
    private func onTapButton() {
        /// 생성: answer 값 수정 | 풀이: 채점하고
        // 실패 시 에러 로그
    }
    
    // 점수 계산
    private func calculateScore() {
        self.output.score.accept(100)
    }
}
