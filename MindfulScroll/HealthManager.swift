
import Foundation
import HealthKit

class HealthManager {
    let healthStore = HKHealthStore()
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false)
            return
        }
        
        let typesToShare: Set = []
        let typesToRead: Set = [HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!]
        
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { success, error in
            completion(success)
        }
    }
    
    func getWalkingDistance(completion: @escaping (Double) -> Void) {
        guard let distanceType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning) else {
            completion(0.0)
            return
        }
        
        let startDate = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: distanceType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            let distance = result?.sumQuantity()?.doubleValue(for: HKUnit.meter()) ?? 0
            completion(distance / 1000) // Convert meters to kilometers
        }
        
        healthStore.execute(query)
    }
}
