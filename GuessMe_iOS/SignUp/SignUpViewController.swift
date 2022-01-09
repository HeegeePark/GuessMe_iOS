//
//  SignUpViewController.swift
//  GuessMe_iOS
//
//  Created by 유호준 on 2022/01/06.
//

import Foundation
import UIKit
import SnapKit
import RxCocoa
import RxSwift

class SignUpViewController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    //MARK: - Private
    
    //MARK: - setUp
    private func setUp(){
        setUpLayout()
        setUpButton()
        setUpRepeatPassword()
        setUpIdTextField()
    }
    //MARK: - 로딩 설정
    private func startLoading(){
        loadingView.isHidden = false
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
    }
    private func stopLoading(){
        loadingView.isHidden = true
        loadingIndicator.isHidden = true
        loadingIndicator.stopAnimating()
    }
    
    //MARK: - Id 텍스트 필드 설정
    private func setUpIdTextField(){
        //id 입력 시 중복 체크 초기화
        idTextField.rx.text.distinctUntilChanged().subscribe(onNext: {_ in
            self.viewModel.isIdChecked = false
        }).disposed(by: self.disposeBag)
    }
    //MARK: - 비밀번호 재입력 설정
    private func setUpRepeatPassword(){
        repeatPasswordTextField.rx.text.skip(1).distinctUntilChanged().subscribe(onNext:{
            if $0 != self.passwordTextField.text{
                self.passwordNotMatchLabel.isHidden = false
                self.signUpButton.isEnabled = false
                self.signUpNextButton.isEnabled = false
            }
            else{
                self.signUpButton.isEnabled = true
                self.signUpNextButton.isEnabled = true
                self.passwordNotMatchLabel.isHidden = true
            }
        }).disposed(by: self.disposeBag)
    }
    //MARK: - 버튼 설정
    private func setUpButton(){
        let signUpButtonTap = signUpButton.rx.tap.map{()}
        let signUpNextButtonTab = signUpNextButton.rx.tap.map{()}
        
        Observable.merge(signUpButtonTap, signUpNextButtonTab).observeOn(MainScheduler.instance).subscribe (onNext:{
            if self.viewModel.isIdChecked{
                guard let id = self.idTextField.text, !id.isEmpty else{
                    let alert = UIAlertController(title: "회원가입", message: "아이디가 비어있습니다.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .cancel))
                    self.present(alert, animated: true)
                    
                    return
                }
                
                guard let password = self.passwordTextField.text, !id.isEmpty else{
                    let alert = UIAlertController(title: "회원가입", message: "비밀번호가 비어있습니다.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .cancel))
                    self.present(alert, animated: true)
                    
                    return
                }
                
                self.startLoading()
                self.viewModel.signUp(id: id, password:password).subscribe(onCompleted: {
                    self.stopLoading()
                    let alert = UIAlertController(title: "회원가입", message: "회원가입 완료", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .cancel){_ in
                        self.presentingViewController?.dismiss(animated: true)
                    })
                    self.present(alert, animated: true)
                }, onError: {
                    self.stopLoading()
                    print($0.localizedDescription)
                    let alert = UIAlertController(title: "회원가입", message: "서버 에러", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .cancel))
                    self.present(alert, animated: true)
                }).disposed(by: self.disposeBag)
            }
            else{
                let alert = UIAlertController(title: "회원가입", message: "아이디 중복확인을 해주세요.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .cancel))
                self.present(alert, animated: true)
            }
        }).disposed(by: self.disposeBag)
        
        idCheckButton.rx.tap.observeOn(MainScheduler.instance).subscribe(onNext:{
            guard let id = self.idTextField.text, !id.isEmpty else{
                let alert = UIAlertController(title: "회원가입", message: "아이디가 비어있습니다.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .cancel))
                self.present(alert, animated: true)
                
                return
            }
            
            self.startLoading()
            self.viewModel.idCheck(id: id).subscribe(onCompleted: {
                self.stopLoading()
                if self.viewModel.isIdChecked{
                    let alert = UIAlertController(title: "회원가입", message: "사용하실 수 있는 아이디입니다.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .cancel))
                    self.present(alert, animated: true)
                }
                else{
                    let alert = UIAlertController(title: "회원가입", message: "존재하는 아이디 입니다.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .cancel))
                    self.present(alert, animated: true)
                }
            }, onError: {
                self.stopLoading()
                print($0.localizedDescription)
                let alert = UIAlertController(title: "회원가입", message: "서버 에러", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .cancel))
                self.present(alert, animated: true)
            }).disposed(by: self.disposeBag)
        }).disposed(by: self.disposeBag)
    }
    
    //MARK: 레이아웃 설정
    private func setUpLayout(){
        view.backgroundColor = .white
        
        let title = UILabel().then{
            $0.text = "회원가입"
            $0.textColor = .accentColor
            $0.font = .systemFont(ofSize: 35, weight: .black)
            self.view.addSubview($0)
            
            $0.snp.makeConstraints{
                $0.centerX.equalToSuperview()
                $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(20)
            }
        }
        
        let strikeThroughView = UIView().then{
            $0.backgroundColor = .black
            self.view.addSubview($0)
            
            $0.snp.makeConstraints{
                $0.width.centerX.equalToSuperview()
                $0.height.equalTo(1)
                $0.top.equalTo(title.snp.bottom).offset(20)
            }
        }
        
        let nicknameLabel = UILabel().then{
            $0.text = "아이디"
            $0.font = .systemFont(ofSize: 18, weight: .black)
            self.view.addSubview($0)
            
            $0.snp.makeConstraints{
                $0.top.equalTo(strikeThroughView.snp.bottom).offset(30)
                $0.leading.equalTo(self.view.safeAreaLayoutGuide).offset(20)
            }
        }
        
        idTextField = UITextField().then{
            $0.borderStyle = .roundedRect
            $0.autocorrectionType = .no
            $0.autocapitalizationType = .none
            self.view.addSubview($0)
            
            $0.snp.makeConstraints{
                $0.top.equalTo(nicknameLabel.snp.bottom).offset(10)
                $0.leading.equalTo(nicknameLabel)
            }
        }
        
        idCheckButton = UIButton().then{
            $0.layer.cornerRadius = 5
            $0.backgroundColor = .accentColor
            $0.setTitle("중복확인", for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 13, weight: .regular)
            self.view.addSubview($0)
            
            $0.snp.makeConstraints{
                $0.width.equalTo(70)
                $0.top.height.equalTo(self.idTextField)
                $0.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(20)
                $0.leading.equalTo(self.idTextField.snp.trailing).offset(10)
            }
        }
        
        let passwordLabel = UILabel().then{
            $0.text = "비밀번호"
            $0.font = .systemFont(ofSize: 18, weight: .black)
            self.view.addSubview($0)
            
            $0.snp.makeConstraints{
                $0.top.equalTo(self.idTextField.snp.bottom).offset(20)
                $0.leading.equalTo(nicknameLabel)
            }
        }
        
        passwordTextField = UITextField().then{
            $0.isSecureTextEntry = true
            $0.borderStyle = .roundedRect
            $0.autocorrectionType = .no
            $0.autocapitalizationType = .none
            self.view.addSubview($0)
            
            $0.snp.makeConstraints{
                $0.top.equalTo(passwordLabel.snp.bottom).offset(10)
                $0.leading.equalTo(passwordLabel)
                $0.trailing.equalTo(idCheckButton)
                $0.height.equalTo(self.idTextField.snp.height)
            }
        }
        
        let repeatPasswordLabel = UILabel().then{
            $0.text = "비밀번호 재입력"
            $0.font = .systemFont(ofSize: 18, weight: .black)
            self.view.addSubview($0)
            
            $0.snp.makeConstraints{
                $0.top.equalTo(self.passwordTextField.snp.bottom).offset(20)
                $0.leading.equalTo(nicknameLabel)
            }
        }
        
        repeatPasswordTextField = UITextField().then{
            $0.isSecureTextEntry = true
            $0.borderStyle = .roundedRect
            $0.autocorrectionType = .no
            $0.autocapitalizationType = .none

            self.view.addSubview($0)
            
            $0.snp.makeConstraints{
                $0.top.equalTo(repeatPasswordLabel.snp.bottom).offset(10)
                $0.leading.equalTo(repeatPasswordLabel)
                $0.trailing.equalTo(idCheckButton)
                $0.height.equalTo(self.idTextField.snp.height)
            }
        }
        
        passwordNotMatchLabel = UILabel().then{
            $0.text = "비밀번호와 비밀번호 재입력이 일치하지 않습니다."
            $0.font = .systemFont(ofSize: 15, weight: .black)
            $0.textColor = .red
            $0.isHidden = true
            self.view.addSubview($0)
            
            $0.snp.makeConstraints{
                $0.top.equalTo(self.repeatPasswordTextField.snp.bottom).offset(10)
                $0.leading.equalTo(nicknameLabel)
            }
        }
        
        signUpButton = UIButton().then{
            $0.setTitle("가입하기", for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 25, weight: .regular)
            $0.setTitleColor(.white, for: .normal)
            $0.setTitleColor(.lightGray, for: .disabled)
            $0.titleLabel?.attributedText =  NSMutableAttributedString(string:$0.titleLabel!.text!).then{
                $0.addAttributes([NSAttributedString.Key.kern: 20], range: NSRange(location: 0, length: $0.string.count))
            }
            $0.isEnabled = false
            $0.backgroundColor = .mainColor
            self.view.addSubview($0)
            
            $0.snp.makeConstraints{
                $0.leading.bottom.equalToSuperview()
                $0.height.equalTo(100)
                $0.width.equalTo(self.view.frame.width * 3 / 4)
            }
        }
        
        signUpNextButton = UIButton().then{
            $0.setImage(UIImage(systemName: "greaterthan", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25,weight: .regular, scale: .large))?.withTintColor(.white, renderingMode: .alwaysOriginal),for: .normal)
            $0.backgroundColor = .accentColor
            $0.isEnabled = false
            self.view.addSubview($0)
            
            $0.snp.makeConstraints{
                $0.trailing.bottom.equalToSuperview()
                $0.height.equalTo(signUpButton)
                $0.leading.equalTo(signUpButton.snp.trailing)
            }
        }
        
        loadingView = UIView().then{
            $0.backgroundColor = .black
            $0.layer.opacity = 0.5
            $0.isHidden = true
            self.view.addSubview($0)
            
            $0.snp.makeConstraints{
                $0.top.bottom.left.right.equalToSuperview()
            }
        }
        
        loadingIndicator = UIActivityIndicatorView(style: .large).then{
            $0.isHidden = true
            $0.color = .gray
            loadingView.addSubview($0)
            
            $0.snp.makeConstraints{
                $0.centerX.centerY.equalToSuperview()
            }
        }
    }
    
    private var disposeBag = DisposeBag()
    private var viewModel = SignUpViewModel()
    
    private weak var loadingView: UIView!
    private weak var loadingIndicator: UIActivityIndicatorView!
    
    private weak var idTextField: UITextField!
    private weak var passwordTextField: UITextField!
    private weak var repeatPasswordTextField: UITextField!
    private weak var idCheckButton: UIButton!
    private weak var signUpButton: UIButton!
    private weak var signUpNextButton: UIButton!
    private weak var passwordNotMatchLabel : UILabel!
    
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct SignUpViewRepresntable: UIViewRepresentable{
    typealias UIViewType = UIView
    
    func makeUIView(context: Context) -> UIView {
        SignUpViewController().view
    }
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}

struct SignUpViewController_Previews: PreviewProvider {
    static var previews: some View {
        SignUpViewRepresntable()
    }
}
#endif
