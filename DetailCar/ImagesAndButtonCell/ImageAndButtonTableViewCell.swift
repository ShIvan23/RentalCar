//
//  ImageAndButtonTableViewCell.swift
//  RentalCar
//
//  Created by Ivan on 09.02.2022.
//

import UIKit

protocol ImageAndButtonTableViewCellDelegate: AnyObject {
    func orderButtonTapped()
    func photoTapped(item: Int)
}

final class ImageAndButtonTableViewCell: UITableViewCell {
    
    private var allImages = [String]()
    private var indexOfCellBeforeDragging = 0
    
    weak var delegate: ImageAndButtonTableViewCellDelegate?
    
    private lazy var carsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cell: ImageCollectionViewCell.self)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.backgroundColor = .white
        pageControl.numberOfPages = allImages.count
        pageControl.hidesForSinglePage = true
        pageControl.tintColor = .yellow
        pageControl.pageIndicatorTintColor = .systemGray5
        pageControl.currentPageIndicatorTintColor = .systemGray
        pageControl.addTarget(self, action: #selector(changePage), for: .touchUpInside)
        return pageControl
    }()
    
    private lazy var orderButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let attributedText = NSAttributedString(string: "Заказать", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)])
        button.setAttributedTitle(attributedText, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(orderButtonAction), for: .touchUpInside)
        return button
    }()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        orderButton.setCustomGradient()
    }
    
    func setupCell(images: [String]?) {
        allImages = images ?? []
        layout()
    }
    
    private func layout() {
        [carsCollectionView, pageControl, orderButton].forEach {
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            carsCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            carsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            carsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            carsCollectionView.heightAnchor.constraint(equalToConstant: contentView.frame.width)
        ])
        
        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: carsCollectionView.bottomAnchor),
            pageControl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            orderButton.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 8),
            orderButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            orderButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            orderButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc private func orderButtonAction() {
        delegate?.orderButtonTapped()
    }
    
    @objc private func changePage() {
        let x = CGFloat(pageControl.currentPage) * carsCollectionView.frame.size.width
        carsCollectionView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension ImageAndButtonTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        allImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ImageCollectionViewCell = collectionView.dequeueCell(for: indexPath)
        cell.setupCellWith(image: allImages[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ImageAndButtonTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ScreenSize.width, height: ScreenSize.width)
    }
    
    /// Для плавного перелистывания фотографий
    ///  https://stackoverflow.com/questions/22895465/paging-uicollectionview-by-cells-not-screen
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let pageWidth = ScreenSize.width
        let proportionalOffset = carsCollectionView.contentOffset.x / pageWidth
        indexOfCellBeforeDragging = Int(round(proportionalOffset))
    }
    
    /// Для плавного перелистывания фотографий
    /// https://stackoverflow.com/questions/22895465/paging-uicollectionview-by-cells-not-screen
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        targetContentOffset.pointee = scrollView.contentOffset
        
        // Calculate conditions
        let pageWidth = ScreenSize.width
        let collectionViewItemCount = allImages.count
        let proportionalOffset = carsCollectionView.contentOffset.x / pageWidth
        let indexOfMajorCell = Int(round(proportionalOffset))
        let swipeVelocityThreshold: CGFloat = 0.5
        let hasEnoughVelocityToSlideToTheNextCell = indexOfCellBeforeDragging + 1 < collectionViewItemCount && velocity.x > swipeVelocityThreshold
        let hasEnoughVelocityToSlideToThePreviousCell = indexOfCellBeforeDragging - 1 >= 0 && velocity.x < -swipeVelocityThreshold
        let majorCellIsTheCellBeforeDragging = indexOfMajorCell == indexOfCellBeforeDragging
        let didUseSwipeToSkipCell = majorCellIsTheCellBeforeDragging && (hasEnoughVelocityToSlideToTheNextCell || hasEnoughVelocityToSlideToThePreviousCell)
        
        if didUseSwipeToSkipCell {
            let snapToIndex = indexOfCellBeforeDragging + (hasEnoughVelocityToSlideToTheNextCell ? 1 : -1)
            let toValue = pageWidth * CGFloat(snapToIndex)
            UIView.animate(
                withDuration: 0.3,
                delay: 0,
                usingSpringWithDamping: 1,
                initialSpringVelocity: velocity.x,
                options: .allowUserInteraction,
                animations: {
                    scrollView.contentOffset = CGPoint(x: toValue, y: 0)
                    scrollView.layoutIfNeeded()
                },
                completion: nil
            )
        } else {
            let indexPath = IndexPath(row: indexOfMajorCell, section: 0)
            carsCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.photoTapped(item: indexPath.item)
    }
}
