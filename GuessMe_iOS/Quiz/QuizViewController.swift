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
        setTableView()
        setUpLayout()
    }
    
    // MARK: - Properties
    private let id: String = "희지"
    private var quizType: QuizType = .create("희지")
    private let viewModel = QuizViewModel()
    private let disposeBag = DisposeBag()
    
    fileprivate let tableView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private weak var titleLabel: UILabel!
    private weak var descriptionLabel: UILabel!
    private weak var submitButton: UIButton!
    
    // MARK: - Actions
    private func bindViewModel() {
        self.viewModel.input
            .quizType
            .bind(onNext: self.setQuizType(type:))
            .disposed(by: disposeBag)
    }
    
    private func setQuizType(type: QuizType) {
        self.quizType = type
    }
    
    private func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
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
            $0.text = self.quizType.title
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
            $0.text = self.quizType.description
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
            $0.setTitle(self.quizType.buttonText, for: .normal)
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
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.snp.makeConstraints {
            $0.top.equalTo(self.descriptionLabel.snp.bottom).offset(110)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.submitButton.snp.top).inset(UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0))
        }
    }
}

// MARK: - CollectionView Extension
extension QuizViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 60, height: 65)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Quiz.getDummy().count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "quizCell", for: indexPath) as! QuizTableViewCell
        let quiz = Quiz.getDummy()[indexPath.row]
        cell.bind(quiz: quiz)

        return cell
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
