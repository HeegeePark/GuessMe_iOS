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
        setUpLayout()
    }
    
    //MARK: - Private
    private func setUpLayout(){
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
                $0.width.equalToSuperview()
                $0.height.equalTo(1)
                $0.centerX.equalToSuperview()
                $0.top.equalTo(title.snp.bottom).offset(20)
            }
        }
        
        let nicknameLabel = UILabel().then{
            $0.text = "닉네임"
            $0.font = .systemFont(ofSize: 18, weight: .black)
            self.view.addSubview($0)
            
            $0.snp.makeConstraints{
                $0.top.equalTo(strikeThroughView.snp.bottom).offset(30)
                $0.leading.equalTo(self.view.safeAreaLayoutGuide).offset(20)
            }
        }
        
        nicknameTextField = UITextField().then{
            $0.borderStyle = .roundedRect
            self.view.addSubview($0)
            
            $0.snp.makeConstraints{
                $0.top.equalTo(nicknameLabel.snp.bottom).offset(10)
                $0.leading.equalTo(nicknameLabel)
            }
        }
        
        nicknameCheckButton = UIButton().then{
            $0.layer.cornerRadius = 5
            $0.backgroundColor = .accentColor
            $0.setTitle("중복확인", for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 13, weight: .regular)
            self.view.addSubview($0)
            
            $0.snp.makeConstraints{
                $0.width.equalTo(70)
                $0.height.equalTo(self.nicknameTextField)
                $0.top.equalTo(self.nicknameTextField)
                $0.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(20)
                $0.leading.equalTo(self.nicknameTextField.snp.trailing).offset(10)
            }
        }
        
        let passwordLabel = UILabel().then{
            $0.text = "비밀번호"
            $0.font = .systemFont(ofSize: 18, weight: .black)
            self.view.addSubview($0)
            
            $0.snp.makeConstraints{
                $0.top.equalTo(nicknameTextField.snp.bottom).offset(20)
                $0.leading.equalTo(nicknameLabel)
            }
        }
        
        passwordTextField = UITextField().then{
            $0.isSecureTextEntry = true
            $0.borderStyle = .roundedRect
            self.view.addSubview($0)
            
            $0.snp.makeConstraints{
                $0.top.equalTo(passwordLabel.snp.bottom).offset(10)
                $0.leading.equalTo(passwordLabel)
                $0.trailing.equalTo(nicknameCheckButton)
                $0.height.equalTo(nicknameTextField.snp.height)
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
            self.view.addSubview($0)
            
            $0.snp.makeConstraints{
                $0.top.equalTo(repeatPasswordLabel.snp.bottom).offset(10)
                $0.leading.equalTo(repeatPasswordLabel)
                $0.trailing.equalTo(nicknameCheckButton)
                $0.height.equalTo(nicknameTextField.snp.height)
            }
        }
        
        passwordNotMatchLabel = UILabel().then{
            $0.text = "비밀번호와 비밀번호 재입력이 일치하지 않습니다."
            $0.font = .systemFont(ofSize: 15, weight: .black)
            $0.textColor = .red
//            $0.isHidden = true
            self.view.addSubview($0)
            
            $0.snp.makeConstraints{
                $0.top.equalTo(self.repeatPasswordTextField.snp.bottom).offset(10)
                $0.leading.equalTo(nicknameLabel)
            }
        }
    }
    
    private weak var nicknameTextField: UITextField!
    private weak var passwordTextField: UITextField!
    private weak var repeatPasswordTextField: UITextField!
    private weak var nicknameCheckButton: UIButton!
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
