//
//  GlobalQueue.swift
//  Kiwix
//
//  Created by Chris Li on 5/14/16.
//  Copyright © 2016 Chris Li. All rights reserved.
//

import ProcedureKit

class GlobalQueue: ProcedureQueue {
    static let shared = GlobalQueue()
    override private init() {}
    
    private weak var scanOperation: ScanLocalBookOperation?
    func add(scanOperation: ScanLocalBookOperation) {
        add(operation: scanOperation)
        self.scanOperation = scanOperation
    }
    
    private weak var search: SearchProcedure?
    func add(searchProcedure: SearchProcedure) {
        if let scanOperation = scanOperation {
            searchProcedure.addDependency(scanOperation)
        }
        
        if let search = self.search {
            search.cancel()
        }
        add(operation: searchProcedure)
        self.search = searchProcedure
    }
    
    private weak var articleLoadOperation: ArticleLoadOperation?
    func add(articleLoad operation: ArticleLoadOperation) {
        if let scanOperation = scanOperation {
            operation.addDependency(scanOperation)
        }
        
        if let articleLoadOperation = self.articleLoadOperation {
            articleLoadOperation.addDependency(articleLoadOperation)
        }
        
        add(operation: operation)
        self.articleLoadOperation = operation
    }
    
    private weak var presentOperation: PresentOperation?
    func add(presentOperation operation: PresentOperation) {
        if let scanOperation = scanOperation {
            operation.addDependency(scanOperation)
        }
        
        add(operation: operation)
        self.presentOperation = operation
    }
}

class UIQueue: ProcedureQueue {
    static let shared = ProcedureQueue()
    override private init() {}
}
