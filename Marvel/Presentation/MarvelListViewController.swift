//
//  MarvelListTableViewController.swift
//  Marvel
//
//  Created by Mark Dalton on 7/3/21.
//

import UIKit
import Kingfisher
import Lottie

/// Marvel list view controller, main view controller consisting of a table view controller and search bar functionality.
class MarvelListViewController: UITableViewController, UISearchBarDelegate {
    
    /// Search bar to search characters.
    private var search = UISearchController(searchResultsController: nil)
    
    /// Data repository to inject into detail view controller.
    var dataRepo: DataRepository!
    
    /// View model to run business logic.
    var viewModel: MarvelListViewModel!
    
    /// Bool to avoid repeat calls to viewWillAppear for loading and fetching.
    private var firstRun = true
    
    /// Animation view holding Lottie animation and loading label.
    private var animationView: UIView!
    
    /// Lottie animation view.
    private var animation: AnimationView!
    
    /// View loaded.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fire up network monitor early
        _ = NetworkMonitor.shared
        
        // Setup search bar
        setupSearch()
        
        // Closure to reload table view
        viewModel.reloadTableViewClosure = { [weak self] in
            
            // Reload table view
            self?.tableView.reloadData()
            
            // If there are results, hide the animation view and stop animation.
            if let results = self?.viewModel.characterList.count, results > Int.zero {
                
                // Hide loading animation view
                self?.animationView.isHidden = true
                
                // Stop Lottie animation.
                self?.animation.stop()
            }
            
        }
    }
    
    /// Setup the search bar.
    private func setupSearch() {
        search.searchBar.delegate = self
        search.searchBar.sizeToFit()
        search.obscuresBackgroundDuringPresentation = false
        search.hidesNavigationBarDuringPresentation = true
        definesPresentationContext = true
        search.searchBar.placeholder = "Search"
        navigationItem.searchController = search
    }
    
    // View will appear.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Directory"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        navigationItem.hidesSearchBarWhenScrolling = false
        if firstRun {
            firstRun = false
            setupAnimation()
            viewModel.fetchCharacters()
        }
    }
    
    // Setup Lottie animation.
    private func setupAnimation() {
        
        // Check if loading text should say offline message.
        let loadingText = NetworkMonitor.shared.isReachable ? "Loading Superheroes..." : "Internet Offline. Please connect and restart."
        
        // Set animation size.
        let animationSize: CGFloat = view.frame.width / 2
        
        // Set label with.
        let labelWidth = view.frame.width
        
        // Set font used for label.
        let font = UIFont.systemFont(ofSize: 17, weight: .regular)
        
        // Set label height.
        let labelHeight: CGFloat = loadingText.height(withConstrainedWidth: labelWidth, font: font)
        
        // Set animation frame properties.
        let size = CGSize(width: animationSize, height: animationSize + labelHeight)
        let x = (tableView.frame.width / 2) - (size.width / 2)
        var y = (tableView.frame.height / 2) - (size.height / 2)
        let navHeight = UIApplication.shared.statusBarFrame.size.height +
            (navigationController?.navigationBar.frame.height ?? CGFloat.zero)
        y -= (navHeight + search.searchBar.frame.height)
        
        // Create animation view from local JSON file.
        animation = AnimationView(name: "super-hero-charging")
        
        // Set class variable for animation view to hide after loading.
        animationView = UIView(frame: CGRect(origin: CGPoint(x: x, y: y), size: size))
        
        // Set animation view frame to bounds
        animation.frame = animationView.bounds
        
        // Set label frame properties
        let labelX = (animationSize / 2) - (labelWidth / 2)
        let label = UILabel(frame: CGRect(x: labelX, y: animationSize, width: labelWidth, height: labelHeight))
        
        // Set more label properties such as color, font, and text alignment.
        label.textColor = .black.withAlphaComponent(0.5)
        label.text = loadingText
        label.font = font
        label.numberOfLines = Int.zero
        label.textAlignment = .center
        
        // Set animation content mode and turn loop on.
        animation.contentMode = .scaleAspectFit
        animation.loopMode = .loop
        
        // Add subviews.
        animationView.addSubview(animation)
        animationView.addSubview(label)
        tableView.addSubview(animationView)
        
        // Play Lottie animation.
        animation.play()
    }
    
    /// View did layout subviews.
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Guard animation view and animation.
        guard let animationView = self.animationView,  let animation = self.animation else { return }
        
        // If animation setup, adjust frame to holder bounds as necessary.
        animation.frame = animationView.bounds
    }
    
    /// Search bar delegate method called when text changes.
    /// - Parameters:
    ///   - searchBar: The search bar.
    ///   - searchText: The search text in the search bar.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        /// Get character list from view model.
        let charList = viewModel.characterList
        
        // If search is not empty.
        if !searchText.isEmpty {
            
            // Filter list by main character list.
            viewModel.filteredList = charList.filter {
                
                // Get character name.
                guard let charName = $0.name else { return false }
                
                // Filtering for hyphens and case-sensitivity, check if character name contains search text.
                return filter(charName).contains(filter(searchText))
            }
        } else {
          
            // else
            viewModel.filteredList = charList
        }
        
        // Reload table view.
        tableView.reloadData()
    }
    
    /// Filter for hyphens and case sensitivity
    /// - Parameter text: Search string or character name to filter
    /// - Returns: Return string filtered for hyphens and case-sensitivity
    private func filter(_ text: String) -> String {
        return text.lowercased().replacingOccurrences(of: "-", with: "")
    }
    
    /// Search bar delegate method called when cancel button clicked
    /// - Parameter searchBar: The search bar.
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        // Reset the filtered list data source to the main character list.
        viewModel.filteredList = viewModel.characterList
        
        // Reload table view.
        tableView.reloadData()
    }

    // MARK: - Table view data source
    
    /// Table view data source method to return number of rows in table view section.
    /// - Parameters:
    ///   - tableView: The table view.
    ///   - section: The section number.
    /// - Returns: Returns the number of rows in the table view section.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredList.count
    }
    
    /// Table view delegate method called when selecting a row.
    /// - Parameters:
    ///   - tableView: The table view.
    ///   - indexPath: The IndexPath associated with the selection.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Guard instantiate view controller from storyboard with detail view controller identifier.
        guard let detailVC = storyboard?.instantiateViewController(withIdentifier: "marvelDetail") as? MarvelDetailViewController else { return }
            
        // Get character from fitlered list data source.
        let character = viewModel.filteredList[indexPath.row]
        
        // Inject dependencies for view model with data repository and model with character.
        detailVC.viewModel = MarvelDetailViewModel(dataRepo: dataRepo, model: MarvelDetailModel(character: character))
        
        // Get search text.
        if let searchText = search.searchBar.text {
            
            // If search text is not empty.
            if !searchText.isEmpty {
                
                // Resign to avoid keyboard being open when coming back.
                search.searchBar.resignFirstResponder()
            } else {
                
                // If search is empty, set the search isActive false to close search bar.
                DispatchQueue.main.async {
                    self.search.isActive = false
                }
            }
        }
        
        // Push detail view controller.
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    /// Table view data source method called when creating cells.
    /// - Parameters:
    ///   - tableView: The table view.
    ///   - indexPath: The IndexPath used for the cell.
    /// - Returns: The table view cell.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "marvelCell", for: indexPath) as? MarvelTableViewCell else { return UITableViewCell() }
        
        // Get character from filtered data source.
        let character = viewModel.filteredList[indexPath.row]
        
        // Set character name.
        cell.nameLabel.text = character.name
        
        // Set background image using Kingfisher to load url and cache.
        cell.backgroundImage.setMarvelImage(using: character.imageUrl ?? "")
        
        // Set shadow on shadow view.
        cell.shadowView.layer.setShadow()
        
        // Return table view cell.
        return cell
    }

}

extension UIImageView {
    func setMarvelImage(using url: String) {
        let emptyImageUrls = [
            "https://i.annihil.us/u/prod/marvel/i/mg/f/60/4c002e0305708.gif",
            "https://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available.jpg",
        ]
        let exists = emptyImageUrls.filter { $0 == url }.count == Int.zero
        kf.setImage(with: exists ? URL(string: url) : nil, options: [.transition(.fade(0.2))])
        if !exists {
            image = UIImage(named: "empty")
        }
    }
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(boundingBox.height)
    }
}

extension CALayer {
    func setShadow() {
        shadowColor = UIColor.black.cgColor
        shadowOffset = CGSize(width: 1, height: 1)
        shadowRadius = 2
        shadowOpacity = 0.15
    }
}
