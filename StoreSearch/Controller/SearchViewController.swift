//
//  ViewController.swift
//  StoreSearch
//
//  Created by Dzmitry Hlushchuk on 1.07.24.
//

import UIKit

class SearchViewController: UIViewController {
    
    let cellIdentifier = "SearchResultCell"
    var searchResults = [SearchResult]()
    
    var hasSearched = false
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.contentInset = UIEdgeInsets(top: searchBar.frame.height, left: 0, bottom: 0, right: 0)
    }

}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchResults = []
        for i in 0...2 {
            let searchResult = SearchResult()
            searchResult.name = String(format: "Fake Result %d for", i)
            searchResult.artistName = searchBar.text!
            searchResults.append(searchResult)
        }
        hasSearched = true
        tableView.reloadData()
    }
    
    func position(for bar: any UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !hasSearched {
            return 0
        } else if searchResults.count == 0 {
            return 1
        } else {
            return searchResults.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        var configuration = cell.defaultContentConfiguration()
        if searchResults.count == 0 {
            configuration.text = "(Nothing found)"
            configuration.secondaryText = ""
        } else {
            let searchResult = searchResults[indexPath.row]
            configuration.text = searchResult.name
            configuration.secondaryText = searchResult.artistName
        }
        cell.contentConfiguration = configuration
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return searchResults.count == 0 ? nil : indexPath
    }
    
}
