//
//  SpecialRules.swift
//  Livr
//
//  Created by Felipe Lefèvre Marino on 9/25/18.
//  Copyright © 2018 Felipe Marino. All rights reserved.
//

typealias URLType = URL

struct SpecialRules {
    
    // must be a valid URL
    struct URL: LivrRule, PreDefinedRule {
        static var name = "url"
        var errorCode = "WRONG_URL"
        let regex = "^(?:(?:http|https|HTTP|HTTPS)://)(?:\\S+(?::\\S*)?@)?(?:(?:(?:[1-9]\\d?|1\\d\\d|2[0-1]\\d|22[0-3])(?:\\.(?:1?\\d{1,2}|2[0-4]\\d|25[0-5])){2}(?:\\.(?:[0-9]\\d?|1\\d\\d|2[0-4]\\d|25[0-4]))|(?:(?:[a-z\\u00a1-\\uffff0-9]-*)*[a-z\\u00a1-\\uffff0-9]+)(?:\\.(?:[a-z\\u00a1-\\uffff0-9]-*)*[a-z\\u00a1-\\uffff0-9]+)*(?:\\.(?:[a-z\\u00a1-\\uffff]{2,})))\\.?|localhost)(?::\\d{2,5})?(?:[/?#]\\S*)?$"
        var arguments: Any?
        
        init() {}
        
        func validate(value: Any?) -> (Errors?, UpdatedValue?) {
            if Utils.hasNoValue(value) { return (nil, nil) }
            if let value = value {
                if !Utils.isPrimitive(value: value) { return (String.formatErrorCode, nil) }
                
                let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
                if let stringValue = value as? String,
                    stringValue.count < 2083, predicate.evaluate(with: stringValue) {
                        return (nil, nil)
                }
                return (errorCode, nil)
            }
            return (nil, nil)
        }
    }
    
    // must be a valid email
    struct Email: LivrRule, PreDefinedRule {
        static var name = "email"
        var errorCode = "WRONG_EMAIL"
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        var arguments: Any?
        
        init() {}
        
        func validate(value: Any?) -> (Errors?, UpdatedValue?) {
            if Utils.hasNoValue(value) { return (nil, nil) }
            if let value = value {
                if !Utils.isPrimitive(value: value) { return (String.formatErrorCode, nil) }
                
                let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
                if let stringValue = value as? String, predicate.evaluate(with: stringValue) {
                    return (nil, nil)
                }
                return (errorCode, nil)
            }
            return (nil, nil)
        }
    }
    
    // must be a valid email
    struct ISODate: LivrRule, PreDefinedRule {
        static var name = "iso_date"
        var errorCode = "WRONG_DATE"
        var arguments: Any?
        
        init() {}
        
        func validate(value: Any?) -> (Errors?, UpdatedValue?) {
            if Utils.hasNoValue(value) { return (nil, nil) }
            if let value = value {
                if !Utils.isPrimitive(value: value) { return (String.formatErrorCode, nil) }
                
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                
                if let stringValue = value as? String, formatter.date(from: stringValue) != nil {
                    return (nil, nil)
                }
                return (errorCode, nil)
            }
            return (nil, nil)
        }
    }
    
    struct EqualToField: LivrRule, PreDefinedRule {
        static var name = "equal_to_field"
        var errorCode = "FIELDS_NOT_EQUAL"
        var arguments: Any?
        var otherFieldValue: Any?
        
        init() {}
        
        func validate(value: Any?) -> (Errors?, UpdatedValue?) {
            if Utils.hasNoValue(value) { return (nil, nil) }
            if let value = value {
                if !Utils.isPrimitive(value: value) { return (String.formatErrorCode, nil) }
                
                if let otherFieldValue = otherFieldValue, String(describing: value) == String(describing: otherFieldValue) {
                    return (nil, nil)
                }
                return (errorCode, nil)
            }
            return (nil, nil)
        }
    }
    
}
