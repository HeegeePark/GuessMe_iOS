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
    let quizType: QuizType = .create(UserDefaults.standard.string(forKey: "id")!)
    
    private let disposeBag = DisposeBag()
    private var currentAnswers: [Int] = []
    
    struct Input {
        var quizObservable = BehaviorSubject<[Quiz]>(value: [])
        lazy var currentAnswers = quizObservable.map {
            $0.map { $0.answer }
        }
        let tapSubmitButton = PublishSubject<String>()
    }
    
    struct Output {
        let showErrorAlert = PublishRelay<Void>()
        var quizObservable = PublishRelay<[Quiz]>()
        lazy var answers = quizObservable.map {
            $0.map { $0.answer }
        }
        var score = Observable.just(0)
    }
    
    init() {
        // 퀴즈 문항 GET
        Api.shared.getQuizzes(type: self.quizType).subscribe(onSuccess: {
            self.input.quizObservable.onNext($0)
        }, onError: {
            print($0.localizedDescription)
        }).disposed(by: self.disposeBag)
        
        self.input.tapSubmitButton
            .subscribe(onNext: self.onTapSubmitButton(id:))
            .disposed(by: self.disposeBag)
    }
    
    private func onTapSubmitButton(id: String) {
        switch self.quizType {
        case .create(id):
            self.createQuiz()
        case .solve(id):
            self.calculateScore()
        default:
            self.output.showErrorAlert.accept(())
        }
    }
    
    // 퀴즈 생성
    private func createQuiz() {
        print("무야호")
    }
    
    // 점수 계산
    private func calculateScore() {
        print("계산")
//        _ = Observable.zip(self.input.quizObservable, self.output.quizObservable) { original, solved in
//            print(original)
//            print(solved)
//        }
    }
    
    // 퀴즈 값 선택
    func selectAnswer(item: Quiz, selected: Int) {
        _ = self.input.quizObservable
            .map { quizzes in
                quizzes.map { q in
                    if q.quizId == item.quizId {
                        print(selected)
                        return Quiz(quizId: q.quizId, content: q.content, answer: selected)
                    } else {
                        return Quiz(quizId: q.quizId, content: q.content, answer: q.answer)
                    }
                }
            }
            .take(1)
            .subscribe(onNext: {
                self.output.quizObservable.accept($0)
            })
    }
}
