//
//  CommunityRegisterTeambuildViewModel.swift
//  Moa
//
//  Created by won heo on 2021/11/23.
//

import Foundation

import RxSwift
import RxCocoa

final class CommunityRegisterTeambuildViewModel: ViewModelType {
    struct Input {
        let changeTeambuildEndDate: Signal<Date>
        let changeCompetitionStartDate: Signal<Date>
        let changeCompetitionEndDate: Signal<Date>
        let addTag: Signal<String?>
        let removeTag: Signal<String?>
    }
    
    struct Output {
        let teambuildEndDateTitle: Driver<String>
        let competitionStartDateTitle: Driver<String>
        let competitionEndDateTitle: Driver<String>
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    private let disposeBag = DisposeBag()
    
    private var selectedTags = [String]()
    var tags = ["개발자", "디자이너", "기획자", "기타"]
    
    func transform(input: Input) -> Output {
        let teambuildEndDateTitle = BehaviorRelay<String>(value: "날짜를 선택하세요")
        let competitionStartDateTitle = BehaviorRelay<String>(value: "날짜를 선택하세요")
        let competitionEndDateTitle = BehaviorRelay<String>(value: "날짜를 선택하세요")
        
        input.changeTeambuildEndDate
            .map { self.dateFormatter.string(from: $0) }
            .emit(to: teambuildEndDateTitle)
            .disposed(by: disposeBag)
        
        input.changeCompetitionStartDate
            .map { self.dateFormatter.string(from: $0) }
            .emit(to: competitionStartDateTitle)
            .disposed(by: disposeBag)
        
        input.changeCompetitionEndDate
            .map { self.dateFormatter.string(from: $0) }
            .emit(to: competitionEndDateTitle)
            .disposed(by: disposeBag)
        
        input.addTag
            .compactMap { $0 }
            .emit { [weak self] (tag: String) in
                guard let self = self else { return }
                self.selectedTags.append(tag)
            }
            .disposed(by: disposeBag)
        
        input.removeTag
            .compactMap { $0 }
            .emit { [weak self] (tag: String) in
                guard let self = self else { return }
                self.selectedTags = self.selectedTags.filter { $0 != tag }
            }
            .disposed(by: disposeBag)
        
        return Output(
            teambuildEndDateTitle: teambuildEndDateTitle.asDriver(),
            competitionStartDateTitle: competitionStartDateTitle.asDriver(),
            competitionEndDateTitle: competitionEndDateTitle.asDriver()
        )
    }
}
