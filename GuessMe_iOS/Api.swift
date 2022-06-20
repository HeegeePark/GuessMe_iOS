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
import UIKit

enum ApiError: Error{
    case urlEncodingError
}

final class Api{
    
    public static let shared = Api()
    
    
    // MARK: - Login
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
    
    // MARK: - SignUp
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
    
    // MARK: - Quiz
    // 랜덤퀴즈 5개 GET(quizType에 따라 GET 요청)
    public func getQuizzes(type: QuizType) -> Single<[Quiz]> {
        var url = baseUrl
        switch type {
        case .create(let id): url += "quizzes"
        case .solve(let id): url += "quizzes/\(id)"
        }
        
        guard let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return .create {
                $0(.error(ApiError.urlEncodingError))
                return Disposables.create {}
            }
        }
        
        return .create { single in
            AF.request(encodedUrl, method: .get, interceptor: self.interceptor).responseJSON {
                switch $0.result {
                case .success(let data):
                    let json = JSON(data)
                    var count = 1
                    let quizList = json["_embedded"].dictionaryValue["quizList"]!.arrayValue.map { data -> Quiz in
                        let item = data.dictionaryValue
                        let quiz = Quiz(quizId: count, content: item["content"]!.stringValue, answer: item["answer"]!.intValue)
                        count += 1
                        return quiz
                    }
                    single(.success(quizList))
                case .failure(let error):
                    single(.error(error))
                }
            }
            return Disposables.create()
        }
    }
    
    // 퀴즈생성 POST
    public func createQuiz(quizzes: [Quiz]) -> Completable {
        let url = baseUrl + "quizzes"
        let arr = Array(quizzes.map { $0.toParameters() })
        let param: Parameters = [
            "data": arr
        ]
        
        guard let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return .create {
                $0(.error(ApiError.urlEncodingError))
                return Disposables.create {}
            }
        }
        
        return .create { completable in
            AF.request(encodedUrl, method: .post, parameters: param, encoding: JSONEncoding.default, interceptor: self.interceptor).responseJSON {
                switch $0.result {
                case .success(_):
                    completable(.completed)
                case .failure(let error):
                    completable(.error(error))
                }
            }
            return Disposables.create {}
        }
    }
    
    // 퀴즈풀이 점수 POST (/quizzes/nickname)
    public func solveQuiz(nickname: String, score: String) -> Completable {
        let url = baseUrl + "quizzes/\(nickname)"
        let param: Parameters = [
            "score": score
        ]
        
        guard let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return .create {
                $0(.error(ApiError.urlEncodingError))
                return Disposables.create {}
            }
        }
        
        return .create { completable in
            AF.request(encodedUrl, method: .post, parameters: param, encoding: JSONEncoding.default).responseJSON {
                switch $0.result {
                case .success(_):
                    completable(.completed)
                case .failure(let error):
                    completable(.error(error))
                }
            }
            return Disposables.create {}
        }
    }
    
    // MARK: - MyPage
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
    private let baseUrl = "https://guess-me-app.herokuapp.com/"
    private let interceptor = TokenInterceptor()
    private init(){}
}
