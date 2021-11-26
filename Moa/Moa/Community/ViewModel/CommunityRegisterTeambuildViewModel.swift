//
//  CommunityRegisterTeambuildViewModel.swift
//  Moa
//
//  Created by won heo on 2021/11/23.
//

import Foundation

import RxSwift
import RxCocoa
import Moya

final class CommunityRegisterTeambuildViewModel: ViewModelType {
    struct Input {
        let changeTeambuildEndDate: Signal<Date>
        let changeCompetitionStartDate: Signal<Date>
        let changeCompetitionEndDate: Signal<Date>
        let changeImage: Signal<UIImage>
        let changeContent: Signal<String>
        let changeTitle: Signal<String>
        let addTag: Signal<String?>
        let removeTag: Signal<String?>
        let moaButtonTapped: Signal<Void>
    }
    
    struct Output {
        let teambuildEndDateTitle: Driver<String>
        let competitionStartDateTitle: Driver<String>
        let competitionEndDateTitle: Driver<String>
        let alertMessage: Signal<String>
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    private let moaProvider: MoyaProvider<MoaAPI>
    
    init() {
        let loggerConfig = NetworkLoggerPlugin.Configuration(logOptions: .verbose)
        let networkLogger = NetworkLoggerPlugin(configuration: loggerConfig)
        moaProvider = MoyaProvider<MoaAPI>(plugins: [networkLogger])
    }
    
    private let teambuildEndDate = BehaviorRelay<Date>(value: Date())
    private let competitionStartDate = BehaviorRelay<Date>(value: Date())
    private let competitionEndDate = BehaviorRelay<Date>(value: Date())
    private let competitionImage = BehaviorRelay<UIImage>(value: UIImage())
    private let competitionContent = BehaviorRelay<String>(value: "")
    private let competitionTitle = BehaviorRelay<String>(value: "")
    private let disposeBag = DisposeBag()
    
    private var selectedTags = [String]()
    var tags = ["개발자", "디자이너", "기획자", "기타"]
        
    func transform(input: Input) -> Output {
        let teambuildEndDateTitle = BehaviorRelay<String>(value: "날짜를 선택하세요")
        let competitionStartDateTitle = BehaviorRelay<String>(value: "날짜를 선택하세요")
        let competitionEndDateTitle = BehaviorRelay<String>(value: "날짜를 선택하세요")
        let alertMessage = PublishRelay<String>()

        input.changeTeambuildEndDate
            .map { self.dateFormatter.string(from: $0) }
            .emit(to: teambuildEndDateTitle)
            .disposed(by: disposeBag)
        
        input.changeTeambuildEndDate
            .emit(to: self.teambuildEndDate)
            .disposed(by: disposeBag)
        
        input.changeCompetitionStartDate
            .map { self.dateFormatter.string(from: $0) }
            .emit(to: competitionStartDateTitle)
            .disposed(by: disposeBag)
        
        input.changeCompetitionStartDate
            .emit(to: self.competitionStartDate)
            .disposed(by: disposeBag)
        
        input.changeCompetitionEndDate
            .map { self.dateFormatter.string(from: $0) }
            .emit(to: competitionEndDateTitle)
            .disposed(by: disposeBag)
        
        input.changeCompetitionEndDate
            .emit(to: self.competitionEndDate)
            .disposed(by: disposeBag)
        
        input.changeContent
            .emit(to: self.competitionContent)
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
        
        input.changeImage
            .emit(to: self.competitionImage)
            .disposed(by: disposeBag)
        
        input.changeContent
            .emit(to: self.competitionContent)
            .disposed(by: disposeBag)
        
        input.moaButtonTapped
            .asObservable()
            .filter { [weak self] (_: Void) in
                guard let self = self else { return false }
                
                let endMonth = self.competitionEndDate.value.component(.month)
                let endDay = self.competitionEndDate.value.component(.day)
                let startMonth = self.competitionStartDate.value.component(.month)
                let startDay = self.competitionStartDate.value.component(.day)
                
                guard startMonth * 10 + startDay <= endMonth  * 10 + endDay else {
                    alertMessage.accept("올바른 공모전 기간을 설정해주세요")
                    return false
                }
                
                return true
            }
            .flatMap { [weak self] () -> Single<Response> in
                guard let self = self else { return Single<Response>.error(MoaError.flatMap) }
                var formData: [MultipartFormData] = []
                
                formData.append(MultipartFormData(
                    provider: .data("\(teambuildEndDateTitle)".data(using: .utf8)!),
                    name: "deadline"
                ))
                
                formData.append(MultipartFormData(
                    provider: .data("\(self.competitionTitle.value)dsadsaad".data(using: .utf8)!),
                    name: "title"
                ))
                
                formData.append(MultipartFormData(
                    provider: .data("\(competitionStartDateTitle.value)".data(using: .utf8)!),
                    name: "startDate"
                ))
                
                formData.append(MultipartFormData(
                    provider: .data("\(competitionEndDateTitle.value)".data(using: .utf8)!),
                    name: "endDate"
                ))
                
                formData.append(MultipartFormData(
                    provider: .data("\(self.competitionContent.value)".data(using: .utf8)!),
                    name: "content"
                ))
                
                for (index, tag) in self.tags.enumerated() {
                    formData.append(MultipartFormData(
                        provider: .data("\(tag)".data(using: .utf8)!),
                        name: "position"
                    ))
                }
                
                let imageData = self.competitionImage.value.pngData()!
                
                formData.append(MultipartFormData(
                    provider: .data(imageData),
                    name: "image"// ,
                    // fileName: "12321321.png",
                    // mimeType: "image/png"
                ))
                
                print(formData)
                return self.moaProvider.rx.request(.communityRegisterRecruit(formData: formData))
            }
            .map(MoaResponse.self)
            .subscribe(onNext: { response in
                guard response.isSuccess else { return }
                
            }, onError: { error in
                print(error)
            })
            .disposed(by: disposeBag)
        
        return Output(
            teambuildEndDateTitle: teambuildEndDateTitle.asDriver(),
            competitionStartDateTitle: competitionStartDateTitle.asDriver(),
            competitionEndDateTitle: competitionEndDateTitle.asDriver(),
            alertMessage: alertMessage.asSignal()
        )
    }
}
