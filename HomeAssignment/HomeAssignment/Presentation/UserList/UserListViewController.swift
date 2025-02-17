import UIKit

final class UserListViewController: BaseViewController {
    // MARK: - UI Components
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        return tableView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
    
    // MARK: - Properties
    private let viewModel: UserListViewModel
    weak var coordinator: UserListCoordinator?
    
    // MARK: - Lifecycle
    init(viewModel: UserListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        Task {
            await viewModel.viewDidLoad()
        }
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        title = "Github Users"
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        tableView.registerReusableCell(UserCell.self)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func bindViewModel() {
        Task {
            for await state in viewModel.$state.values {
                switch state {
                case .idle:
                    hideLoading()
                case .loading:
                    showLoading()
                case .loaded:
                    hideLoading()
                    refreshControl.endRefreshing()
                    tableView.reloadData()
                case .error(let error):
                    hideLoading()
                    refreshControl.endRefreshing()
                    showError(error)
                }
            }
        }
    }
    
    @objc private func refresh() {
        Task {
            await viewModel.refresh()
            refreshControl.endRefreshing()
        }
    }
}

// MARK: - UITableViewDataSource
extension UserListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UserCell = tableView.dequeueReusableCell(for: indexPath)
        let user = viewModel.users[indexPath.row]
        cell.configure(with: user)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension UserListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastItem = viewModel.users.count - 1
        if indexPath.row == lastItem {
            Task {
                await viewModel.loadMore()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let user = viewModel.users[indexPath.row]
        coordinator?.showUserDetail(username: user.login)
    }
} 
