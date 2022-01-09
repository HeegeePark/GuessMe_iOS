//
//  SignUpViewModel.swift
//  GuessMe_iOS
//
//  Created by 유호준 on 2022/01/09.
//

import Foundation
import RxSwift

final class SignUpViewModel{
    public var disposeBag = DisposeBag()
    public var isIdChecked = false//중복확인을 했는가
    
    //MARK: -회원가입
    public func signUp(id:String, password:String) -> Completable{
        return .create{completable in
            Api.shared.signUp(id: id, password: password).subscribe(onCompleted: {
                completable(.completed)
            }, onError: {
                completable(.error($0))
            }).disposed(by: self.disposeBag)
            
            return Disposables.create {}
        }
    }
    
    public func idCheck(id:String) -> Completable{
        return .create{completable in
            Api.shared.isExist(id: id).subscribe(onSuccess: {
                if $0["success"].stringValue == "true"{
                    self.isIdChecked = true
                }
                else{
                    self.isIdChecked = false
                }
                completable(.completed)
            }, onError: {
                completable(.error($0))
            }).disposed(by: self.disposeBag)
            return Disposables.create {}
        }
    }
    //MARK: -Private
    
}
