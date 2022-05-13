//
//  main.swift
//  CodeStarterCamp_Week4
//
//  Created by yagom.
//  Copyright © yagom academy. All rights reserved.
//

import Foundation

class FitnessCenter {
    let name: String
    var goalsBodyCondition: BodyCondition?
    var member: Person?
    var routines: [Routine]
    let fitnessCenterKiosk = FitnessCenterKiosk()
    
    init(name: String, routines: Routine...) {
        self.name = name
        self.routines = routines
    }
    
    func startFitnessKiosk() throws {
        var isAchieveGoal = false
        var kioskStep = 1
        var chosenRoutine: Routine?
        print(newLineString)
        print("안녕하세요. \(name) Fitness Center 입니다.")
        while !isAchieveGoal {
            if kioskStep == 1 {
                fitnessCenterKiosk.printMessageByStep(nowStep: kioskStep)
                if let memberName = fitnessCenterKiosk.receiveEnglishName() {
                    setMember(with: memberName)
                    kioskStep += 1
                    continue
                }
            } else if kioskStep == 2 {
                fitnessCenterKiosk.printMessageByStep(nowStep: kioskStep)
                if let goals = fitnessCenterKiosk.receiveGoals() {
                    if goals.count == 3 {
                        setGoalsBodyCondition(by: goals)
                        kioskStep += 1
                    }
                }
            } else if kioskStep == 3 {
                chosenRoutine = nil
                fitnessCenterKiosk.printMessageByStep(nowStep: kioskStep)
                introduceRoutines()
                if let chosenNumberOfRoutine = fitnessCenterKiosk.receiveNaturalNumber() {
                    chosenRoutine = routines[chosenNumberOfRoutine-1]
                    if chosenRoutine != nil {
                        kioskStep += 1
                    }
                }
            } else {
                fitnessCenterKiosk.printMessageByStep(nowStep: kioskStep)
                guard let chosenRoutine = chosenRoutine else {
                    throw FitnessCenterError.emptyChosenRoutine
                }
                guard let member = member else {
                    throw FitnessCenterError.emptyMember
                }
                if let chosenNumberOfSet = fitnessCenterKiosk.receiveNaturalNumber() {
                    do {
                        try member.exercise(for: chosenNumberOfSet, chosenRoutine)
                    } catch PersonError.personBeDrained {
                        throw FitnessCenterError.memberBeDrained
                    }
                }
            }
        }
    }
    
    func setMember(with name: String) {
        member = Person(name: name, bodyCondition: BodyCondition(upperBodyStrength: 30, lowerBodyStrength: 30, muscleEndurance: 10))
    }
    
    func setGoalsBodyCondition(by goals: [Int]) {
        goalsBodyCondition = BodyCondition(upperBodyStrength: goals[0], lowerBodyStrength: goals[1], muscleEndurance: goals[2])
    }
    
    func introduceRoutines() {
        for routineCount in 1...routines.count {
            print("\(routineCount). \(routines[routineCount-1].name)")
        }
    }
    
    func checkGoals(target bodyCondition: BodyCondition) -> Result<Bool, FitnessCenterError> {
        if let goalsBodyCondition = goalsBodyCondition {
            if goalsBodyCondition.upperBodyStrength <= bodyCondition.upperBodyStrength && goalsBodyCondition.lowerBodyStrength <= bodyCondition.lowerBodyStrength && goalsBodyCondition.muscleEndurance <= bodyCondition.muscleEndurance {
                return .success(true)
            } else {
                return .success(false)
            }
        }
        return .failure(.emptyGoalsBodyCondition)
    }
    
    func printRoutineAchieveMessage(_ isAchieve: Bool) {
        print(newLineString)
        if isAchieve {
            print("축하합니다. 목표를 달성하셨습니다! ", terminator: "")
        } else {
            print("목표치에 도달하지 못했습니다! ", terminator: "")
        }
        member?.printMyBodyCondition() ?? printFitnessCenterErrorMessage(about: .emptyMember)
    }
}
