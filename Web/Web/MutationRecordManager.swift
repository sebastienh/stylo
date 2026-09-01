//
//  MutationObserverInterestGroup.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2015-02-13.
//  Copyright (c) 2015 CM. All rights reserved.
//

import Foundation
import Common

/// This class encapsulate all the mutation record 
/// managements methods. Each Document has one MuationRecordManager.
final class MutationRecordManager {
    
    /// Create MutationRecord of "[characterData](https://dom.spec.whatwg.org/#characterdata)"
    /// for node with oldValue node's [data](https://dom.spec.whatwg.org/#concept-cd-data).
    func createCharacterDataMutationRecord(_ target: CharacterData) -> MutationRecord {
    
        var mutationRecord = MutationRecord(type: §MutationRecordType.CharacterData , target: target)
        mutationRecord.oldValue = target.data
        return mutationRecord
    }
    
    /// Create a MutationRecord for removed childs. 
    func createRemovedChildsMutationRecord(_ target: ContainerNode, removedNodes: NodeList) -> MutationRecord {
        
        var mutationRecord = MutationRecord(type: §MutationRecordType.ChildList , target: target)
        mutationRecord.removedNodes = removedNodes
        return mutationRecord
    }
    
    /// Create a mutation record for added childs. 
    func createAddedChildsMutationRecord(_ target: ContainerNode, addedNodes: NodeList) -> MutationRecord {
        
        var mutationRecord = MutationRecord(type: §MutationRecordType.ChildList , target: target)
        mutationRecord.addedNodes = addedNodes
        return mutationRecord
    }
    
