//
//  LoginViewModel.swift
//  GuessMe_iOS
//
//  Created by 유호준 on 2022/01/09.
//

import Foundation
import RxSwift
final class LoginViewModel{
    public var disposeBag = DisposeBag()
    
    public func login(id:String, password:String) -> Single<Bool>{
        return .create{single in
            Api.shared.login(id: id, password: password).subscribe(onSuccess: {
                if $0["success"].exists(){
                    single(.success(false))
                }
                else{
                    let nickname = $0["nickname"].stringValue
                    UserDefaults.standard.setValue(nickname, forKey: "nickname")
                    single(.success(true))
                }
            }, onError: {
                single(.error($0))
            }).disposed(by: self.disposeBag)
            
            return Disposables.create {}
        }
    }
    
    public func isUserHasQuiz() -> Single<Bool>{
        let nickname = UserDefaults.standard.string(forKey: "nickname")!
        return Api.shared.isUserHasQuiz(nickname: nickname)
        
    }
}
