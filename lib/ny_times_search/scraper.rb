require "open-uri"

class NyTimesSearch::Scraper
	def self.scrape_menu
		html = open("https://www.nytimes.com/")
		doc = Nokogiri::HTML(html)

		doc.css(".css-1vxc2sl li").each do |li|
			if li.css("a").attribute("href") && li.css("a").attribute("href").value != "/" && !(["Real Estate", "Video"].include?(li.css("a").text))
				section_name = li.css("a").text
				section_url = li.css("a").attribute("href").value
				NyTimesSearch::Search.add_section(section_name.upcase, section_url)
			end
		end
	end

	def self.scrape_section(section_name, section_url)
    search = NyTimesSearch::Search.searches.last
		html = open(section_url)
		section_doc = Nokogiri::HTML(html)
    

    section_doc.css("#site-content a").each do |a|
      if a.attribute("href") != nil && !a.attribute("href").value.scan(/\d{4}\/\d{2}\/\d{2}/).empty?
        article_date = Date.strptime(a.attribute("href").value.scan(/\d{4}\/\d{2}\/\d{2}/).join, "%Y/%m/%d")
      else
        article_date = Date.today
      end
      if  a.attribute("href") != nil &&
          a.attribute("href").value.include?("html") &&
          article_date > article_date - search.recency_in_days &&
          !a.attribute("href").value.include?("/membercenter") &&
          !a.attribute("href").value.include?("/content") &&
          !a.attribute("href").value.include?("/interactive") &&
          !NyTimesSearch::Search.searches.any? { |search| search.article_sub_urls.detect {|url| url == a.attribute("href").value}} &&
          !a.attribute("href").value.include?("http")

          if !search.article_sub_urls.include?(a.attribute("href").value)
          	search.article_sub_urls << a.attribute("href").value
        	end
      end
    end


    search.article_sub_urls.each do |link|
    if !link.include?("https")
      link = "https://www.nytimes.com/#{link}"
    end

    html = open(link)
    article_doc = Nokogiri::HTML(html)
  
    case_variants =[" #{search.search_term.downcase} ", " #{search.search_term.capitalize}", "#{search.search_term.upcase} "]
    article_doc.css(".css-exrw3m.evys1bk0").collect do |par|
        case_match = case_variants.detect { |word_case| word_case if par.text.include?(word_case)}
        if case_match

            new_par = par.text.gsub(case_match,case_match.green)
            new_par = new_par.gsub("â\u0080\u009C", "\"").gsub("â\u0080\u009D", "\"").gsub("â\u0080\u0099", "'").gsub("â\u0080\u0094", "—")

            title = article_doc.css("title").text.gsub("â\u0080\u009C", "\"").gsub("â\u0080\u009D", "\"").gsub("â\u0080\u0099", "'").gsub("â\u0080\u0094", "—")
            author = article_doc.css(".css-1fv7b6t.e1jsehar1 span").collect { |span| span.text}
            date = article_doc.css(".css-1xtbm1r.epjyd6m3").css("time @datetime").to_s#(".css-ld3wwf.e16638kd1").css(".css-1sbuyqj.e16638kd4").text

            NyTimesSearch::SearchMatch.new(new_par, title, link, author, date)
        end
    end
end 
	end
end