    /// To queue a mutation record of type for target with one or more of
    /// (depends on type) name name, namespace namespace, oldValue oldValue,
    /// addedNodes addedNodes, removedNodes removedNodes, previousSibling previousSibling,
    /// and nextSibling nextSibling, run these steps:
    /// see https://dom.spec.whatwg.org/#queue-a-mutation-record
    func queueMutationRecord(_ mutationRecord: MutationRecord) {
        
        let type = mutationRecord.type
        let target = mutationRecord.target
        let name = mutationRecord.attributeName
        let namespace = mutationRecord.attributeNamespace
        
        // 1. Let interested observers be an initially empty set of MutationObserver
        // objects optionally paired with a string.
        var interestedObservers = [MutationObserver: InterestedObserverPairedString]()
        
        // 2. Let nodes be the inclusive ancestors of target.
        let nodes = target.inclusiveAncestors()
        
        // 3. Then, for each node in nodes, and then
        // for each registered observer (with registered observer's options as options)
        // in node's list of registered observers:
        for node in nodes {
            
            if let registeredObservers = node.mutationObserverRegistry?.registeredObservers {
            
                for (registeredObserver, options) in registeredObservers {
                
                // 1. If node is not target and options's subtree is false, continue.
                if node != target {
                    
                    if options.isOptionPresent(MutationOptionType.Subtree) {
                        
                        let subtreeOption = options.getBoolOptionValue(MutationOptionType.Subtree)
                        
                        if let subtreeOption = subtreeOption , !subtreeOption {
                            continue
                        }
                    }
                } // end 1
                
                // 2. If type is "attributes" and options's attributes is not true, continue.
                if type == §MutationRecordType.Attributes {
                    
                    if options.isOptionPresent(MutationOptionType.Attributes) {
                        
                        let attributesOption = options.getBoolOptionValue(MutationOptionType.Attributes)
                        
                        if let attributesOption = attributesOption , !attributesOption {
                            continue
                        }
                    }
                } // end 2
                
                // 3. If type is "attributes", options's attributeFilter is present,
                // and either options's attributeFilter does not contain name
                // or namespace is non-null, continue.
                if type == §MutationRecordType.Attributes {
                    
                    if options.isOptionPresent(MutationOptionType.AttributeFilter) {
                        
                        let attributesFilterArrayOption = options.getDOMStringArrayOptionValue(
                            MutationOptionType.AttributeFilter)
                        
                        // options's attributeFilter does not contain name
                        if let attributesFilterArrayOption = attributesFilterArrayOption {
                            
                            if let name = name {
                                
                                var containName: Bool = false
                                
                                for attributeFilter in attributesFilterArrayOption {
                                    if attributeFilter == name {
                                        containName = true
                                    }
                                }
                                
                                if !containName {
                                    continue
                                }
                            }
                        }
                        // namespace is non-null
                        if let _ = namespace {
                            continue
                        }
                    }
                } // end 3
                
                
                // 4. If type is "characterData" and options's characterData is not true, continue.
                if type == §MutationRecordType.CharacterData {
                    
                    if options.isOptionPresent(MutationOptionType.CharacterData) {
                        
                        let characterDataOption = options.getBoolOptionValue(MutationOptionType.CharacterData)
                        
                        if let characterDataOption = characterDataOption {
                            if !characterDataOption {
                                continue
                            }
                        }
                        else {
                            continue
                        }
                    }
                        // FIXME: make sure that if the option is not there we must also continue
                    else {
                        continue
                    }
                } // end 4
                
                // 5. If type is "childList" and options's childList is false, continue.
                if type == §MutationRecordType.ChildList {
                    
                    if options.isOptionPresent(MutationOptionType.ChildList) {
                        
                        let childListOption = options.getBoolOptionValue(MutationOptionType.ChildList)
                        
                        if let childListOption = childListOption {
                            
                            if !childListOption {
                                continue
                            }
                        }
                        else {
                            continue
                        }
                    }
                        // FIXME: make sure that if the option is not there we must also continue
                    else {
                        continue
                    }
                } // end 5
                
                // 6. If registered observer's observer is not in interested observers,
                // append registered observer's observer to interested observers.
                let interested = interestedObservers.index(forKey: registeredObserver)
                
                if !(interested != nil) {
                    interestedObservers.updateValue(InterestedObserverPairedString.None, forKey: registeredObserver)
                }
                // end 6
                
                // 7. If either type is "attributes" and options's attributeOldValue is true,
                // or type is "characterData" and options's characterDataOldValue is true,
                // set the paired string of registered observer's observer in interested observers to
                // oldValue.
                if type == §MutationRecordType.Attributes {
                    
                    if options.isOptionPresent(MutationOptionType.AttributeOldValue) {
                        
                        let attributeOldValueOption = options.getBoolOptionValue(MutationOptionType.AttributeOldValue)
                        
                        if let attributeOldValueOption = attributeOldValueOption {
                            
                            if attributeOldValueOption {
                                interestedObservers.updateValue(InterestedObserverPairedString.OldValue, forKey: registeredObserver)
                            }
                        }
                    }
                }
                else if type == §MutationRecordType.CharacterData {
                    
                    if options.isOptionPresent(MutationOptionType.CharacterDataOldValue) {
                        
                        let characterDataOldValueOption = options.getBoolOptionValue(MutationOptionType.CharacterDataOldValue)
                        
                        if let characterDataOldValueOption = characterDataOldValueOption {
                            
                            if characterDataOldValueOption {
                                
                                interestedObservers.updateValue(InterestedObserverPairedString.OldValue, forKey: registeredObserver)
                            }
                        }
                    }
                }
                // end 7
            }
            }
        }
        
        // 4. Then, for each observer in interested observers:
        for (interestedObserver, associatedString) in interestedObservers {
            
            var observerMutationRecord: MutationRecord = mutationRecord
            
            // 1. Let record be a new MutationRecord object with its type
            // set to type and target set to target.
            // Not implemented : mutationRecord is the argument
            
            // 2. If name and namespace are given, set record's attributeName to name,
            // and record's attributeNamespace to namespace.
            // Not implemented : mutationRecord is the argument
            
            // 3. If addedNodes is given, set record's addedNodes to addedNodes.
            // Not implemented : mutationRecord is the argument
            
            
            // 4. If removedNodes is given, set record's removedNodes
            // to removedNodes,
            // Not implemented : mutationRecord is the argument
            
            // 5. If previousSibling is given, set record's previousSibling
            // to previousSibling.
            // Not implemented : mutationRecord is the argument
            
            // 6. If nextSibling is given, set record's nextSibling
            // to nextSibling.
            // Not implemented : mutationRecord is the argument
            
            
            // 7. If observer has a paired string, set record's oldValue to observer's paired string.
            if associatedString == InterestedObserverPairedString.OldValue {
                
                observerMutationRecord.oldValue = §InterestedObserverPairedString.OldValue
            }
            
            // 8. Append record to observer's record queue.
            interestedObserver.appendMutationRecord(observerMutationRecord)
        }
    }

    
}
