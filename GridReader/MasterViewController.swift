//
//  MasterViewController.swift
//  GridReader
//
//  Created by Bob Voorneveld on 11/02/2017.
//  Copyright © 2017 Purple Gorilla. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController {

    var objects:[Household] = [Household]()

    @IBOutlet weak var tableView: UITableView!

}

extension MasterViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        loadHouseholds()
    }
}

extension MasterViewController {
    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let household = objects[indexPath.row]
                let controller = segue.destination as! DetailViewController
                controller.household = household
            }
        }
    }

}

extension MasterViewController: UITableViewDataSource {
    // MARK: - Table View

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let object = objects[indexPath.row]
        cell.textLabel!.text = object.address
        return cell
    }
}

extension MasterViewController {
    func loadHouseholds() {
        Webservice.load(resource: Household.all) { result in
            if case let .success(data) = result, let households = data {
                self.objects = households
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}

