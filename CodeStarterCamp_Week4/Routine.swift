//
//  Routine.swift
//  CodeStarterCamp_Week4
//
//  Created by tom on 2023/03/15.
//

import Foundation


final class Routine {
    let name: String
    let activities : [Activity]
    
    init(name: String, activities: [Activity]) {
        self.name = name
        self.activities = activities
    }
    ///피로도
    private func fatigueError(condition: BodyCondition) {
        do {
            try fatigueCheck(fatigue:condition)
        } catch ActivityError.overFatigueError { // 밑에 함수 받으면 에러 메시지
            print("피로도가 100(이/가)이 넘어 운동진행 불가")
        } catch {
            print(error)
        }
    }
    
    private func fatigueCheck(fatigue: BodyCondition) throws {
        guard fatigue.fatigue < 100 else { //피로도 100 넘으면 에러던지기
            throw ActivityError.overFatigueError
        }
    }
    
    ///리드라인
    func readLineInputError(activities: [Activity], bodyCondition: BodyCondition) {
        do {
            try healthRoutine(bodyCondition: bodyCondition)
        } catch ActivityError.inputError {
            print("잘못된 입력 형식입니다. 다시 입력해주세요.")
            readLineInputError(activities: activities, bodyCondition: bodyCondition)  // 본인을 호출한이유 do에 함수 실행시키기
        } catch {
            print(error)
        }
    }
    
    private func healthRoutine(bodyCondition: BodyCondition) throws {
        print("루틴을 몇 번 반복할까요?", terminator: " ")
        if let input = readLine()  { // 생성  강제! 없이 어떻게 만들지..
            guard let routineIntInput = Int(input) else {throw ActivityError.inputError} // 인트로변경하고 변경되면 포문 안되면 에러
            for routineCount in abs(0)..<abs(routineIntInput) {
                print("\(routineCount + 1) 번째 hellRoutine을(를) 시작합니다.")
                for activity in activities {
                    Activity.exerciseStart(activity: activity, bodyCondition: bodyCondition)
                    if bodyCondition.fatigue > 100 {
                        fatigueError(condition: bodyCondition)
                        return bodyCondition.nowBodyCondition(bodyCondition)
                    }
                }
            }
            bodyCondition.nowBodyCondition(bodyCondition)
        }
    }
}
