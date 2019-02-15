//
//  CVStackExpand.swift
//  ExpandableCollectionViewCells
//
//  Created by Xavier Lian on 2/13/19.
//  Copyright © 2019 Xavier Lian. All rights reserved.
//

import UIKit

protocol CVStackExpandDelegate: class
{
    func cvAddedRowAndNeedsToBeReloaded(at ip: IndexPath)
}

class CVStackExpand: UICollectionViewCell
{
    //MARK: Properties
    
    weak var delegate: CVStackExpandDelegate?
    
    //MARK: Outlets
    
    @IBOutlet var conHeightStackVw: NSLayoutConstraint!
    @IBOutlet var stackVw: UIStackView!
    @IBOutlet var addBt: UIButton!
    
    //MARK: Private Properties

    private var indexPath: IndexPath?
    private var textFields = [UITextField]()

    //MARK: Lifecycle
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        //Constraining the content view is necessary for self-sizing purposes
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: addBt.bottomAnchor).isActive = true
        addBt.addTarget(self, action: #selector(onAddBtPress), for: .touchUpInside)
    }
    
    override func prepareForReuse()
    {
        super.prepareForReuse()
        resetUI()
    }
    
    override func systemLayoutSizeFitting(
        _ targetSize: CGSize,
        withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
        verticalFittingPriority: UILayoutPriority) -> CGSize
    {
        //Update content view bound values so the right height is given
        contentView.layoutIfNeeded()
        
        //This is how the cell sizes itself.
        //Target size is what the collection view wants.
        //The contentView is constrained to the UI it holds, so grabbing its height sizes the cell
        //correctly.
        return CGSize(width: targetSize.width, height: contentView.bounds.height)
    }
    
    //MARK: Functions
    
    func provideSizingData(indexPath: IndexPath, delegate: CVStackExpandDelegate,
                           numberOfTFs: Int)
    {
        self.delegate = delegate
        self.indexPath = indexPath  //Needed so the delegate can tell the CV which cell to reload
        for _ in 0 ..< numberOfTFs
        {
            insertRow()
        }
        updateStackSize()
    }
    
    //MARK: Private Functions
    
    private func resetUI()
    {
        //Remember to reset the UI
        delegate = nil
        indexPath = nil
        textFields.forEach({$0.removeFromSuperview()})
        textFields.removeAll()
    }
    
    private func insertRow()
    {
        let tf = UITextField()
        tf.backgroundColor = .lightGray
        stackVw.addArrangedSubview(tf)
        textFields.append(tf)
    }
    
    private func updateStackSize()
    {
        
        conHeightStackVw.isActive = false                   //Free stack's height constraint
        stackVw.sizeToFit()                                 //Ask it to size itself
        stackVw.layoutIfNeeded()                            //Update bound values
        conHeightStackVw.constant = stackVw.bounds.height   //Update constraint's val
        conHeightStackVw.isActive = true                    //Turn it back on
    }
    
    @objc private func onAddBtPress()
    {
        insertRow()
        updateStackSize()
        if let indexPath = indexPath
        {
            delegate?.cvAddedRowAndNeedsToBeReloaded(at: indexPath)
        }
    }
}
