//
//  QuizTableViewCell.swift
//  GuessMe_iOS
//
//  Created by 박희지 on 2022/01/09.
//

import Foundation
import UIKit
import SnapKit
import Then

class QuizTableViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayout()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Properties
    var answer = 0
    
    private weak var quizLabel: UILabel!
    private weak var yesButton: UIButton!
    private weak var noButton: UIButton!
    
    // MARK: - 데이터 바인딩
    public func bind(quiz: Quiz){
        quizLabel.text = quiz.content
    }
    
    // MARK: - 레이아웃 설정
    private func setUpLayout() {
        // 셀 테두리 및 그림자
        backgroundColor = .white
        layer.cornerRadius = 8
        layer.shadowOpacity = 0.7
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        
        // 퀴즈 레이블
        quizLabel = UILabel().then {
            $0.textColor = .blackColor
            $0.font = .systemFont(ofSize: 11, weight: .regular)
            self.contentView.addSubview($0)
            
            $0.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalToSuperview().offset(10)
            }
        }
        
        // O 버튼
        yesButton = UIButton().then {
            $0.setImage(UIImage(named: "icon_quiz_inactiveO"), for: .normal)
            $0.setImage(UIImage(named: "icon_quiz_activeO"), for: .selected)
            
            $0.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.trailing.equalTo(self.noButton.snp.leading).offset(-10)
            }
        }
        
        // X 버튼
        noButton = UIButton().then {
            $0.setImage(UIImage(named: "icon_quiz_inactiveX"), for: .normal)
            $0.setImage(UIImage(named: "icon_quiz_activeX"), for: .selected)
            
            $0.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.trailing.equalToSuperview().inset(10)
            }
        }
    }
}
