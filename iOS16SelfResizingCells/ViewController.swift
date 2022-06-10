//
//  ViewController.swift
//  iOS16SelfResizingCells
//
//  Created by Anupam Chugh on 09/06/22.
//

import UIKit

enum Section : CaseIterable {
  case one
  case two
}

class Movies: Hashable {
    
    var name: String
    var showDetails = false
    var body: String
    
    init(name: String, body: String = "NA") {
            
        self.name = name
        self.body = body
    }
    
    func hash(into hasher: inout Hasher) {
        return hasher.combine(name)
    }
    
    static func == (lhs: Movies, rhs: Movies) -> Bool {
        return lhs.name == rhs.name
    }
}

class ViewController: UIViewController, UICollectionViewDelegate {
    
    var collectionView : UICollectionView!
    private lazy var dataSource = makeDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()

        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        self.view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = dataSource
        
        setData(animated: true)
    }
    
    func setData(animated: Bool) {
            var snapshot = NSDiffableDataSourceSnapshot<Section, Movies>()
            snapshot.appendSections(Section.allCases)
            
            snapshot.appendItems([Movies(name: "Wonder Woman", body: "Starring Gal Gadot\n\nPrincess Diana of an all-female Amazonian race rescues US pilot Steve. Upon learning of a war, she ventures into the world of men to stop Ares, the god of war, from destroying mankind.")], toSection: .one)
            snapshot.appendItems([Movies(name: "Doctor Strange", body: "Starring Benedict\n\nDr Stephen Strange casts a forbidden spell that opens a portal to the multiverse. However, a threat emerges that may be too big for his team to handle.")], toSection: .one)
            snapshot.appendItems([Movies(name: "The Batman", body: "Starring Robert Pattison\n\nBatman is called to intervene when the mayor of Gotham City is murdered. Soon, his investigation leads him to uncover a web of corruption, linked to his own dark past.")], toSection: .one)
            
            snapshot.appendItems([Movies(name: "Black Widow", body: "Starring Scarlett\n\nNatasha Romanoff, a former KGB spy, is shocked to find out that her ex handler, General Dreykov, is still alive. While evading capture by Taskmaster, she is forced to confront her dark past.")], toSection: .two)
        
            snapshot.appendItems([Movies(name: "Iron Man")], toSection: .two)
        
            dataSource.apply(snapshot, animatingDifferences: animated)
    }
    
    
    func makeDataSource() -> UICollectionViewDiffableDataSource<Section, Movies> {
               
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Movies> { cell, indexPath, movie in
            
            var content = cell.defaultContentConfiguration()
            
            if movie.showDetails{
                content.text = movie.name
                content.secondaryText = movie.body
            }
            else{
                content.text = movie.name
            }
            cell.contentConfiguration = content
        }
        
        return UICollectionViewDiffableDataSource<Section, Movies>(
                    collectionView: collectionView,
                    cellProvider: { collectionView, indexPath, item in
                        collectionView.dequeueConfiguredReusableCell(
                            using: cellRegistration,
                            for: indexPath,
                            item: item
                        )
                    }
                )
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
        
        guard let movie = dataSource.itemIdentifier(for: indexPath) else {
                collectionView.deselectItem(at: indexPath, animated: true)
                return
        }
        
        movie.showDetails.toggle()
        var currentSnapshot = dataSource.snapshot()
        
        currentSnapshot.reconfigureItems([movie])
        dataSource.apply(currentSnapshot)
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
    }

}

