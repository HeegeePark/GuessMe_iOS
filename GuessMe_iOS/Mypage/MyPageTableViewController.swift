//
//  MyPageViewController.swift
//  GuessMe_iOS
//
//  Created by 유호준 on 2022/01/07.
//

import Foundation
import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

class MyPageTableViewController : UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setLayout()
    }
    
    // 탭바 연결
    static func instance() -> UINavigationController {
        let mypageVC = MyPageTableViewController(nibName: nil, bundle: nil).then {
            $0.tabBarItem = UITabBarItem(
                title: "마이페이지",
                image: UIImage(systemName: "person.circle"),
                tag: tabBarTag.mypage.rawValue)
        }
        
        return UINavigationController(rootViewController: mypageVC).then {
            $0.setNavigationBarHidden(true, animated: false)
        }
    }
    
    
    //MARK: - Private
    
    //MARK: - 테이블 뷰 설정
    private func setTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MyPageTableViewCell.self, forCellWithReuseIdentifier: "cell")
        
    }
    
    //MARK: - 레이아웃 설정
    private func setLayout(){
        view.backgroundColor = .white
        
        menuButton = UIButton().then{
            let img = UIImage(cgImage:UIImage(systemName: "ellipsis", withConfiguration: UIImage.SymbolConfiguration(pointSize: 10, weight: .bold, scale: .medium))!.cgImage!, scale: 1 , orientation: .left).withTintColor(.accentColor!, renderingMode: .alwaysOriginal)
            $0.setImage(img, for: .normal)
            self.view.addSubview($0)
            
            $0.snp.makeConstraints{
                $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(20)
                $0.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(35)
            }
        }
        
        let title = UILabel().then{
            $0.text = "이땡님의 퀴즈 순위"
            $0.font = .systemFont(ofSize: 40, weight: .bold)
            $0.textColor = .accentColor
            self.view.addSubview($0)
            
            $0.snp.makeConstraints{
                $0.centerX.equalToSuperview()
                $0.top.equalTo(self.menuButton.snp.bottom).offset(30)
            }
        }
        
        self.view.addSubview(tableView)
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        tableView.snp.makeConstraints{
            $0.top.equalTo(title.snp.bottom).offset(30)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
    }
    
    fileprivate let tableView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private weak var menuButton : UIButton!
}

extension MyPageTableViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 70, height: 80)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Rank.getDummy().count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 25
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("test")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyPageTableViewCell
        let rank = Rank.getDummy()[indexPath.row]
        cell.bind(rank: rank)

        
        return cell
    }
}
#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct MyPageTableViewRepresentable: UIViewRepresentable{
    typealias UIViewType = UIView
    private let viewController = MyPageTableViewController()
    func makeUIView(context: Context) -> UIView {
        return viewController.view
    }
    func updateUIView(_ uiView: UIView, context: Context) {
        viewController.tableView.reloadData()
    }
}

struct MyPageView_Previews: PreviewProvider{
    static var previews: some View{
        MyPageTableViewRepresentable()
    }
}
#endif
