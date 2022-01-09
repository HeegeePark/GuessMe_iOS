//
//  LoginViewController.swift
//  GuessMe_iOS
//
//  Created by 유호준 on 2022/01/06.
//

import Foundation
import UIKit
import SnapKit
import RxCocoa
import RxSwift
import Then
class LoginViewController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUp()
        viewModel = LoginViewModel()
        if let _ = UserDefaults.standard.string(forKey: "token"){
            self.startLoading()
            self.nextViewPresent()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        disposeBag = DisposeBag()
        viewModel.disposeBag = DisposeBag()
    }
    //MARK: - Private
    
    //MARK: - 다음 화면 전환
    private func nextViewPresent(){
        self.viewModel.isUserHasQuiz().observeOn(MainScheduler.instance).subscribe(onSuccess: {
            var vc: UIViewController
            if $0{//퀴즈를 가지고 있을 때
                vc = TabBarController()
                
            }
            else{
                vc = QuizViewController()
            }
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true){
                if self.loadingIndicator.isAnimating{
                    self.stopLoading()
                }
            }
        }, onError: {
            print($0.localizedDescription)
            let alert = UIAlertController(title: "로그인", message: "서버 에러", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel))
            self.present(alert, animated: true)
        }).disposed(by: self.disposeBag)
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
    //MARK: - setUp
    private func setUp(){
        setLayout()
        setLoginButton()
        setSignUpLabel()
    }
    
    //MARK: - 회원가입 Label 설정
    @objc
    private func tapSignUpLabel(){
        let signUpVC = SignUpViewController()
        signUpVC.modalPresentationStyle = .fullScreen
        present(signUpVC, animated: true)
    }
    private func setSignUpLabel(){
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapSignUpLabel))
        signUpLabel.isUserInteractionEnabled = true
        signUpLabel.addGestureRecognizer(gesture)

    }

    //MARK: - 로그인 버튼 설정
    private func setLoginButton(){
        loginButton.rx.tap.observeOn(MainScheduler.instance).subscribe(onNext:{
            
            guard let id = self.idTextField.text , !id.isEmpty else{
                let alert = UIAlertController(title: "로그인", message: "아이디가 비어있습니다.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .cancel))
                self.present(alert, animated: true)
                return
            }
            
            guard let password = self.passwordTextField.text, !password.isEmpty else{
                let alert = UIAlertController(title: "로그인", message: "비밀번호가 비어있습니다.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .cancel))
                self.present(alert, animated: true)
                return
            }
            
            self.startLoading()
            self.viewModel.login(id:id, password: password).subscribe(onSuccess: {
                if $0{
                    self.nextViewPresent()
                }
                else{
                    self.stopLoading()
                    let alert = UIAlertController(title: "로그인", message: "아이디 혹은 비밀번호가 맞지 않습니다.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .cancel))
                    self.present(alert, animated: true)
                }
            }, onError: {
                self.stopLoading()
                print($0.localizedDescription)
                let alert = UIAlertController(title: "로그인", message: "서버 에러", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .cancel))
                self.present(alert, animated: true)
            }).disposed(by: self.disposeBag)
        }).disposed(by: self.disposeBag)
        
        //로그인 버튼 터치 시
        loginButton.rx.controlEvent(.touchDown).observeOn(MainScheduler.instance).subscribe(onNext:{
            UIView.animate(withDuration: 0.3){
                var hue:CGFloat = 0,saturation:CGFloat = 0,brightness:CGFloat = 0,alpha:CGFloat = 0
                UIColor.accentColor?.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)

                self.loginButton.backgroundColor = UIColor(hue: hue, saturation: saturation, brightness:0.8  * brightness, alpha: alpha)
                self.loginButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }
        }).disposed(by: self.disposeBag)

        //로그인 버튼에서 터치를 뗏을 시
        let touchUpOutside = loginButton.rx.controlEvent(.touchUpOutside).map{()}
        let touchUpinside = loginButton.rx.controlEvent(.touchUpInside).map{()}

        Observable.merge(touchUpOutside,touchUpinside).observeOn(MainScheduler.instance).subscribe(onNext: {
            UIView.animate(withDuration: 0.3){
                self.loginButton.backgroundColor = .accentColor
                self.loginButton.transform = CGAffineTransform.identity
            }
        }).disposed(by: self.disposeBag)
    }

    //MARK: - 레이아웃 설정
    private func setLayout(){
        view.backgroundColor = .mainColor
        _ = UIImageView().then{
            $0.image = #imageLiteral(resourceName: "img_login_title")
            self.view.addSubview($0)

            $0.snp.makeConstraints{
                $0.centerX.equalToSuperview()
                $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(70)
            }
        }

        self.loginButton = UIButton().then{
            $0.backgroundColor = .accentColor
            $0.layer.cornerRadius = 20
            $0.setTitle("로그인", for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
            self.view.addSubview($0)

            $0.snp.makeConstraints{
                $0.centerY.equalToSuperview()
                $0.height.width.equalTo(110)
                $0.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).inset(20)
            }
        }

        _ = UILabel().then{
            $0.text = "나는 퀴즈를 낼테니 넌 퀴즈를 맞춰라"
            $0.textColor = .white
            $0.font = .systemFont(ofSize: 15, weight: .regular)
            self.view.addSubview($0)

            $0.snp.makeConstraints{
                $0.top.equalTo(self.loginButton.snp.top).inset(UIEdgeInsets(top:-25	, left: 0, bottom: 0, right: 0))
                $0.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(35)
            }
        }

        self.idTextField = UITextField().then{
            $0.backgroundColor = .white
            $0.autocorrectionType = .no
            $0.autocapitalizationType = .none
            $0.placeholder = "ID"
            $0.layer.borderColor  = UIColor.gray.cgColor
            $0.layer.cornerRadius = 25
            $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: $0.frame.height))
            $0.leftViewMode = .always
            self.view.addSubview($0)

            $0.snp.makeConstraints{
                $0.top.equalTo(self.loginButton.snp.top)
                $0.height.equalTo(50)
                $0.leading.equalTo(20)
                $0.trailing.equalTo(self.loginButton.snp.leading).inset(UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0))
            }
        }

        self.passwordTextField = UITextField().then{
            $0.backgroundColor = .white
            $0.placeholder = "PASSWORD"
            $0.autocorrectionType = .no
            $0.autocapitalizationType = .none
            $0.layer.borderColor  = UIColor.gray.cgColor
            $0.layer.cornerRadius = 25
            $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: $0.frame.height))
            $0.leftViewMode = .always
            $0.isSecureTextEntry = true
            self.view.addSubview($0)

            $0.snp.makeConstraints{
                $0.top.equalTo(self.idTextField.snp.bottom).offset(10)
                $0.height.equalTo(50)
                $0.leading.equalTo(20)
                $0.trailing.equalTo(self.loginButton.snp.leading).inset(UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0))
            }
        }

        let bottomLabel = UILabel().then{
            $0.text = "아직 회원이 아니신가요?"
            $0.textColor = .white
            $0.font = .systemFont(ofSize: 15, weight: .medium)
            self.view.addSubview($0)

            $0.snp.makeConstraints{
                $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(20)
                $0.centerX.equalToSuperview().offset(-30)
            }
        }

        signUpLabel = UILabel().then{
            $0.text = "회원가입"
            $0.textColor = .darkPinkColor
            $0.font = .systemFont(ofSize: 15, weight: .bold)
            self.view.addSubview($0)

            $0.snp.makeConstraints{
                $0.bottom.equalTo(bottomLabel.snp.bottom)
                $0.leading.equalTo(bottomLabel.snp.trailing).offset(10)
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
    private var viewModel = LoginViewModel()
    
    private weak var loadingView: UIView!
    private weak var loadingIndicator: UIActivityIndicatorView!
    
    private weak var signUpLabel: UILabel!
    private weak var idTextField: UITextField!
    private weak var passwordTextField: UITextField!
    private weak var loginButton: UIButton!
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct LoginViewRepresentable: UIViewRepresentable{
    func makeUIView(context: Context) -> UIView {
        LoginViewController().view
    }

    func updateUIView(_ uiView: UIView, context: Context) {

    }

    typealias UIViewType = UIView



}

struct LoginViewController_Previews: PreviewProvider{
    static var previews: some View{
        LoginViewRepresentable()
    }
}
#endif



