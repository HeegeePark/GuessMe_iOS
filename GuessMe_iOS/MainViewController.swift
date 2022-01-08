//
//  ViewController.swift
//  GuessMe_iOS
//
//  Created by 박희지 on 2022/01/05.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Then

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
//        setEnterButton()
    }
    
    // MARK: - UI Components
    private weak var searchTextfield: UITextField!
    private weak var searchButton: UIButton!
    
    private let viewModel = MainViewModel()
    private let disposeBag = DisposeBag()
    
    
    // 탭바 (일단 보류)
//    static func instance() -> UINavigationController {
//        let mainVC = MainViewController(nibName: nil, bundle: nil).then {
//            $0.tabBarItem = UITabBarItem(
//                title: "퀴즈",
//                image: UIImage(named: "questionmark"),
//                tag: 1)
//        }
//    }
    
    // MARK: - Actions
    private func bindViewModel() {
        // bind input
        self.searchTextfield.rx.text.orEmpty
            .bind(to: self.viewModel.input.nickName)
            .disposed(by: disposeBag)
        
        self.searchButton.rx.tap
            .bind(to: self.viewModel.input.tapButton)
            .disposed(by: disposeBag)
        
        // bind output
        self.viewModel.output
            .showErrorAlert
            .bind(onNext: self.showErrorAlert)
            .disposed(by: disposeBag)
    }
    
    private func showErrorAlert() {
        // 에러 알럿
    }

    // MARK: - 레이아웃 설정
    private func setUpLayout() {
        // 로고
        _ = UIImageView().then {
            $0.image = #imageLiteral(resourceName: "img_main_title")
            self.view.addSubview($0)
            
            $0.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.width.equalTo(260)
                $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(70)
            }
        }
        
        // 검색 텍스트필드
        searchTextfield = UITextField().then {
            $0.layer.borderColor  = UIColor.mainColor?.cgColor
            $0.layer.borderWidth = 3
            $0.layer.cornerRadius = 17
            $0.placeholder = "Search"
            $0.font = .systemFont(ofSize: 12, weight: .regular)
            $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: $0.frame.height))
            $0.leftViewMode = .always
            self.view.addSubview($0)

            $0.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalToSuperview().offset(10)
            }
        }
        
        // 텍스트필드의 돋보기 이미지
        _ = UIImageView().then {
            $0.image = UIImage(named: "icon_main_search")
            $0.contentMode = .scaleAspectFit
            self.view.addSubview($0)

            $0.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalTo(self.searchTextfield.snp.leading).offset(12)
            }
        }
        
        // 설명 레이블
        _ = UILabel().then {
            $0.text = "풀고싶은 퀴즈의 닉네임을 입력해주세요."
            $0.textColor = .accentColor
            $0.font = .systemFont(ofSize: 16, weight: .bold)
            self.view.addSubview($0)

            $0.snp.makeConstraints {
                $0.top.equalTo(self.searchTextfield.snp.top).inset(UIEdgeInsets(top:-25, left: 0, bottom: 0, right: 0))
                $0.leading.equalTo(self.searchTextfield.snp.leading).offset(20)
            }
        }
        
        // 검색 버튼
        searchButton = UIButton().then {
            $0.layer.cornerRadius = 7
            $0.backgroundColor = .mainColor
            $0.setTitle("Enter", for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
            $0.titleLabel?.textColor = .white
            self.view.addSubview($0)

            $0.snp.makeConstraints {
                $0.width.equalTo(50)
                $0.height.equalTo(self.searchTextfield)
                $0.top.equalTo(self.searchTextfield)
                $0.leading.equalTo(self.searchTextfield.snp.trailing).offset(5)
                $0.trailing.equalToSuperview().inset(10)
            }
        }
    }
}

//MARK: - Preview
#if canImport(SwiftUI) &&  DEBUG
import SwiftUI
@available(iOS 13.0, *)
struct MainViewRepresentable: UIViewRepresentable {
    typealias UIViewType = UIView
    
    func makeUIView(context: Context) -> UIView {
        MainViewController().view
    }
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}

struct LoggedOutViewPreview: PreviewProvider {
    static var previews: some View {
        MainViewRepresentable().previewLayout(.sizeThatFits).previewInterfaceOrientation(.portraitUpsideDown)
    }
}
#endif
