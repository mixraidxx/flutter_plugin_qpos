//
//  Test.swift
//  flutter_plugin_qpos
//
//  Created by David Enriquez solis on 17/03/22.
//

import Foundation

@objc class TestSwift: NSObject {
    
    override init() {
        print("init testSwift");
    }
    
    @objc
    func hello(){
        print("Hola mundo")
    }
    
    @objc
    func TLVParse(tlv : String) -> String{
        let result = TLVParser.parse(tlv)
        var test: [TLVTag] = []
        var jsonString = ""
        result.forEach { tag in
            print("tag: \(tag.tag), value: \(tag.value)")
            test.append(TLVTag(tag: tag.tag, value: tag.value))
        }
        
        let encodedData = try! JSONEncoder().encode(test)
        jsonString = String(data: encodedData, encoding: .utf8) ?? ""
        print("jsonString: \(jsonString)")
        return jsonString
}
}

struct TLVTag: Codable {
    var tag: String
    var value: String
}

extension Array {
    public func toDictionary<Key: Hashable>(with selectKey: (Element) -> Key) -> [Key:Element] {
        var dict = [Key:Element]()
        for element in self {
            dict[selectKey(element)] = element
        }
        return dict
    }
}
