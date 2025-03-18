//
//  BlueOnBordingViewController.swift
//  Tracker
//
//  Created by 1111 on 17.03.2025.
//

import UIKit

final class BlueOnBoardingViewController: UIViewController {
    private let label: UILabel = UILabel()
    private let button: UIButton = UIButton()
    private var backImage: UIImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackImage()
        setLabel()
        setButton()
        setConstraints()
    }
    
    private func setBackImage() {
        guard let image = UIImage(named: "BlueOnBoarding") else { return }
        backImage.image = image
        backImage.contentMode = .scaleAspectFit
        
        backImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backImage)
    }
    
    private func setLabel() {
        label.text = "Отслеживайте только\n то, что хотите"
        label.font = .systemFont(ofSize: 32, weight: UIFont.Weight.bold)
        label.textAlignment = .center
        label.numberOfLines = 2
        
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
    }
    
    private func setButton() {
        button.backgroundColor = .black
        button.layer.cornerRadius = 16
        button.setTitle("Вот это технологии!", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: UIFont.Weight.medium)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.textColor = .white
        
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        button.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
    }
    
    @objc private func didTapAddButton() {
        // Записываем в переменную isThisNotFirstLoad(лежит в SceneDelegate), что онбординг случился
        UserDefaults.standard.set(true, forKey: "IsThisNotFirstLoad")
        
        let tabBarViewController = TabBarController()
        tabBarViewController.modalPresentationStyle = .fullScreen
        present(tabBarViewController, animated: false)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            backImage.topAnchor.constraint(equalTo: view.topAnchor),
            backImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            label.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -270),
            
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant:  -50),
            button.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
