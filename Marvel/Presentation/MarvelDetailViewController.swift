//
//  MarvelDetailViewController.swift
//  Marvel
//
//  Created by Mark Dalton on 7/3/21.
//

import UIKit

/// Marvel detail view controller conforming to table view data source and delegate.
class MarvelDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    /// Image view for character.
    @IBOutlet weak var imageView: UIImageView!
    
    /// Bio label for character.
    @IBOutlet weak var bioLabel: UILabel!
    
    /// Shadow view for image.
    @IBOutlet weak var shadowView: UIView!
    
    /// Table view for items like events.
    @IBOutlet weak var tableView: UITableView!
    
    /// Table view height to adjust.
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    
    /// View model for detail view.
    var viewModel: MarvelDetailViewModel!
    
    /// Key path to observe for changes in table view content size.
    let contentSizeKeyPath = "contentSize"
    
    /// Number of sections in table view.
    /// - Parameter tableView: The table view.
    /// - Returns: Returns number of sections.
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionHeaders.count
    }
    
    /// Height for table view.
    /// - Parameters:
    ///   - tableView: Table view.
    ///   - section: Section number.
    /// - Returns: Automatic dimension.
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    /// Estimated table veiw height.
    /// - Parameters:
    ///   - tableView: Table view.
    ///   - section: Section number.
    /// - Returns: Estimated height.
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(44)
    }
    
    /// Table view header.
    /// - Parameters:
    ///   - tableView: Table view.
    ///   - section: Section number.
    /// - Returns: Header view.
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableCell(withIdentifier: "marvelHeader") as? MarvelHeaderTableViewCell else { return nil }
        header.nameLabel.text = viewModel.sectionHeaders[section]
        return header
    }
    
    /// Table view cell.
    /// - Parameters:
    ///   - tableView: Table view.
    ///   - indexPath: Index path.
    /// - Returns: Table view cell.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "marvelDetailCell", for: indexPath) as? MarvelDetailTableViewCell else { return UITableViewCell() }
        switch viewModel.sectionHeaders[indexPath.section] {
        case viewModel.stories: break
        case viewModel.events:
            let event = viewModel.eventList[indexPath.row]
            if event is OfflineEvent {
                cell.nameLabel.text = "Internet Offline"
                cell.imageView?.image = nil
                cell.descriptionLabel.text = "Please connect to the internet and try loading again."
                return cell
            }
            cell.itemImageView.kf.setImage(with: URL(string: event.imageUrl ?? ""), options: [.transition(.fade(0.2))])
            cell.nameLabel.text = event.name
            cell.descriptionLabel.text = event.desc
        case viewModel.comics: break
        default: break
        }
        return cell
    }
    
    /// Number of rows in section.
    /// - Parameters:
    ///   - tableView: Table view.
    ///   - section: Section number.
    /// - Returns: Number of rows.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel.sectionHeaders[section] {
        case viewModel.stories: break
        case viewModel.events: return viewModel.numberOfEvents
        case viewModel.comics: break
        default: break
        }
        return Int.zero
    }
    
    /// View loaded.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Get character.
        let char = viewModel.character
        
        /// Get bio.
        let bio = char.bio ?? ""
        
        // Set bio.
        bioLabel.text = !bio.isEmpty ? bio : "No Biography Available for \(char.name ?? "")."
        
        // Set image using Kingfisher.
        imageView.setMarvelImage(using: char.imageUrl ?? "")
        
        // Set shadow.
        shadowView.layer.setShadow()
        
        // Set table view data source and delegate.
        tableView.dataSource = self
        tableView.delegate = self
        
        // Set table closure for reloading.
        viewModel.reloadTableViewClosure = { [weak self] in
            self?.tableView.reloadData()
        }
        
        // Fetch events.
        viewModel.fetchEvents()
    }
    
    /// Observe for keypath changes.
    /// - Parameters:
    ///   - keyPath: Keypath changed.
    ///   - object: Object.
    ///   - change: Change values.
    ///   - context: Context.
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        /// Check for table view.
        if let tableView = object as? UITableView {
            
            // If right table view and key path.
            if tableView == self.tableView && keyPath == contentSizeKeyPath {
                
                // Update view contraints.
                super.updateViewConstraints()
                
                // Set table height from content size.
                tableHeight.constant = tableView.contentSize.height
            }
        }
    }
    
    /// View will appear.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Navigation title.
        title = viewModel.character.name
        
        // Add observer for content size changes.
        tableView.addObserver(self, forKeyPath: contentSizeKeyPath, options: .new, context: nil)
    }
    
    /// View will dispappear.
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Remove observer for content size changes.
        tableView.removeObserver(self, forKeyPath: contentSizeKeyPath)
    }

}
