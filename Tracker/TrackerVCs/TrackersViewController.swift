import UIKit

final class TrackersViewController: UIViewController {
    
    var mockCategories: [TrackerCategory] = []
    
    private var completedTrackers: [TrackerRecord] = []
    private var visibleCategories: [TrackerCategory] = []
    
    
    private let cellSpacing: CGFloat = 9
    private let sideInsets: CGFloat = 16
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setImage(.addTracker, for: .normal)
        button.tintColor = .ypBlack
        return button
    }()
    
    private lazy var placeholderImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .placeholderTrackers
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        return datePicker
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    private lazy var searchController = UISearchController(searchResultsController: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        setupUI()
        setupConstraints()
        setupNavigationBar()
        collectionView.delegate = self
        collectionView.dataSource = self
        filterTrackers(for: datePicker.date)
        updatePlaceholder()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Трекеры"
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: addButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        datePicker.addTarget(self, action: #selector(pickDate(_ :)), for: .valueChanged)
        navigationItem.searchController = searchController
        searchController.searchBar.placeholder = "Поиск"
        searchController.obscuresBackgroundDuringPresentation = false
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    private func setupUI() {
        view.addSubview(placeholderImage)
        view.addSubview(placeholderLabel)
        view.addSubview(collectionView)
        collectionView.register(TrackerCell.self, forCellWithReuseIdentifier: TrackerCell.identifier)
        collectionView.register(TrackerCategoryHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TrackerCategoryHeader.identifier)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            placeholderImage.widthAnchor.constraint(equalToConstant: 80),
            placeholderImage.heightAnchor.constraint(equalToConstant: 80),
            placeholderImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            placeholderLabel.topAnchor.constraint(equalTo: placeholderImage.bottomAnchor, constant: 8),
            placeholderLabel.centerXAnchor.constraint(equalTo: placeholderImage.centerXAnchor),
            
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    private func completedDays(for tracker: Tracker) -> Int {
        completedTrackers.filter {$0.id == tracker.id}.count
    }
    
    @objc func pickDate(_ sender: UIDatePicker) {
        filterTrackers(for: datePicker.date)
        updatePlaceholder()
        collectionView.reloadData()
    }
    
    @objc private func addButtonTapped() {
        let newTrackerViewController = NewTrackerViewController()
        newTrackerViewController.delegate = self
        present(newTrackerViewController, animated: true)
    }
    
    private func filterTrackers(for date: Date) {
        let weekday = Calendar.current.component(.weekday, from: date)
        guard let currentWeekDay = WeekDay(rawValue: weekday) else { return }
        visibleCategories = mockCategories.compactMap { category in
            let filteredTrackers = category.trackers.filter { $0.schedule.contains(currentWeekDay) }
            return filteredTrackers.isEmpty ? nil : TrackerCategory(title: category.title, trackers: filteredTrackers)
        }
    }
    
    private func updatePlaceholder() {
        let isEmpty = visibleCategories.isEmpty
        placeholderImage.isHidden = !isEmpty
        placeholderLabel.isHidden = !isEmpty
        collectionView.isHidden = isEmpty
    }
}

extension TrackersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visibleCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCell.identifier, for: indexPath) as? TrackerCell else { return UICollectionViewCell()}
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
        let isCompleted = completedTrackers.contains(where: {$0.id == tracker.id && Calendar.current.isDate($0.date, inSameDayAs: datePicker.date)})
        let date = datePicker.date
        cell.configureCell(tracker: tracker, isCompleted: isCompleted, date: date, daysCount: completedDays(for: tracker))
        cell.delegate = self
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return visibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TrackerCategoryHeader.identifier, for: indexPath) as? TrackerCategoryHeader else { return UICollectionReusableView()}
        header.configure(title: visibleCategories[indexPath.section].title)
        return header
    }
    
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.bounds.width - sideInsets * 2 - cellSpacing) / 2
        return CGSize(width: cellWidth, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: sideInsets, bottom: 0, right: sideInsets)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 46)
    }
}

extension TrackersViewController: TrackerCellDelegateProtocol {
    func didTapDoneButton(for tracker: Tracker) {
        let currentDate = datePicker.date
        if let index = completedTrackers.firstIndex(where: {$0.id == tracker.id && Calendar.current.isDate($0.date, inSameDayAs: currentDate)}) {
            completedTrackers.remove(at: index)
        } else {
            completedTrackers.append(TrackerRecord(id: tracker.id, date: currentDate))
        }
        collectionView.reloadData()
    }
}

extension TrackersViewController: NewTrackerViewControllerDelegateProtocol {
    func didCreateTracker(_ tracker: Tracker, category: TrackerCategory) {
        if let index = mockCategories.firstIndex(where: { $0.title == category.title }) {
            let updatedTrackers = mockCategories[index].trackers + [tracker]
            mockCategories[index] = TrackerCategory(title: category.title, trackers: updatedTrackers)
        } else {
            mockCategories.append(category)
        }
        filterTrackers(for: datePicker.date)
        updatePlaceholder()
        collectionView.reloadData()
    }
}
