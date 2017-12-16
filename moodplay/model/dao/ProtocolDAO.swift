//
//  ProtocolDAO.swift
//  moodplay
//
//  Created by Pasquale on 14/12/17.
//  Copyright © 2017 Pasquale. All rights reserved.
//

import Foundation

@objc protocol ProtocolDAO {
    
    func writeObjectToCloud(object: AnyObject)
    func readObjectFromCloud(id: String) -> AnyObject
    func deleteRecord(id: String)
    func updateRecord(id: String, object: AnyObject)
    @objc optional func fetchObjects(field: String, equalTo: String) -> [AnyObject]
}
