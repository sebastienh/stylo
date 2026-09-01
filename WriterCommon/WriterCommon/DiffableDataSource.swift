//
//  DiffableDataSource.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-06-11.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation

public protocol DiffableDataSource {
    
    associatedtype SectionIdentifierType
    
    associatedtype ItemIdentifierType
    
    associatedtype DiffableDataSourceSnapshotType where DiffableDataSourceSnapshotType: DiffableDataSourceSnapshot, DiffableDataSourceSnapshotType.ItemIdentifierType == ItemIdentifierType, DiffableDataSourceSnapshotType.SectionIdentifierType == SectionIdentifierType
    
    func snapshot() -> DiffableDataSourceSnapshotType
    
    func apply(_ snapshot: DiffableDataSourceSnapshotType, animatingDifferences: Bool, completion: (() -> Void)?)
}

public protocol DiffableDataSourceSnapshot {
    
    associatedtype SectionIdentifierType
    
    associatedtype ItemIdentifierType
    
    init()
    
    var numberOfItems: Int { get }

    var numberOfSections: Int { get }

    var sectionIdentifiers: [SectionIdentifierType] { get }

    var itemIdentifiers: [ItemIdentifierType] { get }

    func numberOfItems(inSection identifier: SectionIdentifierType) -> Int
    
    mutating func appendSections(_ identifiers: [SectionIdentifierType])
    
    mutating func insertSections(_ identifiers: [SectionIdentifierType], beforeSection toIdentifier: SectionIdentifierType)

    mutating func insertSections(_ identifiers: [SectionIdentifierType], afterSection toIdentifier: SectionIdentifierType)
    
    mutating func deleteSections(_ identifiers: [SectionIdentifierType])
    
    mutating func appendItems(_ identifiers: [ItemIdentifierType], toSection sectionIdentifier: SectionIdentifierType?)
    
    mutating func deleteItems(_ identifiers: [ItemIdentifierType])

    mutating func insertItems(_ identifiers: [ItemIdentifierType], beforeItem beforeIdentifier: ItemIdentifierType)

    mutating func insertItems(_ identifiers: [ItemIdentifierType], afterItem afterIdentifier: ItemIdentifierType)
    
}
