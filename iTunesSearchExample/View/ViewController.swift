//
//  ViewController.swift
//  iTunesSearchExample
//
//  Created by LinChe-Ching on 2018/12/22.
//  Copyright © 2018 Che-ching Lin. All rights reserved.
//

import UIKit
import ReactiveSwift

class ViewController: UIViewController {

    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel = SearchItunesMusicViewModel(provider: apiProvider)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.register(UINib.init(nibName: "SearchItunesMusicCell", bundle: nil), forCellReuseIdentifier: "SearchItunesMusicCell")
        tableView.rowHeight = 44
        viewModel.state.producer
            .skipNil()
            .observe(on: UIScheduler()).startWithValues {
                [weak self] state in
                guard let `self` = self else { return }
                self.tableView.reloadData()
        }
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.initialAction.apply().start()
    }
}


extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let state = viewModel.state.value else { return 0 }
        guard let songResult = state.result else { return 0 }
        return songResult.resultCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let state = viewModel.state.value else { fatalError() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchItunesMusicCell", for: indexPath) as! SearchItunesMusicCell
        guard let song = state.result?.results[indexPath.row] else { return cell }
        cell.artistTitleLabel.text = song.trackName
        cell.artworkUrl = song.artworkUrl100
        return cell
    }
}

extension ViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let state = viewModel.state.value else { return }
        guard let song = state.result?.results[indexPath.row] else { return }
        playerModel.model.url = song.previewUrl
        playerModel.model.play()
    }
}

extension ViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.action.apply(.updateTerm(term: searchBar.text)).start()
        viewModel.action.apply(.searchTerm).observe(on: UIScheduler()).startWithResult {
            [weak self] result in
            switch result {
            case .success:
                break
            case .failure:
                let alert = UIAlertController(title: "Notice", message: "Search Error", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                self?.present(alert, animated: true, completion: nil)
                break
            }
        }
        searchBar.resignFirstResponder()
    }
}
