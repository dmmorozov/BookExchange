//
//  GLTableCollectionViewController.swift
//  GLTableCollectionView
//
//  Created by Giulio Lombardo on 24/11/16.
//
//  MIT License
//
//  Copyright (c) 2018 Giulio Lombardo
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//

import UIKit

final class GLTableCollectionViewController: UITableViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    // This static string constant will be the cellIdentifier for the
    // UITableViewCells holding the UICollectionView, it's important to append
    // "_section#" to it so we can understand which cell is the one we are
    // looking for in the debugger. Look in UITableView's data source
    // cellForRowAt method for more explanations about the UITableViewCell reuse
    // handling.
    static let tableCellID: String = "tableViewCellID_section_#"

    let numberOfSections: Int = 3
    var personalBooks: [Book]!
    var freeBooks:[Book]!
    var readingBooks:[Book]!
    let numberOfCollectionsForRow: Int = 1
    let numberOfCollectionItems: Int = 20

    var colorsDict: [Int: [UIColor]] = [:]

    /// Set true to enable UICollectionViews scroll pagination
    var paginationEnabled: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.2114404142, green: 0.2392562032, blue: 0.2780771852, alpha: 1)
        freeBooks = testFreeBooks()
        readingBooks = testNowReadingBooks()
        personalBooks = testMyBooks()
        
        // Uncomment the following line to preserve selection between
        // presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the
        // navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

        (0 ... numberOfSections - 1).forEach { section in
            colorsDict[section] = randomRowColors()
        }
    }

    private final func randomRowColors() -> [UIColor] {
        let colors: [UIColor] = (0 ... numberOfCollectionItems - 1).map({ _ -> UIColor in
            var randomRed: CGFloat = CGFloat(arc4random_uniform(256))
            let randomGreen: CGFloat = CGFloat(arc4random_uniform(256))
            let randomBlue: CGFloat = CGFloat(arc4random_uniform(256))

            if randomRed == 255.0 && randomGreen == 255.0 && randomBlue == 255.0 {
                randomRed = CGFloat(arc4random_uniform(128))
            }

            let color: UIColor

            if #available(iOS 10.0, *) {
                if traitCollection.displayGamut == .P3 {
                    color = UIColor(displayP3Red: randomRed / 255.0, green: randomGreen / 255.0, blue: randomBlue / 255.0, alpha: 1.0)
                } else {
                    color = UIColor(red: randomRed / 255.0, green: randomGreen / 255.0, blue: randomBlue / 255.0, alpha: 1.0)
                }
            } else {
                color = UIColor(red: randomRed / 255.0, green: randomGreen / 255.0, blue: randomBlue / 255.0, alpha: 1.0)
            }

            return color
        })

        return colors
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: <UITableView Data Source>

    override func numberOfSections(in _: UITableView) -> Int {
        return numberOfSections
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return numberOfCollectionsForRow
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Instead of having a single cellIdentifier for each type of
        // UITableViewCells, like in a regular implementation, we have multiple
        // cellIDs, each related to a indexPath section. By Doing so the
        // UITableViewCells will still be recycled but only with
        // dequeueReusableCell of that section.
        //
        // For example the cellIdentifier for section 4 cells will be:
        //
        // "tableViewCellID_section_#3"
        //
        // dequeueReusableCell will only reuse previous UITableViewCells with
        // the same cellIdentifier instead of using any UITableViewCell as a
        // regular UITableView would do, this is necessary because every cell
        // will have a different UICollectionView with UICollectionViewCells in
        // it and UITableView reuse won't work as expected giving back wrong
        // cells.

        var cell: GLCollectionTableViewCell? = tableView.dequeueReusableCell(withIdentifier: GLTableCollectionViewController.tableCellID + indexPath.section.description) as? GLCollectionTableViewCell

        if cell == nil {
            cell = GLCollectionTableViewCell(style: .default, reuseIdentifier: GLTableCollectionViewController.tableCellID + indexPath.section.description)

            // Configure the cell...
            cell!.selectionStyle = .none
            cell!.collectionViewPaginatedScroll = paginationEnabled
        }

        return cell!
    }

    override func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Личные книги" + "\(personalBooks.count.description)"
        case 1:
            return "Свободные книги" + "\(freeBooks.count.description)"
        case 2:
            return "Читаю (1)"
        default:
            return "Другое"
        }
    }

    // MARK: <UITableView Delegate>

    override func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 210
    }

    override func tableView(_: UITableView, heightForHeaderInSection _: Int) -> CGFloat {
        return 35
    }

    override func tableView(_: UITableView, heightForFooterInSection _: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }

    override func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell: GLCollectionTableViewCell = cell as? GLCollectionTableViewCell else {
            return
        }

        cell.setCollectionView(dataSource: self, delegate: self, indexPath: indexPath)
    }

    // MARK: <UICollectionView Data Source>

    func numberOfSections(in _: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return numberOfCollectionItems
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: GLIndexedCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: GLIndexedCollectionViewCell.identifier, for: indexPath) as? GLIndexedCollectionViewCell else {
            fatalError("UICollectionViewCell must be of GLIndexedCollectionViewCell type")
        }

        guard let indexedCollectionView: GLIndexedCollectionView = collectionView as? GLIndexedCollectionView else {
            fatalError("UICollectionView must be of GLIndexedCollectionView type")
        }

        // Configure the cell...
        //cell.backgroundColor = colorsDict[indexedCollectionView.indexPath.section]?[indexPath.row]
        cell.backgroundColor = #colorLiteral(red: 0.2114404142, green: 0.2392562032, blue: 0.2780771852, alpha: 1)

        return cell
    }

    // MARK: <UICollectionViewDelegate Flow Layout>

    let collectionTopInset: CGFloat = 0
    let collectionBottomInset: CGFloat = 0
    let collectionLeftInset: CGFloat = 15
    let collectionRightInset: CGFloat = 15

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, insetForSectionAt _: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: collectionTopInset, left: collectionLeftInset, bottom: collectionBottomInset, right: collectionRightInset)
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tableViewCellHeight: CGFloat = 210//tableView.rowHeight
        let collectionItemWidth: CGFloat = 140 - (collectionLeftInset + collectionRightInset)
        //let collectionViewHeight: CGFloat = collectionItemWidth

        return CGSize(width: collectionItemWidth, height: tableViewCellHeight)
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        return 10
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumInteritemSpacingForSectionAt _: Int) -> CGFloat {
        return 0
    }

    // MARK: <UICollectionView Delegate>

    func collectionView(_: UICollectionView, didSelectItemAt _: IndexPath) {
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.backgroundView?.backgroundColor = #colorLiteral(red: 0.2114404142, green: 0.2392562032, blue: 0.2780771852, alpha: 1)
        header.textLabel?.textColor = .white
    }

    /*
     // MARK: <Navigation>

     // In a storyboard-based application, you will often want to do a little
     // preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}
