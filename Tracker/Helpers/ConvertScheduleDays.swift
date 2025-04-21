//
//  ConvertScheduleDays.swift
//  Tracker
//
//  Created by 1111 on 02.04.2025.
//

import Foundation

final class ConvertScheduleDays {
    private let localizableStrings: LocalizableStringsNewHabitOrNonRegularEventVC = LocalizableStringsNewHabitOrNonRegularEventVC()
    
    func convertStringDaysToInt(_ stringDays: [String]) -> [Int] {
        let dayNumbers: [String : Int] = [
            localizableStrings.mondayLoc : 2,
            localizableStrings.tuesdayLoc : 3,
            localizableStrings.wednesdayLoc : 4,
            localizableStrings.thursdayLoc : 5,
            localizableStrings.fridayLoc : 6,
            localizableStrings.saturdayLoc : 7,
            localizableStrings.sundayLoc : 1
        ]
        
        return stringDays.compactMap { dayNumbers[$0] }
    }
    
    func convertIntDaysToStringDays(_ intDays: [Int]) -> [String] {
        let dayNumbers: [Int : String] = [
            2 : localizableStrings.mondayLoc,
            3 : localizableStrings.tuesdayLoc,
            4 : localizableStrings.wednesdayLoc,
            5 : localizableStrings.thursdayLoc,
            6 : localizableStrings.fridayLoc ,
            7 : localizableStrings.saturdayLoc,
            1 : localizableStrings.sundayLoc
        ]
        
        return intDays.compactMap { dayNumbers[$0] }
    }
    
    func convertIntDaysToShortStringDays(_ intDays: [Int]) -> [String] {
        let dayNumbers: [Int : String] = [
            2 : localizableStrings.monLoc,
            3 : localizableStrings.tueLoc,
            4 : localizableStrings.wedLoc,
            5 : localizableStrings.thursLoc,
            6 : localizableStrings.friLoc ,
            7 : localizableStrings.satLoc,
            1 : localizableStrings.sunLoc
        ]
        
        return intDays.compactMap { dayNumbers[$0] }
    }
    
    func convertStringDaysToShortStringDays(_ stringDays: [String]) -> [String] {
        let longNameStringDays: [String : String] = [
            localizableStrings.mondayLoc : localizableStrings.monLoc,
            localizableStrings.tuesdayLoc : localizableStrings.tueLoc,
            localizableStrings.wednesdayLoc : localizableStrings.wedLoc,
            localizableStrings.thursdayLoc : localizableStrings.thursLoc,
            localizableStrings.fridayLoc : localizableStrings.friLoc,
            localizableStrings.saturdayLoc : localizableStrings.satLoc,
            localizableStrings.sundayLoc : localizableStrings.sunLoc
        ]
        
        return stringDays.compactMap { longNameStringDays[$0] }
    }
}


