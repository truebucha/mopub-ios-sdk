//
//  LeaderboardAdViewController.swift
//
//  Copyright 2018-2019 Twitter, Inc.
//  Licensed under the MoPub SDK License Agreement
//  http://www.mopub.com/legal/sdk-license-agreement/
//

import UIKit
import MoPub

@objc(LeaderboardAdViewController)
class LeaderboardAdViewController: AdTableViewController {
    // MARK: - Properties
    
    override var adUnit: AdUnit {
        get {
            return dataSource.adUnit
        }
        set {
            // Create a new leaderboard specific data source with the new ad unit.
            let bannerDataSource: BannerAdDataSource = BannerAdDataSource(adUnit: newValue, bannerSize: MOPUB_LEADERBOARD_SIZE)
            dataSource = bannerDataSource
        }
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        // Past this point, the data source must be valid.
        guard dataSource != nil else {
            return
        }
        
        // Finish setting up the data source
        dataSource.delegate = self
        
        // Invoke the super class to finish loading the view.
        super.viewDidLoad()
        
        // Fix the leaderboard height so that Auto Layout will correctly resize the table header.
        if let header = tableView.tableHeaderView {
            header.heightAnchor.constraint(equalToConstant: MOPUB_LEADERBOARD_SIZE.height).isActive = true
        }
    }
}

extension LeaderboardAdViewController: AdDataSourcePresentationDelegate {
    // MARK: - AdDataSourcePresentationDelegate
    
    /**
     View controller used to present models (either the ad itself or any click through destination).
     */
    var adPresentationViewController: UIViewController? {
        return self
    }
    
    /**
     Table view used to present the contents of the data source.
     */
    var adPresentationTableView: UITableView {
        return tableView
    }
}
