def convert_to_weekly_report(str_weekly_report)
	# マークアップ（インラインボックス）用
	str_weekly_report = "```\r\n" + str_weekly_report

	include_years_cnt = 0
	cnt = 0

	str_weekly_report.gsub!(/(\d+)年(\d+)月(\d+)日/) do |a|
		d = Date.strptime(a,'%Y年%m月%d日') + 7
		include_years_cnt += 1
		a = d.year.to_s + "年" + d.month.to_s.rjust(2, '0') + "月" + d.day.to_s.rjust(2, '0') + "日"
	end

	str_weekly_report.gsub!(/(\d+)月(\d+)日/) do |a|
		cnt += 1
		d = Date.strptime(a,'%m月%d日')
		unless include_years_cnt >= cnt
			d = d + 7
		end
		a = d.month.to_s.rjust(2, '0') + "月" + d.day.to_s.rjust(2, '0') + "日"
	end

	# マークアップ（インラインボックス）用
	str_weekly_report = str_weekly_report + "\r\n```"
end