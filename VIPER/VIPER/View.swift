//
//  View.swift
//  VIPER
//
//  Created by Nyein on 6/7/23.
//

import Foundation
import UIKit

//viewcontrolelr
//protocol
//presenter

protocol AnyView {
    var presenter: AnyPresenter? { get set }
    
    func update(with users: [User])
    func update(with error: String)
}

class UserViewController: UIViewController, AnyView, UITableViewDelegate, UITableViewDataSource {
    var presenter: AnyPresenter?
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self,
                       forCellReuseIdentifier: "cell")
        table.isHidden = true
        return table
    }()
    private let label: UILabel = UILabel()
    
    var users:[User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
        view.addSubview(tableView)
        view.addSubview(label)
        tableView.delegate = self
        tableView.dataSource = self
        label.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        label.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        label.center = view.center
    }
    
    func update(with users: [User]) {
        DispatchQueue.main.async {
            self.users = users
            self.tableView.reloadData()
            self.tableView.isHidden = false
        }
    }
    
    func update(with error: String) {
        DispatchQueue.main.async {
            self.users = []
            self.label.isHidden = false
            self.label.text = error
            self.tableView.reloadData()
            self.tableView.isHidden = false
        }
    }
    
    //Table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = users[indexPath.row].name
        return cell
    }
}
