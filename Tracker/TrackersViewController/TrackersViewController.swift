//
//  ViewController.swift
//  Tracker
//
//  Created by 1111 on 30.01.2025.
//

import UIKit

final class TrackersViewController: UIViewController {
    private let date: Date = Date()
    
    private var categories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    private var addNewTrackerButton: UIButton = UIButton()
    private var dateLabel: UILabel = UILabel()
    private var titleLabel: UILabel = UILabel()
    private var backgroundImage: UIImageView = UIImageView()
    private var backgroundTextLabel: UILabel = UILabel()
    private var searchBar: UISearchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        createAddNewTrackerButton()
        createDateLabel()
        createTitleLabel()
        createSearchBar()
        createBackgroundImage()
        createBackgroundTextLabel()
    }
    
    private func createAddNewTrackerButton() {
        guard let imageButton = UIImage(named: "Add_button") else { return }
        addNewTrackerButton = UIButton.systemButton(with: imageButton, target: self, action: #selector(Self.didTapButton))
        addNewTrackerButton.tintColor = .black
        addNewTrackerButton.contentMode = .center
        
        addNewTrackerButton.translatesAutoresizingMaskIntoConstraints = false
                self.view.addSubview(addNewTrackerButton)
        addNewTrackerButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 6).isActive = true
        addNewTrackerButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 1).isActive = true
        addNewTrackerButton.widthAnchor.constraint(equalToConstant: 42).isActive = true
        addNewTrackerButton.heightAnchor.constraint(equalToConstant: 42).isActive = true
    }
    
    private func createDateLabel() {
        dateLabel.text = date.dateTimeString
        dateLabel.textColor = .black
        dateLabel.font = .systemFont(ofSize: 17)
        dateLabel.textAlignment = .center
        dateLabel.backgroundColor = UIColor(named: "Date_background_color")
        dateLabel.layer.cornerRadius = 8
        dateLabel.layer.masksToBounds = true

        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(dateLabel)
        dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        dateLabel.centerYAnchor.constraint(equalTo: addNewTrackerButton.centerYAnchor).isActive = true
        dateLabel.widthAnchor.constraint(equalToConstant: 77).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 34).isActive = true
    }
    
    private func createTitleLabel() {
        titleLabel.text = "Трекеры"
        titleLabel.textColor = .black
        titleLabel.font = .boldSystemFont(ofSize: 34)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        titleLabel.topAnchor.constraint(equalTo: addNewTrackerButton.bottomAnchor, constant: 1).isActive = true
    }
    
    private func createBackgroundImage() {
        guard let backgroundImage = UIImage(named: "Background_image") else { return }
        self.backgroundImage.image = backgroundImage
        
        self.backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.backgroundImage)
        self.backgroundImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.backgroundImage.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    
    private func createBackgroundTextLabel() {
        backgroundTextLabel.text = "Что будем отслеживать?"
        backgroundTextLabel.textColor = .black
        backgroundTextLabel.font = .systemFont(ofSize: 12, weight: UIFont.Weight(rawValue: 510))
        
        backgroundTextLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(backgroundTextLabel)
        backgroundTextLabel.topAnchor.constraint(equalTo: backgroundImage.bottomAnchor, constant: 8).isActive = true
        backgroundTextLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    private func createSearchBar() {
        searchBar.placeholder = "Поиск"
        searchBar.searchBarStyle = .minimal
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(searchBar)
        searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
    }
    
    @objc private func didTapButton() {
    }
}
