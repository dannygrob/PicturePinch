//
//  LanguageService.swift
//  PicturePinch
//
//  Created by Danny Grob on 18/12/2021.
//

import Foundation
import SwiftyJSON

extension String {
    func translate() -> String {
        return LanguageService.shared.translation(for: self)
    }
}

class LanguageService {
    static let shared:LanguageService = LanguageService()
    
    var languageDict:[String:Any]?
    var currentLanguage:String = "default"
    
    init() {
        fetchFromCache()
    }
    
    func setLanguage() {
        let current = Locale.preferredLanguages.first?.components(separatedBy: "-").first?.lowercased()
        
        if let lkeys = languageDict?.keys {
            let keys = Array(lkeys)
            for key in keys {
                let language = key as String
                if let first = language.components(separatedBy: "-").first?.lowercased(), first == current {
                    currentLanguage = language
                    return
                }
            }
        }
        
    }
    
    func translation(for key:String) -> String {
        guard let dict = self.languageDict else {
            fetchFromCache()
            return key
        }
        
        if let lang = dict[currentLanguage] as? [String: Any?] {
            return (lang[key.lowercased()] as? String) ?? key
        }
        
        return key
    }
    
    func fetchFromCache() {
        if let data = try? load(withFilename: "language"), let json = try? JSON.init(data: data) {
            languageDict = json.dictionaryObject
        }
    }
    
    func fetchFromServer(completion: @escaping (Bool) -> Void) {
        fatalError("Not implemented")
    }
    
    func load(withFilename filename: String) throws -> Data? {
        
        if let filePath = Bundle.main.path(forResource: filename, ofType: "json") {
            let fileURL = URL(fileURLWithPath: filePath)
            let data = try Data(contentsOf: fileURL)
            return data
        }
        return nil
    }
}
