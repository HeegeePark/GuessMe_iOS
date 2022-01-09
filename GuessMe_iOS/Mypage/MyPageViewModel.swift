//
//  MyPageViewModel.swift
//  GuessMe_iOS
//
//  Created by 유호준 on 2022/01/09.
//

import Foundation
import RxSwift
import RxCocoa

final class MyPageViewModel{
    public var disposeBag = DisposeBag()
    public var rankList = [Rank]()
    
    init(){
        Api.shared.getRank().subscribe(onSuccess: {
            self.rankList = $0
        }, onError: {
            print($0.localizedDescription)
        }).disposed(by: self.disposeBag)
    }
    
    public func deleteQuiz() -> Completable{
        return Api.shared.deleteQuiz()
    }
}
