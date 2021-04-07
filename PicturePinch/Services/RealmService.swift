//
//  RealmService.swift
//  TaxiID Klant v2
//
//  Created by Danny Grob on 18/12/2021.
//

import Foundation
import RealmSwift

class RealmService {
    
    static var defaultRealm:Realm {
        let documentDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask,
                                                        appropriateFor: nil, create: false)
        let url = documentDirectory.appendingPathComponent("picturepinch.realm")
        
        let config = Realm.Configuration(fileURL: url, schemaVersion: 3, migrationBlock: { migration, oldSchemaVersion in
            
        })
        
        let realm = try! Realm(configuration: config)
        return realm
        
    }
    
    public static func write(_ writeClosure: () -> ()) {
        if defaultRealm.isInWriteTransaction {
            writeClosure()
            return
        }
        do {
            try defaultRealm.write {
                writeClosure()
            }
        } catch {
            print("Could not write to database: \(error.localizedDescription)")
        }
    }
}
