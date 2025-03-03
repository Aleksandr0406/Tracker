//
//  NewScheduleViewController.swift
//  Tracker
//
//  Created by 1111 on 15.02.2025.
//

import UIKit

final class NewScheduleViewController: UIViewController {
    var onDoneButtonTapped: (([String]) -> ())?
    private var savedDaysNames: [String] = []
    
    private let days: [String] =
    [
        "Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"
    ]
    
    private var doneButton: UIButton = UIButton()
    
    private var scheduleTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(NewScheduleTableViewCell.self, forCellReuseIdentifier: NewScheduleTableViewCell.cellIdentifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setBarItem()
        createDoneButton()
        createScheduleTableView()
        setConstraints()
    }
    
    private func setBarItem() {
        navigationItem.title = "Расписание"
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
        navigationController?.navigationBar.titleTextAttributes = attributes
    }
    
    private func createDoneButton() {
        doneButton.backgroundColor = .black
        doneButton.setTitle("Готово", for: .normal)
        doneButton.setTitleColor(UIColor.white, for: .normal)
        doneButton.layer.cornerRadius = 16
        
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(doneButton)
        
        doneButton.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
    }
    
    @objc private func didTapDoneButton() {
        guard let onDoneButtonTapped = onDoneButtonTapped else { return }
        onDoneButtonTapped(savedDaysNames)
        dismiss(animated: true)
    }
    
    private func createScheduleTableView() {
        scheduleTableView.backgroundColor = UIColor(named: "E6E8EB")
        scheduleTableView.layer.cornerRadius = 16
        
        scheduleTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scheduleTableView)
        
        scheduleTableView.dataSource = self
        scheduleTableView.delegate = self
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 60),
            
            scheduleTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            scheduleTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scheduleTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scheduleTableView.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: -47)
        ])
    }
}

extension NewScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.bounds.height / 7
    }
}

extension NewScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        days.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        
        if let newSсheduleCell = tableView.dequeueReusableCell(withIdentifier: NewScheduleTableViewCell.cellIdentifier, for: indexPath) as? NewScheduleTableViewCell {
            cell = newSсheduleCell
        } else {
            cell = UITableViewCell(style: .default, reuseIdentifier: NewScheduleTableViewCell.cellIdentifier)
        }
        
        let switchView = UISwitch()
        switchView.onTintColor = .blue
        switchView.tag = indexPath.row
        switchView.addTarget(self, action: #selector(didTapSwitch), for: .valueChanged)
        
        cell.tag = indexPath.row
        cell.accessoryView = switchView
        cell.backgroundColor = UIColor(named: "E6E8EB")
        cell.textLabel?.text = days[indexPath.row]
        cell.textLabel?.font = .systemFont(ofSize: 17)
        cell.textLabel?.textColor = .black
        
        return cell
    }
    
    @objc private func didTapSwitch(programmeToggle: UISwitch) {
        if programmeToggle.isOn {
            savedDaysNames.append(days[programmeToggle.tag])
        } else {
            savedDaysNames.removeAll(where: {$0 == days[programmeToggle.tag]})
        }
    }
}
