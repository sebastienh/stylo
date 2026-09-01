//
//  TagsCollectionViewController.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-05-27.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa
import WriterCommon
import Common
import os

extension NSDiffableDataSourceSnapshot: DiffableDataSourceSnapshot where ItemIdentifierType == AttributeTagOutputItemValue, SectionIdentifierType == AttributeTagOutputSectionValue {
    
    public typealias SectionIdentifierType = AttributeTagOutputSectionValue
    
    public typealias ItemIdentifierType = AttributeTagOutputItemValue
}

extension NSCollectionViewDiffableDataSource: DiffableDataSource where ItemIdentifierType == AttributeTagOutputItemValue, SectionIdentifierType == AttributeTagOutputSectionValue {
   
    public typealias SectionIdentifierType = AttributeTagOutputSectionValue
   
    public typealias ItemIdentifierType = AttributeTagOutputItemValue
   
    public typealias DiffableDataSourceSnapshotType = TagsCollectionViewController.DiffableDataSourceSnapshotType
}

public class TagsCollectionViewController: NSViewController {

    public typealias DiffableDataSourceSnapshotType = NSDiffableDataSourceSnapshot<AttributeTagOutputSectionValue, AttributeTagOutputItemValue>

    typealias CollectionViewDiffableDataSourceType = NSCollectionViewDiffableDataSource<AttributeTagOutputSectionValue, AttributeTagOutputItemValue>
    
    typealias OccurencesNavigatorType = OccurencesNavigator<OutputItemOccurence<AttributeTagOutputItemValue>>
    
    @IBOutlet var tagsCollectionView: TagsCollectionView!
    
    var selecting: Bool = false
    
    var filesOutlineTagsManager: FilesOutlineTagsManager<CollectionViewDiffableDataSourceType>? {
        
        return self.representedObject as? FilesOutlineTagsManager<CollectionViewDiffableDataSourceType>
    }
    
    ///
    /// Contains the tags displayed in the tags collection view.
    ///
    /// Note: This collection does not contain the updated
    /// text positions.
    ///
    var displayedCollectionSorting: FilesOutlineTagsManager<CollectionViewDiffableDataSourceType>.AttributesCollectionSorting?
    
    var dataSource: CollectionViewDiffableDataSourceType?
    
    private var filterTimer: Timer?
    
    var filterString: String? {
        didSet {
            self.filesOutlineTagsManager?.updateFilterString(to: filterString)
        }
    }
    
    private var selectionIndexesObservation: NSKeyValueObservation?
    
    private var selectionIndexesPathsObservation: NSKeyValueObservation?
    
    var tagsUpdateSerialQueue = DispatchQueue(label: "tagsUpdateSerialQueue")
    
    ///
    /// We keep in this variable the selection index paths when
    /// the view disappeared. When restoring the view we should
    /// used this value to restore the selection.
    ///
    private var previousSelectionIndexPaths: Set<IndexPath>?
    
    private var selectionIndexPaths: Set<IndexPath> {
        if let previousSelectionIndexPaths = self.previousSelectionIndexPaths {
            self.previousSelectionIndexPaths = nil
            return previousSelectionIndexPaths
        }
        else {
            return self.tagsCollectionView.selectionIndexPaths
        }
    }
    
    var orderedValuesOccurences: [OutputItemOccurence<AttributeTagOutputItemValue>]?
    
    var occurencesNavigator: OccurencesNavigatorType?
    
    var attributesMode: AttributesSortingMode = .values
    
    var allowsChangingSelection: Bool = true
    
    private var valuesCount: Int = 0
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let tagNib = NSNib(nibNamed: NSNib.Name(string: "Tag" ), bundle: Bundle(for: type(of: self)))
        tagsCollectionView.register(tagNib, forItemWithIdentifier: Tag.reuseIdentifier)
        
        let sectionNib = NSNib(nibNamed: NSNib.Name(string: "HeaderView" ), bundle: Bundle(for: type(of: self)))
        tagsCollectionView.register(sectionNib, forSupplementaryViewOfKind: NSCollectionView.elementKindSectionHeader, withIdentifier: SectionHeaderView.reuseIdentifier)
        
