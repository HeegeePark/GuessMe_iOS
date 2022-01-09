//
//  MyPageTableViewCell.swift
//  GuessMe_iOS
//
//  Created by 유호준 on 2022/01/07.
//

import Foundation
import UIKit
import Then
import SnapKit
class MyPageTableViewCell: UICollectionViewCell{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    //MARK: - 데이터 바인딩
    public func bind(rank: Rank){
        nicknameLabel.text = rank.nickname
        rankLabel.text = "\(rank.rank)"
        scoreLabel.text = "\(rank.score)"
    }
    
    //MARK: - 레이아웃 설정
    private func setLayout(){
        backgroundColor = .white
        layer.cornerRadius = 8
        layer.shadowOpacity = 0.7
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        

        rankLabel = UILabel().then{
            $0.textColor = .blueColor
            $0.font = .systemFont(ofSize: 40, weight: .bold)
            self.contentView.addSubview($0)
            
            $0.snp.makeConstraints{
                $0.centerY.equalToSuperview()
                $0.leading.equalToSuperview().offset(20)
            }
        }
        
        nicknameLabel = UILabel().then{
            $0.textColor = .gray
            $0.font = .systemFont(ofSize: 25, weight: .black)
            self.contentView.addSubview($0)
            
            $0.snp.makeConstraints{
                $0.centerX.centerY.equalToSuperview()
            }
        }
        
        scoreLabel = UILabel().then{
            $0.textColor = .lightBlueColor
            $0.font = .systemFont(ofSize: 35, weight: .semibold)
            self.contentView.addSubview($0)
            
            $0.snp.makeConstraints{
                $0.centerY.equalToSuperview()
                $0.trailing.equalToSuperview().inset(20)
            }
        }
    }
    
    private weak var rankLabel: UILabel!
    private weak var nicknameLabel: UILabel!
    private weak var scoreLabel: UILabel!
}


#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct MyPageTableViewCellRepresentable: UIViewRepresentable{
    typealias UIViewType = UIView
    
    func makeUIView(context: Context) -> UIView {
        let cell = MyPageTableViewCell()
        cell.bind(rank: Rank.getDummy()[0])
        return cell
    }
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}

struct MyPageTableViewCell_Previews: PreviewProvider{
    static var previews: some View{
        MyPageTableViewCellRepresentable()
    }
}
#endif
