import UIKit

extension UITableView {
    final class DataSource<Model>: NSObject, UITableViewDataSource {
        typealias ItemProvider = (UITableView, IndexPath, Model) -> UITableViewCell?

        private var data: [Model] = []
        private let itemProvider: ItemProvider

        private unowned var tableView: UITableView

        init(tableView: UITableView, _ itemProvider: @escaping ItemProvider) {
            self.tableView = tableView
            self.itemProvider = itemProvider
        }

        // MARK: - Data Manipulation
        func set(items: [Model]) {
            data = items
            tableView.reloadData()
        }

        // MARK: - UITableViewDelegate
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { data.count }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let item = data[indexPath.row]
            let cell = itemProvider(tableView, indexPath, item)
            return cell ?? .init()
        }
    }
}
