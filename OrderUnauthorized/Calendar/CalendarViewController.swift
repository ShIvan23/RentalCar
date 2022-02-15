//
//  CalendarViewController.swift
//  RentalCar
//
//  Created by Ivan on 13.02.2022.
//

import UIKit
import SnapKit
import FSCalendar

protocol CalendarViewControllerDelegate: AnyObject {
    func dateSelected(_ dateString: String)
}

final class CalendarViewController: UIViewController {
    
    private var firstDate: Date?
    private var lastDate: Date?
    private var datesRange = [Date]()
    
    weak var delegate: CalendarViewControllerDelegate?
    
    private lazy var calendar: FSCalendar = {
        let calendar = FSCalendar()
        calendar.allowsMultipleSelection = true
        calendar.firstWeekday = 2
        calendar.locale = Locale(identifier: "ru_RU")
        calendar.appearance.headerDateFormat = "LLLL yyyy"
//        calendar.dataSource = self
        calendar.appearance.selectionColor = UIColor(hexString: "#0c8269")
        calendar.delegate = self
        return calendar
    }()
    
    private lazy var selectButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let attributedText = NSAttributedString(string: "Выбрать", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18)])
        button.setAttributedTitle(attributedText, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(selectButtonAction), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        layout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        selectButton.setCustomGradient()
    }
    
    private func layout() {
        view.addSubview(calendar)
        view.addSubview(selectButton)
        
        calendar.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(300)
        }
        
        selectButton.snp.makeConstraints { make in
            make.top.equalTo(calendar.snp.bottom)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
    }
    
    @objc private func selectButtonAction() {
        defer {
            dismiss(animated: true, completion: nil)
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM"
        
        switch datesRange.count {
        case 0:
            return
        case 1:
            guard let firstDate = firstDate else { return }
            let firstDateString = dateFormatter.string(from: firstDate as Date)
            delegate?.dateSelected(firstDateString)
        default:
            guard let firstDate = firstDate,
                  let lastDate = lastDate else { return }
            let firstDateString = dateFormatter.string(from: firstDate as Date)
            let lastDateString = dateFormatter.string(from: lastDate as Date)
            delegate?.dateSelected("C " + firstDateString + " по " + lastDateString)
        }
    }
    
    private func datesRange(from: Date, to: Date) -> [Date] {
        // in case of the "from" date is more than "to" date,
        // it should returns an empty array:
        if from > to { return [Date]() }
        
        var tempDate = from
        var array = [tempDate]
        
        while tempDate < to {
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
            array.append(tempDate)
        }
        
        return array
    }
}

// MARK: - FSCalendarDelegate

extension CalendarViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if firstDate == nil {
            firstDate = date
            datesRange = [firstDate!]
            return
        }
        
        if firstDate != nil && lastDate == nil {
            if date <= firstDate! {
                calendar.deselect(firstDate!)
                firstDate = date
                datesRange = [firstDate!]
                return
            }
            let range = datesRange(from: firstDate!, to: date)
            lastDate = range.last
            
            for date in range {
                calendar.select(date)
            }
            datesRange = range
            return
        }
        
        if firstDate != nil && lastDate != nil {
            for date in calendar.selectedDates {
                calendar.deselect(date)
            }
            lastDate = nil
            firstDate = nil
            datesRange = []
        }
    }
}
