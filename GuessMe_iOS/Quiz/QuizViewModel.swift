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
    public let input = Input()
    public let output = Output()
    public var quizType: QuizType = .create(UserDefaults.standard.string(forKey: "id")!)
    
    private let disposeBag = DisposeBag()
    private var currentAnswers: [Int] = []
    
    struct Input {
        var quizObservable = BehaviorSubject<[Quiz]>(value: [])
        lazy var currentAnswers = quizObservable.map {
            $0.map { $0.answer }
        }
        let tapAnswerButton = PublishSubject<(Quiz, Int)>()
    }
    
    struct Output {
        let showErrorAlert = PublishRelay<Void>()
        var quizObservable = BehaviorRelay<[Quiz]>(value: [])
        lazy var answers = quizObservable.map {
            $0.map { $0.answer }
        }
        lazy var score = PublishSubject<Int>()
    }
    
    init() {
        // 퀴즈 문항 GET
        Api.shared.getQuizzes(type: self.quizType).subscribe(onSuccess: {
            self.input.quizObservable.onNext($0)
            self.output.quizObservable.accept($0)
        }, onError: {
            print($0.localizedDescription)
        }).disposed(by: self.disposeBag)
    
        // Bind Input
        self.input.tapAnswerButton
            .subscribe(onNext: self.selectAnswer(item: selected:))
            .disposed(by: self.disposeBag)
    }
    
    public func onTapSubmitButton(id: String) -> Completable {
        return .create { completable in
            switch self.quizType {
            case .create(id):
                self.createQuiz().subscribe {
                    completable(.completed)
                } onError: {
                    completable(.error($0))
                }.disposed(by: self.disposeBag)

            case .solve(id):
                self.calculateScore()
            default:
                self.output.showErrorAlert.accept(())
            }
            return Disposables.create {}
        }
        
    }
    
    private func onTapAnswerButton(item: Quiz, selected: Int) {
        self.selectAnswer(item: item, selected: selected)
    }
    
    // 퀴즈 생성
    private func createQuiz() -> Completable {
        let quizList = self.output.quizObservable.value
        
        return .create { completable in
            Api.shared.createQuiz(quizzes: quizList).subscribe {
                completable(.completed)
            } onError: {
                completable(.error($0))
            }.disposed(by: self.disposeBag)
            
            return Disposables.create {}
        }
    }
    
    // 퀴즈 제출
    private func solveQuiz() {
        self.calculateScore()
    }
    
    // 점수 계산
    private func calculateScore() {
        print("계산")
    }
    
    // O, X 답 변경 시 output 퀴즈Obs 업데이트
    private func selectAnswer(item: Quiz, selected: Int) {
        _ = self.input.quizObservable
            .map { quizzes in
                quizzes.map {
                    guard $0.quizId == item.quizId else { return $0 }
                    return Quiz(quizId: $0.quizId, content: $0.content, answer: selected)
                }
            }
            .take(1)
            .subscribe(onNext: {
                self.output.quizObservable.accept($0)
            }).disposed(by: self.disposeBag)
    }
}
