//
//  SearchEventListViewModel.swift
//  ColorgyCourse
//
//  Created by David on 2016/5/13.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

public protocol SearchEventListViewModelDelegate: class {
	func searchEventListViewModelUpdateFilteredEvents(events: [String])
}

final public class SearchEventListViewModel {
	
	public weak var delegate: SearchEventListViewModelDelegate?
	
	public private(set) var events: [String]
	public private(set) var filteredEvents: [String]
	
	private var searchId: String = ""
	
	init(delegate: SearchEventListViewModelDelegate?) {
		self.delegate = delegate
		let _events = ["「前面沒有人，後面也沒人，這世界好大呀，於是我就哭了。」─【登幽州台歌】前不見古人，後不見來者。 念天地之悠悠，獨愴然而涕下。",
		               "「太陽下山了，河流到海裡去了，你想看的遠一點，就給我爬高啊！」─【登鸛雀樓】白日依山盡，黃河入海流。欲窮千里目，更上一層樓。",
		               "還能做成長輩最喜歡的LINE圖分享。",
		               "網友們也補充了不少「翻譯後發現是廢文」的例子：",
		               "原文：【尋隱者不遇】松下問童子，言師采藥去。 只在此山中，雲深不知處。",
		               "廢文翻譯",
		               "松樹下問學生，老師蹺課去抓藥，就在山裏頭，鬼混到哪就不知道了。",
		               "原文：【題西林壁】橫看成嶺側成峰， 遠近高低各不同。 不識廬山真面目， 只緣身在此山中。",
		               "廢文翻譯",
		               "正看側看是不同的山，遠看近看往下看往上看也是不同的山：不知道山長什麼樣子，我還是繼續爬山。",
		               "原文：【無題】春蠶到死絲方盡，蠟炬成灰淚始乾。",
		               "廢文翻譯",
		               "我養的蠶吐絲吐到死掉，我從早哭到晚，還點蠟燭。",
		               "原文：【相思】紅豆生南國，春來發幾枝。 願君多采撷，此物最相思。",
		               "廢文翻譯",
		               "南方產紅豆，春天長得好，多採一點，把妹超好用。",
		               "原文：【關雎】關關雎鳩，在河之洲。窈窕淑女，君子好逑。",
		               "廢文翻譯",
		               "水鳥在沙洲上叫，害我好想把個正妹",
		               "「前面沒有人，後面也沒人，這世界好大呀，於是我就哭了。」─【登幽州台歌】前不見古人，後不見來者。 念天地之悠悠，獨愴然而涕下。",
		               "「太陽下山了，河流到海裡去了，你想看的遠一點，就給我爬高啊！」─【登鸛雀樓】白日依山盡，黃河入海流。欲窮千里目，更上一層樓。",
		               "還能做成長輩最喜歡的LINE圖分享。",
		               "網友們也補充了不少「翻譯後發現是廢文」的例子：",
		               "原文：【尋隱者不遇】松下問童子，言師采藥去。 只在此山中，雲深不知處。",
		               "廢文翻譯",
		               "松樹下問學生，老師蹺課去抓藥，就在山裏頭，鬼混到哪就不知道了。",
		               "原文：【題西林壁】橫看成嶺側成峰， 遠近高低各不同。 不識廬山真面目， 只緣身在此山中。",
		               "廢文翻譯",
		               "正看側看是不同的山，遠看近看往下看往上看也是不同的山：不知道山長什麼樣子，我還是繼續爬山。",
		               "原文：【無題】春蠶到死絲方盡，蠟炬成灰淚始乾。",
		               "廢文翻譯",
		               "我養的蠶吐絲吐到死掉，我從早哭到晚，還點蠟燭。",
		               "原文：【相思】紅豆生南國，春來發幾枝。 願君多采撷，此物最相思。",
		               "廢文翻譯",
		               "南方產紅豆，春天長得好，多採一點，把妹超好用。",
		               "原文：【關雎】關關雎鳩，在河之洲。窈窕淑女，君子好逑。",
		               "廢文翻譯",
		               "水鳥在沙洲上叫，害我好想把個正妹",
		               "「前面沒有人，後面也沒人，這世界好大呀，於是我就哭了。」─【登幽州台歌】前不見古人，後不見來者。 念天地之悠悠，獨愴然而涕下。",
		               "「太陽下山了，河流到海裡去了，你想看的遠一點，就給我爬高啊！」─【登鸛雀樓】白日依山盡，黃河入海流。欲窮千里目，更上一層樓。",
		               "還能做成長輩最喜歡的LINE圖分享。",
		               "網友們也補充了不少「翻譯後發現是廢文」的例子：",
		               "原文：【尋隱者不遇】松下問童子，言師采藥去。 只在此山中，雲深不知處。",
		               "廢文翻譯",
		               "松樹下問學生，老師蹺課去抓藥，就在山裏頭，鬼混到哪就不知道了。",
		               "原文：【題西林壁】橫看成嶺側成峰， 遠近高低各不同。 不識廬山真面目， 只緣身在此山中。",
		               "廢文翻譯",
		               "正看側看是不同的山，遠看近看往下看往上看也是不同的山：不知道山長什麼樣子，我還是繼續爬山。",
		               "原文：【無題】春蠶到死絲方盡，蠟炬成灰淚始乾。",
		               "廢文翻譯",
		               "我養的蠶吐絲吐到死掉，我從早哭到晚，還點蠟燭。",
		               "原文：【相思】紅豆生南國，春來發幾枝。 願君多采撷，此物最相思。",
		               "廢文翻譯",
		               "南方產紅豆，春天長得好，多採一點，把妹超好用。",
		               "原文：【關雎】關關雎鳩，在河之洲。窈窕淑女，君子好逑。",
		               "廢文翻譯",
		               "水鳥在沙洲上叫，害我好想把個正妹"]
		self.events = []
		for _ in 1...100000 {
			for e in _events {
				self.events.append(e)
			}
		}
		print(self.events.count)
		self.filteredEvents = []
	}
	
	public func searchEventWithText(text: String?) {
		dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INTERACTIVE.rawValue), 0)) {
			self.searchId = NSUUID().UUIDString
			let thisSearchId = self.searchId
			self.filteredEvents = []
			guard let text = text else { return }
			let before = NSDate()
			for event in self.events {
				if thisSearchId != self.searchId {
					break
				}
				if event.rangeOfString(text, options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil, locale: nil) != nil {
					self.filteredEvents.append(event)
				}
			}
			dispatch_async(dispatch_get_main_queue(), {
				if thisSearchId == self.searchId {
					print(NSDate().timeIntervalSinceDate(before), "seconds for searching \(self.events.count) events")
					self.delegate?.searchEventListViewModelUpdateFilteredEvents(self.filteredEvents)
				}
			})
		}
	}
}