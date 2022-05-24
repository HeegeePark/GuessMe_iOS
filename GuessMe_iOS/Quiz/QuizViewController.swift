//
//  QuizViewController.swift
//  GuessMe_iOS
//
//  Created by 박희지 on 2022/01/09.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Then

class QuizViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.refreshControl = UIRefreshControl()
        setTableView()
        setUpLayout()
        bindViewModel()
    }
    
    // MARK: - Properties
    private let viewModel = QuizViewModel()
    private let id: String = UserDefaults.standard.string(forKey: "id")! /*"희지"*/
    private let disposeBag = DisposeBag()
    
    fileprivate let tableView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private weak var titleLabel: UILabel!
    private weak var descriptionLabel: UILabel!
    private weak var submitButton: UIButton!
    
    // MARK: - Bindings
    private func bindViewModel() {
        // bind input
//        self.viewModel.input
//            .quizObservable
//            .observeOn(MainScheduler.instance)
//            .bind(to: self.tableView.rx.items(cellIdentifier: "quizCell",
//                                              cellType: QuizTableViewCell.self)) { _, item, cell in
//                cell.bind(quiz: item)
//                cell.onSelect = { [weak self] selected in
//                    self?.viewModel.selectAnswer(item: item, selected: selected)
//                }
//            }
//            .disposed(by: disposeBag)
        
        self.viewModel.input
            .quizObservable
            .observeOn(MainScheduler.instance)
            .bind(to: self.tableView.rx.items(cellIdentifier: "quizCell",
                                              cellType: QuizTableViewCell.self)) { _, item, cell in
                cell.bind(quiz: item)
                cell.onSelect = { [weak self] selected in
                    self?.viewModel.selectAnswer(item: item, selected: selected)
                }
            }
            .disposed(by: disposeBag)
        
        self.submitButton.rx.tap
            .subscribe(onNext: {
                self.viewModel.input.tapSubmitButton
                    .onNext(self.id)
                self.presentNextVC()
            })
            .disposed(by: self.disposeBag)
        
        // bind output
        self.viewModel.output
            .showErrorAlert
            .bind(onNext: showErrorAlert)
            .disposed(by: self.disposeBag)
    }
    
    // MARK: - Actions
    private func presentNextVC() {
        let mainVC = TabBarController()
        mainVC.modalPresentationStyle = .fullScreen
        self.present(mainVC, animated: false)
    }
    
    private func showErrorAlert() {
        let alert = UIAlertController(title: "실패", message: "서버 에러", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .cancel))
        self.present(alert, animated: true)
    }
    
    private func setTableView() {
        tableView.delegate = self
        tableView.dataSource = nil
        tableView.register(QuizTableViewCell.self, forCellWithReuseIdentifier: "quizCell")
    }
    
    // MARK: - 레이아웃 설정
    private func setUpLayout() {
        // 배경 이미지
        _ = UIImageView().then {
            $0.image = #imageLiteral(resourceName: "img_quiz_bg.png")
            self.view.addSubview($0)

            $0.snp.makeConstraints {
                $0.left.top.right.bottom.equalToSuperview()
            }
        }
        
        // 타이틀 레이블
        titleLabel = UILabel().then {
            $0.text = self.viewModel.quizType.title
            $0.textColor = .whiteColor
            $0.font = .systemFont(ofSize: 21, weight: .bold)
            self.view.addSubview($0)
            
            $0.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalToSuperview().inset(50)
            }
        }
        
        // 설명 레이블
        descriptionLabel = UILabel().then {
            $0.text = self.viewModel.quizType.description
            $0.textColor = .whiteColor
            $0.font = .systemFont(ofSize: 13, weight: .bold)
            $0.numberOfLines = 2
            $0.textAlignment = .center
            self.view.addSubview($0)
            
            $0.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(self.titleLabel.snp.bottom).offset(10)
            }
        }
        
        // 제출 버튼
        submitButton = UIButton().then {
            $0.backgroundColor = .mainColor
            $0.layer.cornerRadius = 20
            $0.setTitle(self.viewModel.quizType.buttonText, for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
            $0.titleLabel?.textColor = .whiteColor
            $0.titleLabel?.textAlignment = .center
            self.view.addSubview($0)

            $0.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.width.equalTo(self.view.frame.width - 94)
                $0.height.equalTo(50)
                $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(20)
            }
        }
        
        // 테이블 뷰
        self.view.addSubview(tableView)
        tableView.backgroundColor = .whiteColor
        tableView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 30, right: 20)
        tableView.snp.makeConstraints {
            $0.top.equalTo(self.descriptionLabel.snp.bottom).offset(110)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.submitButton.snp.top).inset(UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0))
        }
    }
}

// MARK: - CollectionView Extension
extension QuizViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 60, height: 65)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
}

//MARK: - Preview
#if canImport(SwiftUI) &&  DEBUG
import SwiftUI
@available(iOS 13.0, *)
struct QuizViewRepresentable: UIViewRepresentable {
    typealias UIViewType = UIView
    var VC = QuizViewController()
    
    func makeUIView(context: Context) -> UIView {
        return VC.view
    }
    func updateUIView(_ uiView: UIView, context: Context) {
        VC.tableView.reloadData()
    }
}

struct QuizViewPreview: PreviewProvider {
    static var previews: some View {
        QuizViewRepresentable().previewLayout(.sizeThatFits).previewInterfaceOrientation(.portraitUpsideDown)
    }
}
#endif
