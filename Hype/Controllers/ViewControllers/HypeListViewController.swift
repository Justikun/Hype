//
//  HypeListViewController.swift
//  Hype
//
//  Created by Justin Lowry on 1/10/22.
//

import UIKit

class HypeListViewController: UIViewController {
    // MARK: - Properties
    var refreshControl: UIRefreshControl = UIRefreshControl()
    var canRefresh = true
    
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        loadData()
    }
    
    // MARK: - Actions
    @IBAction func addHypeButtonTapped(_ sender: Any) {
        presentAddHypeAlert()
    }
    
    // MARK: - Methods
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < -100 {
            if canRefresh && !self.refreshControl.isRefreshing {

                self.canRefresh = false
                self.refreshControl.beginRefreshing()

                self.updateViews() // your viewController refresh function
            }
        }else if scrollView.contentOffset.y >= 0 {

            self.canRefresh = true
        }
    }
    
    @objc func loadData() {
        HypeController.shared.fetchHypes { success in
            if success {
                // Update Views
                self.updateViews()
            }
        }
    }
    
    func setupViews() {
        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull Down to Refresh")
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    
    func updateViews() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    func presentAddHypeAlert() {
        let alert = UIAlertController(title: "Get Hype!", message: "What hype may never die", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "What is hype today?"
            textField.autocorrectionType = .yes
            textField.autocapitalizationType = .sentences
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let addHypeAction = UIAlertAction(title: "Post", style: .default) { _ in
            guard let text = alert.textFields?.first?.text,
                  !text.isEmpty else { return }
            HypeController.shared.saveHype(with: text) { success in
                self.updateViews()
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(addHypeAction)
        
        self.present(alert, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HypeListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        HypeController.shared.hypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hypeCell", for: indexPath)
        
        let hype = HypeController.shared.hypes[indexPath.row]
        
        cell.textLabel?.text = hype.body
        cell.detailTextLabel?.text = hype.timestamp.formatDate()
        
        return cell
    }
    
    
}
