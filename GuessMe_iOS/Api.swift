//
//  API.swift
//  GuessMe_iOS
//
//  Created by 유호준 on 2022/01/09.
//

import Foundation
import Alamofire
import RxSwift
import SwiftyJSON

enum ApiError: Error{
    case urlEncodingError
}


final class Api{
    
    public static let shared = Api()
    
    public func login(id:String, password:String) -> Single<JSON>{
        let url = baseUrl + "login"
        let param: Parameters = [
            "nickname":id,
            "password":password
        ]
        
        guard let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else{
            return .create{
                $0(.error(ApiError.urlEncodingError))
                return Disposables.create {}
            }
        }
        return .create{single in
            AF.request(encodedUrl, method: .post, parameters: param, encoding: JSONEncoding.default).responseJSON{
                switch $0.result{
                case.success(let data):
                    let json = JSON(data)
                    let token = $0.response?.headers.value(for: "X-AUTH-TOKEN")
                    UserDefaults.standard.setValue(token, forKey: "token")
                    single(.success(json))
                case .failure(let error):
                    single(.error(error))
                }
            }
            
            return Disposables.create {}
        }
    }
    
    //MARK: -Private
    private let baseUrl = "https://guessme-ios.herokuapp.com/"
    private init(){}
}
