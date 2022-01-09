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
    
    public func signUp(id:String, password:String) -> Completable{
        let url = baseUrl + "users"
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
        
        return .create{completable in
            AF.request(encodedUrl, method: .post, parameters: param, encoding: JSONEncoding.default).responseJSON{
                switch $0.result{
                case .success(_):
                    completable(.completed)
                case .failure(let error):
                    completable(.error(error))
                }
            }
            
            return Disposables.create {}
        }
    }
    
    public func isExist(id:String) -> Single<JSON>{
        let url = baseUrl + "users/\(id)"
                
        guard let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else{
            return .create{
                $0(.error(ApiError.urlEncodingError))
                return Disposables.create {}
            }
        }

        return .create{single in
            AF.request(encodedUrl, method: .get).responseJSON{
                switch $0.result{
                case .success(let data):
                    let json = JSON(data)
                    single(.success(json))
                case .failure(let error):
                    single(.error(error))
                }
            }
            return Disposables.create {}
        }
    }
    
    public func getRank() -> Single<[Rank]>{
        let url = baseUrl + "users/rank"
                
        guard let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else{
            return .create{
                $0(.error(ApiError.urlEncodingError))
                return Disposables.create {}
            }
        }
        
        return .create{single in
            AF.request(encodedUrl, method: .get, interceptor: self.interceptor).responseJSON{
                switch $0.result{
                case .success(let data):
                    let json = JSON(data)
                    var cnt = 1
                    let rankList = json["ranking"].arrayValue.map{data -> Rank in
                        let answerer =  data["answerer"].dictionaryValue
                        let rank = Rank(rank: cnt, nickname:answerer["nickname"]!.stringValue, score: data["score"].intValue)
                        cnt += 1
                        return rank
                    }
                    single(.success(rankList))
                case .failure(let error):
                    single(.error(error))
                }
            }
            return Disposables.create {}
        }
    }
    public func isUserHasQuiz(nickname: String) -> Single<Bool>{
        let url = baseUrl + "quizzes/\(nickname)"
                
        guard let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else{
            return .create{
                $0(.error(ApiError.urlEncodingError))
                return Disposables.create {}
            }
        }
        
        return .create{single in
            AF.request(url,method: .get, interceptor: self.interceptor).responseJSON{
                switch $0.result{
                case .success(let data):
                    let json = JSON(data)["_embedded"]
                    let quizList = json["quizList"].arrayValue
                    single(.success(!quizList.isEmpty))
                case .failure(let error):
                    single(.error(error))
                }
            }
            
            return Disposables.create {}
        }

    }
    public func deleteQuiz() -> Completable{
        let url = baseUrl + "quizzes"
                
        guard let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else{
            return .create{
                $0(.error(ApiError.urlEncodingError))
                return Disposables.create {}
            }
        }
        
        return .create{completable in
            AF.request(encodedUrl,method: .delete ,interceptor: self.interceptor).response{
                switch $0.result{
                case .success(_):
                    completable(.completed)
                case .failure(let error):
                    completable(.error(error))
                }
            }
            return Disposables.create {}
        }

    }
    //MARK: -Private
    private let baseUrl = "https://guessme-ios.herokuapp.com/"
    private let interceptor = TokenInterceptor()
    private init(){}
}
