import UIKit
import Combine
import UserDetailUseCase

final class UserDetailViewController: BaseViewController, ImageLoadable {
    // MARK: - UI Components
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    
    private let contentView = UIView()
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 40
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .gray
        return label
    }()
    
    private let statsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        return stackView
    }()
    
    private let followersView = UserStatView(title: "Followers")
    private let followingView = UserStatView(title: "Following")
    
    private let blogLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .systemBlue
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Properties
    private let viewModel: UserDetailViewModel
    weak var coordinator: UserDetailCoordinator?
    
    // MARK: - Lifecycle
    init(viewModel: UserDetailViewModel) {
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
            await viewModel.loadUserDetail()
        }
    }
    
    @objc private func refresh() {
        Task {
            await viewModel.refresh()
        }
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        title = "User Details"
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        view.addSubview(loadingIndicator)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(locationLabel)
        contentView.addSubview(statsStackView)
        contentView.addSubview(blogLabel)
        
        statsStackView.addArrangedSubview(followersView)
        statsStackView.addArrangedSubview(followingView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
        
        avatarImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(24)
            make.centerX.equalTo(contentView)
            make.size.equalTo(80)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(16)
            make.centerX.equalTo(contentView)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.centerX.equalTo(contentView)
        }
        
        statsStackView.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(24)
            make.leading.equalTo(contentView).offset(16)
            make.trailing.equalTo(contentView).offset(-16)
        }
        
        blogLabel.snp.makeConstraints { make in
            make.top.equalTo(statsStackView.snp.bottom).offset(24)
            make.leading.equalTo(contentView).offset(16)
            make.trailing.equalTo(contentView).offset(-16)
            make.bottom.equalTo(contentView).offset(-24)
        }
    }
    
    private func bindViewModel() {
        Task {
            for await state in viewModel.$detailState.values {
                if let userDetail = state.data {
                    updateUI(with: userDetail)
                }
            }
        }
        
        Task {
            for await state in viewModel.$viewState.values {
                if state.isLoading {
                    showLoading()
                } else {
                    hideLoading()
                }
                
                if let error = state.error {
                    showError(error)
                }
            }
        }
    }
    
    private func updateUI(with userDetail: UserDetail) {
        nameLabel.text = userDetail.login
        locationLabel.text = userDetail.location
        followersView.setValue(userDetail.followers)
        followingView.setValue(userDetail.following)
        blogLabel.text = userDetail.htmlUrl
        loadImage(into: avatarImageView, 
                 from: userDetail.avatarUrl, 
                 placeholder: UIImage(systemName: "person.circle.fill"))
    }
} 
