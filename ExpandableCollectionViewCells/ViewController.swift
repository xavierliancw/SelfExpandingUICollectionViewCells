//
//  ViewController.swift
//  ExpandableCollectionViewCells
//
//  Created by Xavier Lian on 2/13/19.
//  Copyright © 2019 Xavier Lian. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    //MARK: Properties
    
    @IBOutlet var cv: UICollectionView!
    let ID = "id"
    var flowLayout: UICollectionViewFlowLayout?
    var rowCount = 0    //View model defines and maintains data UI should present
    
    //MARK: Lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupCV()
    }
}

//MARK:- UICollectionView

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ID, for: indexPath)
        
        if let cast = cell as? CVStackExpand
        {
            //Sizing configurations should happen in this function call
            cast.provideSizingData(indexPath: indexPath, delegate: self, numberOfTFs: rowCount)
        }
        
        return cell
    }
    
    private func setupCV()
    {
        cv.delegate = self
        cv.dataSource = self
        
        cv.register(UINib(nibName: String(describing: CVStackExpand.self), bundle: nil),
                    forCellWithReuseIdentifier: ID)
        
        //This makes it so height sizing responsibilities belong to the cells
        let flow = UICollectionViewFlowLayout()
        flowLayout? = flow
        flow.estimatedItemSize = CGSize(width: cv.bounds.width, height: 1)
        cv.collectionViewLayout = flow
        
        cv.reloadData()
    }
}

//MARK:- CVStackExpanDelegate

extension ViewController: CVStackExpandDelegate
{
    func cvAddedRowAndNeedsToBeReloaded(at ip: IndexPath)
    {
        rowCount += 1
        
        //Reload animation looks weird, so I'm disabling it
        UIView.animate(withDuration: 0) {
            self.cv.performBatchUpdates({self.cv.reloadItems(at: [ip])})
        }
    }
}
