//
//  MainViewModel.swift
//  GuessMe_iOS
//
//  Created by 박희지 on 2022/01/09.
//

import Foundation
import RxSwift
import RxCocoa

final class MainViewModel {
    let input = Input()
    let output = Output()
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let nickName = PublishSubject<String>()
        let tapButton = PublishSubject<Void>()
    }
    
    struct Output {
        let showErrorAlert = PublishRelay<Void>()
    }
    
    init() {
        self.input.tapButton
            .subscribe(onNext: self.onTapButton)
            .disposed(by: self.disposeBag)
    }
    
    private func onTapButton() {
        // 1. response에 성공하면 친구 퀴즈 푸는 뷰컨 넘어가기
        // 2. 실패 시 에러 알럿 띄우기
//        else {
//            self.output.showErrorAlert.accept(())
//        }
    }
}