        self.listenToTagsCollectionViewFrameChange()
    }
    
    public override func viewWillDisappear() {
        super.viewWillDisappear()
        self.previousSelectionIndexPaths = self.tagsCollectionView.selectionIndexPaths
    }
    
    public override func viewWillAppear() {
        
        self.initDataFromFilesOutlineTagsManager()
        if self.dataSource == nil {
            self.subscribeToFilesOutlineTagsManager()
            self.setupDataSource()
        }
        self.refreshCollectionSorting()
        super.viewWillAppear()
    }
    
    func selectAllTags(_ sender: AnyObject? = nil) {
        
        self.tagsCollectionView.resetFlashedItems()
        self.tagsCollectionView.selectAll(sender)
    }
    
    func unselectAllTags(_ sender: AnyObject? = nil) {
        
        self.tagsCollectionView.resetFlashedItems()
        self.tagsCollectionView.deselectAll(sender)
    }
    
    func setValuesSortingMode() {
        
        assert(self.filesOutlineTagsManager != nil)
        self.filesOutlineTagsManager?.setValuesSortingMode()
    }
    
    func setAttributesSortingMode() {
        
        assert(self.filesOutlineTagsManager != nil)
        self.filesOutlineTagsManager?.setAttributesSortingMode()
    }
    
    func enableUserInteractions() {
        
        self.allowsChangingSelection = true
        self.tagsCollectionView.allowUserInteractions = true
    }
    
    func disableUserInteractions() {
        
        self.allowsChangingSelection = false
        self.tagsCollectionView.allowUserInteractions = false
    }
    
    private func listenToTagsCollectionViewFrameChange() {
        
        self.tagsCollectionView.postsFrameChangedNotifications = true
        
        NotificationCenter.default.addObserver(forName: NSView.frameDidChangeNotification, object: self.tagsCollectionView, queue: nil) { [weak self](_) in
            self?.tagsCollectionView?.collectionViewLayout?.invalidateLayout()
        }
    }
    
    func refreshCollectionSorting() {
        
        guard let filesOutlineTagsManager = self.filesOutlineTagsManager else {
            assertionFailure("Error: self.filesOutlineTagsManager is nil")
            return
        }
        
        guard let dataSource = self.dataSource else {
            assertionFailure("Error: self.dataSource is nil")
            return
        }
        
        self.displayedCollectionSorting = filesOutlineTagsManager.actualCollectionSorting.value
        filesOutlineTagsManager.reloadDataSource(dataSource)
        self.tagsCollectionView.selectItems(at: filesOutlineTagsManager.selectionIndexPaths.values, scrollPosition: .top)
    }
    
    private func subscribeToFilesOutlineTagsManager() {
        
        guard let filesOutlineTagsManager = self.filesOutlineTagsManager else {
            assertionFailure("Error: self.filesOutlineTagsManager is nil")
            return
        }
        
        filesOutlineTagsManager.actualCollectionSorting.subscribe({ [weak self](collectionSorting) in
            self?.displayedCollectionSorting = collectionSorting
        }, observer: self)
        
        filesOutlineTagsManager.selectionIndexPaths.subscribe({ [weak self](change) in
            self?.handleSelectionIndexPathsChange(change)
        }, observer: self)
        
        filesOutlineTagsManager.scrolledOutputItems.subscribe({ [weak self](outputItems) in
            if let outputItems = outputItems {
                self?.flashOutputItems(outputItems)
            }
        }, observer: self)
    }
    
    private func initDataFromFilesOutlineTagsManager() {
        
        guard let filesOutlineTagsManager = self.filesOutlineTagsManager else {
            assertionFailure("Error: self.filesOutlineTagsManager is nil")
            return
        }
        
        self.displayedCollectionSorting = filesOutlineTagsManager.actualCollectionSorting.value
        self.tagsCollectionView.selectionIndexPaths = filesOutlineTagsManager.selectionIndexPaths.values
    }
    
    private func flashOutputItems(_ outputItems: [AttributeTagOutputItemValue]) {
        
        guard let displayedCollectionSorting = self.displayedCollectionSorting else {
            assertionFailure("Error: self.displayedCollectionSorting is nil")
            return
        }
        
        self.tagsCollectionView.flashOutputItems(outputItems, inCollectionSorting: displayedCollectionSorting)
    }
    
    private func handleSelectionIndexPathsChange(_ change: DynamicSet<IndexPath>.SetChange) {
        
        self.tagsCollectionView.selectionIndexPaths = change.updatedValues
    }
    
    private func unsubscribeToFilesOutlineTagsManager() {
        
        guard let filesOutlineTagsManager = self.filesOutlineTagsManager else {
            assertionFailure("Error: self.filesOutlineTagsManager is nil")
            return
        }
        filesOutlineTagsManager.scrolledOutputItems.unsubscribe(observer: self)
        filesOutlineTagsManager.actualCollectionSorting.unsubscribe(observer: self)
        filesOutlineTagsManager.selectionIndexPaths.unsubscribe(observer: self)
    }
    
    private func setupDataSource() {
        
        self.dataSource = CollectionViewDiffableDataSourceType(collectionView: self.tagsCollectionView) { (collectionView, indexPath, identifier) -> NSCollectionViewItem? in
            
            let tagsCollectionViewItem = collectionView.makeItem(withIdentifier: Tag.reuseIdentifier, for: indexPath) as! Tag
            
            guard let filesOutlineAttributesSorting = self.displayedCollectionSorting else {
                assertionFailure("Error: self.tokenAttributes is nil")
                return nil
            }
            
            assert(filesOutlineAttributesSorting.sections.count == self.filesOutlineTagsManager!.actualCollectionSorting.value?.sections.count)
            assert(filesOutlineAttributesSorting.sections.count == self.filesOutlineTagsManager!.actualCollectionSorting.value?.sections.count)
            assert(filesOutlineAttributesSorting.sections.count == filesOutlineAttributesSorting.sectionsValues.count)
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Request for item value at indexPath: section: %@, item: %@", log: Log.Tags.all, type: .info, %%indexPath.section, %%indexPath.item)
            #endif
            
            guard indexPath.section >= 0 && indexPath.section < filesOutlineAttributesSorting.sectionsValues.count else {
                assertionFailure("Error: sectionIndex is out of range: \(indexPath.section)")
                return nil
            }
            
            let sectionValues = filesOutlineAttributesSorting.sectionsValues[indexPath.section]
            
            assert(sectionValues.count == self.filesOutlineTagsManager?.actualCollectionSorting.value?.sectionsValues[indexPath.section].count, "\(sectionValues.count) != \(self.filesOutlineTagsManager?.actualCollectionSorting.value?.sectionsValues[indexPath.section].count)")
            
            guard indexPath.item >= 0 && indexPath.item < sectionValues.count else {
                assertionFailure("Error: indexPath.item is out of range: \(indexPath.item) >= 0 || \(indexPath.item) < \(sectionValues.count) in filesOutlineAttributesSorting: \(filesOutlineAttributesSorting), actualCollectionSorting: \(self.filesOutlineTagsManager?.actualCollectionSorting.value)")
                return nil
            }
            
            let item = sectionValues[indexPath.item]
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Request for item value at indexPath: section: %@, item: %@ with value: %@", log: Log.Tags.all, type: .info, %%indexPath.section, %%indexPath.item, %%item)
            #endif
            
            tagsCollectionViewItem.representedObject = item.stringValue
            tagsCollectionViewItem.tokenField.textField?.invalidateIntrinsicContentSize()
            
            return tagsCollectionViewItem
        }
        
        self.dataSource?.supplementaryViewProvider = {(collectionView, kind, indexPath) -> (NSView & NSCollectionViewElement)? in
            
            let view = collectionView.makeSupplementaryView(ofKind: NSCollectionView.elementKindSectionHeader, withIdentifier: SectionHeaderView.reuseIdentifier, for: indexPath) as! SectionHeaderView
            
            view.sectionTitle.stringValue = "Section \(indexPath.section)"
            
            guard let filesOutlineAttributesSorting = self.displayedCollectionSorting else {
                assertionFailure("Error: filesOutlineAttributesSorting is nil")
                return view
            }
            
            guard indexPath.section >= 0 && indexPath.section < filesOutlineAttributesSorting.sections.count else {
                assertionFailure("Error: indexPath.section is out of range")
                return view
            }
            
            let section = filesOutlineAttributesSorting.sections[indexPath.section]
            view.sectionTitle.stringValue = section.stringValue
            return view
        }
        
    }
    
}
