//
//  Recognizer.swift
//  moodplay
//
//  Created by Pasquale Spisto on 19/12/2017.
//  Copyright © 2017 Pasquale Spisto. All rights reserved.
//

import Foundation
import HealthKit

let SECOND_TO_HR = 3600
let DAY_MILLISECOND = Double(60 * 60 * 24)

class Recognizer {
    
    static public let shared = Recognizer()
    
    public var bpmRate : Int = 0
    //    public var sportFlag : Bool = false
    public var workHR : Int = 0
    //    public var workSatisFlag : Bool = false
    //    public var sleepHR : Int = 0
    //    public var weatherFlag : Bool = false
    
    public var sadPercentage : Int = 0
    public var happyPercentage : Int = 0
    public var motivatedPercentage : Int = 0
    
    public var healtStore = HKHealthStore()
    public var recognizedMood = "default"
    public var recognitionTime = "Not avaible"
    
    private init(){ }
    
    func allowToShareSleepAnalysis(){
        let argumentsToRead : Set<HKObjectType> = [HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis)!]
        
        self.healtStore.requestAuthorization(toShare: nil, read: argumentsToRead){
            (success, error) -> Void in
            
            if success == false {
                //In this part an allert appear
                //Disable from Recognizer Sleep information
            }
        }
    }
    
    
    func calculetSleepHours() -> Double {
        
        
        var asleepTime : Double = 0
        
        //        let calendar = NSCalendar.current
        //        let now = NSDate()
        //        var components = calendar.component(Calendar.Component.year, from: now as Date)
        //        components
        //
        //        let startDate = calendar.dateFromComponents(components)
        //
        //        let endDate = calendar.dateByAddingUnit(.Day, value: 1, toDate: startDate, options: [])
        //
        //
        //        let intervalQuery = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        
        
        let sleptHours = HKCategoryType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis)
        
        let sleptHoursSampleQuery = HKSampleQuery(sampleType: sleptHours!, predicate: nil, limit: (Int(HKObjectQueryNoLimit)), sortDescriptors: nil) {
            (query, tmpResults, error) in
            
            if let results = tmpResults as? [HKCategorySample] {
                for item in results{
                    asleepTime = (item.startDate.timeIntervalSince(item.endDate) / Double(SECOND_TO_HR))
                    //                    if let sample = item as? HKCategorySample {
                    //                        let value = (sample.value == HKCategoryValueSleepAnalysis.inBed.rawValue) ? "InBed" : "Asleep"
                    //                        print("Healthkit sleep: \(sample.startDate) \(sample.endDate) - value: \(value)")
                    //
                    //                    }
                    //                    if item.value == HKCategoryValueSleepAnalysis.asleep.rawValue {
                    //
                    //                        asleepTime = (item.startDate.timeIntervalSince(item.endDate) / Double(SECOND_TO_HR))
                    //
                }
                print(abs(asleepTime))
            }
        }
        
        self.healtStore.execute(sleptHoursSampleQuery)
        
        return abs(asleepTime)
    }
    
    
    func evaluateBPM(sportFlag: Bool, bpmRate: Int) -> [Int] {
        
        var sadValue = 0
        var happyValue = 0
        var motivatedValue = 0
        
        if (sportFlag){         //se la persona è sportiva
            
            //valutazione bpm rate
            if (bpmRate < 50){
                //song.bpmRate massimo settato a 90 bpm
                
                //Valori percentuali per i 3 mood di riferimento
                sadValue = 5                    //60%
                happyValue = 4                  //30%
                motivatedValue = 1              //10%
            }
            else if (bpmRate >= 50 && bpmRate < 70){
                //song.bpmRate settato tra 90 e 130 bpm
                
                //Valori percentuali per i 3 mood di riferimento
                sadValue = 2                    //20%
                happyValue = 6                  //60%
                motivatedValue = 2              //20%
                
            } else if (bpmRate >= 70 && bpmRate < 90){
                //song.bpmRate settato tra 130 e 200 bpm
                
                //Valori percentuali per i 3 mood di riferimento
                
                sadValue = 1                    //10%
                happyValue = 5                  //50%
                motivatedValue = 4              //40%
                
            } else {
                
                //Valori percentuali per i 3 mood di riferimento
                sadValue = 1                    //10%
                happyValue = 3                  //30%
                motivatedValue = 6              //60%
            }
            
        } else {                //se la persona non è sportiva
            
            //valutazione bpm rate
            if (bpmRate < 60){
                //song.bpmRate massimo settato a 90 bpm
                
                //Valori percentuali per i 3 mood di riferimento
                sadValue = 5                    //60%
                happyValue = 4                  //30%
                motivatedValue = 1              //10%
            }
            else if (bpmRate >= 60 && bpmRate < 75){
                //song.bpmRate settato tra 90 e 130 bpm
                
                //Valori percentuali per i 3 mood di riferimento
                sadValue = 2                    //10%
                happyValue = 6                  //50%
                motivatedValue = 2              //40%
                
            } else if (bpmRate >= 75 && bpmRate < 90){
                //song.bpmRate settato tra 130 e 160 bpm
                
                //Valori percentuali per i 3 mood di riferimento
                sadValue = 1                    //10%
                happyValue = 5                  //10%
                motivatedValue = 4              //10%
                
            } else {
                //song.bpmRate minimo settato a 160 bpm+
                
                //Valori percentuali per i 3 mood di riferimento
                sadValue = 1                    //10%
                happyValue = 3                  //10%
                motivatedValue = 6              //10%
            }
            
        }
        
        //Ritorno i tre valori mood
        return [sadValue, happyValue, motivatedValue]
    }
    
    
    
    func evaluateWorkHR(workSatisFlag: Bool, workHRValue: Int) -> [Int] {
        
        var sadValue = 0
        var happyValue = 0
        var motivatedValue = 0
        
        if (workSatisFlag){                 //la persona è soddisfatta del proprio lavoro/studio
            if (workHRValue >= 0 && workHRValue < 2){
                happyValue = 10                     //100%
                
            } else if (workHRValue == 2 || workHRValue == 3) {
                happyValue = 5                      //50%
                motivatedValue = 5                  //50%
                
            } else if (workHRValue >= 4 && workHRValue < 7){
                motivatedValue = 8
                happyValue = 2
                
            } else if (workHRValue == 7 || workHRValue == 8){
                motivatedValue = 5
                happyValue = 4
                sadValue = 1
                
            } else if (workHRValue >= 9 && workHRValue <= 12){
                sadValue = 7
                happyValue = 3
                
            }
        } else {                            // la persona non è soddisfatta del proprio lavoro/studio
            if (workHRValue == 0){
                motivatedValue = 10
                
            } else if (workHRValue == 1 || workHRValue == 2){
                motivatedValue = 5
                happyValue = 5
                
            } else if (workHRValue == 3){
                happyValue = 7
                motivatedValue = 2
                sadValue = 1
                
            } else if (workHRValue == 4 || workHRValue == 5){
                happyValue = 5
                sadValue = 5
                
            } else if (workHRValue >= 6 && workHRValue <= 12){
                happyValue = 2
                sadValue = 8
            }
        }
        return [sadValue, happyValue, motivatedValue]
    }
    
    
    func evaluateSleepHR(sleepHRValue: Int) -> [Int] {
        
        var sadValue = 0
        var happyValue = 0
        var motivatedValue = 0
        
        if (sleepHRValue >= 0 && sleepHRValue < 5) {
            sadValue = 8
            happyValue = 2
            
        } else if (sleepHRValue == 5 || sleepHRValue == 6) {
            sadValue = 4
            happyValue = 6
            
        } else if (sleepHRValue > 6 && sleepHRValue < 8) {
            happyValue = 8
            motivatedValue = 2
            
        } else if (sleepHRValue == 8 || sleepHRValue == 9) {
            motivatedValue = 5
            happyValue = 5
            
        } else if (sleepHRValue > 9 && sleepHRValue <= 11) {
            motivatedValue = 6
            happyValue = 3
            sadValue = 1
            
        } else if (sleepHRValue > 11) {
            sadValue = 10
            
            
        }
        
        return [sadValue, happyValue, motivatedValue]
        
    }
    
    
    
    func evaluateWeather(weatherFlag: Bool) -> [Int] {
        
        let weatherCondition : String = "cloudy"
        
        var sadValue = 0
        var happyValue = 0
        var motivatedValue = 0
        
        if (weatherFlag){
            
            if(weatherCondition == "rainy"){
                sadValue = 9
                happyValue = 1
                
            }
            if(weatherCondition == "cloudy"){
                sadValue = 3
                happyValue = 7
                
            }
            if(weatherCondition == "sunny"){
                happyValue = 6
                motivatedValue = 4
                
            }
        } else {
            
            if(weatherCondition == "rainy"){
                sadValue = 5
                happyValue = 5
                
            }
            if(weatherCondition == "cloudy"){
                sadValue = 1
                happyValue = 8
                motivatedValue = 1
                
            }
            if(weatherCondition == "sunny"){
                happyValue = 6
                motivatedValue = 4
            }
        }
        return [sadValue, happyValue, motivatedValue]
    }
    
    
    
    func recognizeMood() {
        
        //Setto le variabili per il calcolo finale
        var bpmMoodValue = evaluateBPM(sportFlag: User.shared.musicFlag, bpmRate: bpmRate)
        var workMoodValue = evaluateWorkHR(workSatisFlag: User.shared.workSatisfactionFlag, workHRValue: self.workHR)
        
        var sleepMoodValue = evaluateSleepHR(sleepHRValue: Int(self.calculetSleepHours()))
        var weatherMoodValue = evaluateWeather(weatherFlag: User.shared.weatherFlag)
        
        //Moltiplico per la priorità che ogni valore ha sul riconoscimento
        
        for item in 0...(bpmMoodValue.count - 1){
            bpmMoodValue[item] = bpmMoodValue[item] * 2
        }
        
        for item in 0...(workMoodValue.count - 1) {
            workMoodValue[item] = workMoodValue[item] * 4
        }
        
        for item in 0...(sleepMoodValue.count - 1) {
            sleepMoodValue[item] = sleepMoodValue[item] * 3
        }
        
        for item in 0...(weatherMoodValue.count - 1) {
            weatherMoodValue[item] = weatherMoodValue[item]
        }
        
        //Valutazione finale del mood
        var moodValue = [0, 0, 0]
        var finalMoodValue = [0.0, 0.0, 0.0]
        
        for index in 0...(finalMoodValue.count - 1) {
            moodValue[index] = bpmMoodValue[index] + workMoodValue[index] + sleepMoodValue[index] + weatherMoodValue[index]
            finalMoodValue[index] = Double(moodValue[index])
        }
        print("\(finalMoodValue[0]) % SAD - \(finalMoodValue[1]) % HAPPY - \(finalMoodValue[2]) % MOTIVATED")
        self.sadPercentage = Int(finalMoodValue[0])
        self.happyPercentage = Int(finalMoodValue[1])
        self.motivatedPercentage = Int(finalMoodValue[2])
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        self.recognitionTime = formatter.string(from: Date())
        
        
    }
    
    
    func retriverDominantMood() -> Mood {
        let percentages = [self.sadPercentage, self.happyPercentage, self.motivatedPercentage]
        let moods = ["sad", "happy", "motivated"]
        let indexMax = percentages.index(of: percentages.max()!)
        
        let realMood = MoodDAO.shared.readObjectFromCloud(id: moods[indexMax!]) as! Mood
        
        return realMood
    }
    
    
}

