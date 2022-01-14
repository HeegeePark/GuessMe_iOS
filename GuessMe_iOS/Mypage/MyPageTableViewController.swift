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
        setUp()
    }
    override func viewWillDisappear(_ animated: Bool) {
        disposeBag = DisposeBag()
        viewModel.disposeBag = DisposeBag()
    }
    //MARK: -  탭바 연결
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
    
    //MARK: - setUp
    private func setUp(){
        setLayout()
        setMenuButton()
    }
    //MARK: - 메뉴 버튼 설정
    private func setMenuButton(){
        menuButton.rx.tap.observeOn(MainScheduler.instance).subscribe(onNext:{
            let alert = UIAlertController()
            alert.addAction(UIAlertAction(title: "퀴즈 삭제", style: .default, handler: {_ in
                self.viewModel.deleteQuiz().observeOn(MainScheduler.instance).subscribe(onCompleted: {
                    let alert = UIAlertController(title: "내 정보", message: "퀴즈 삭제 성공", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: {_ in
                        let vc = QuizViewController()
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc,animated: true, completion: {
                            self.presentingViewController?.dismiss(animated: true)
                        })
                        self.present(alert, animated: true)
                    }))
                }, onError: {
                    print($0.localizedDescription)
                    let alert = UIAlertController(title: "내 정보", message: "서버 에러", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .cancel))
                    self.present(alert, animated: true)
                    
                }).disposed(by: self.disposeBag)
            }))
            alert.addAction(UIAlertAction(title: "로그아웃", style: .default, handler: {_ in
                UserDefaults.standard.removeObject(forKey: "token")
                UserDefaults.standard.removeObject(forKey: "nickname")
                self.presentingViewController?.dismiss(animated: true)
            }))
            alert.addAction(UIAlertAction(title: "닫기", style: .cancel))
            
            self.present(alert,animated: true)
        }).disposed(by: self.disposeBag)
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
            let nickname = UserDefaults.standard.string(forKey: "id")
            $0.text = "\(nickname!)의 퀴즈 순위"
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
    
    private let viewModel = MyPageViewModel()
    private var disposeBag = DisposeBag()
    fileprivate lazy var tableView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then{
        $0.delegate = self
        $0.dataSource = self
        $0.register(MyPageTableViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    private weak var menuButton : UIButton!
}

extension MyPageTableViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 70, height: 80)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.rankList.capacity
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 25
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyPageTableViewCell
        let rank = self.viewModel.rankList[indexPath.row]
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
