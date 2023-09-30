//
//  StringFormatter.swift
//  BitmexClone
//
//  Created by 경원이 on 2023/09/30.
//

import Foundation

extension String {
    
    func hhmmssString() -> String {
        // DateFormatter 객체 생성
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" // 주어진 형식에 맞게 설정
        
        // UTC 시간대로 설정
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        // 문자열을 Date 객체로 변환
        if let date = dateFormatter.date(from: self) {
            // 한국 시간대로 변경
            dateFormatter.timeZone = TimeZone(abbreviation: "KST") // 한국 표준시 (Korean Standard Time)
            
            // Date 객체를 문자열로 변환
            dateFormatter.dateFormat = "HH:mm:ss"
            let koreanTimeString = dateFormatter.string(from: date)
            return koreanTimeString
        } else {
            return ""
        }
    }
}
