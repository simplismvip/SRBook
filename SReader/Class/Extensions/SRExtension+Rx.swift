//
//  SRExtension+Rx.swift
//  SReader
//
//  Created by JunMing on 2021/8/16.
//

import UIKit
import RxSwift

extension Observable where Element: FloatingPoint {
    public static func timer(duration: TimeInterval = TimeInterval.infinity, interval: TimeInterval = 1, ascending: Bool = false, scheduler: SchedulerType = MainScheduler.instance) -> Observable<TimeInterval> {
        let count = (duration == TimeInterval.infinity) ? .max:Int(duration/interval) + 1
        let dueTime = DispatchTimeInterval.seconds(0)
        let preiod = DispatchTimeInterval.seconds(Int(interval))
        return Observable<Int>.timer(dueTime, period: preiod, scheduler: scheduler)
            .map { TimeInterval($0) * interval }
            .map { ascending ? $0 : (duration - $0 ) }
        .take(count)
    }
}
