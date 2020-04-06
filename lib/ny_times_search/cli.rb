class NyTimesSearch::CLI
	@@instances = []
	
	def initialize
		@@instances << self
	end

	def self.instances
		@@instances
	end

	def greeting
		puts "Welcome to the New York Times Searcher!".yellow
		puts "Search any New York Times section for any search term"
		NyTimesSearch::Search.get_sections
		display_sections
	end

	def display_sections
		puts "\n Please choose from one of these sections. To search all sections, type 'all'"

		NyTimesSearch::Search.section_names.each do |name|
			print "   #{name}   "
		end
		puts puts

		section_selection
	end

	def section_selection
		section_input = nil
		while section_input == nil 
			puts "What section would you like to search?"
			section_input = gets.strip.upcase
			puts
		end

		while !NyTimesSearch::Search.sections.include?(section_input) && section_input != "ALL"#one of the sections in the NyTimes, so in the Search.sections
			puts "Please enter a valid section name"
			section_input = gets.strip.upcase
			puts
		end

		puts "Please enter a search term (case insensitive)"
		search_input = gets.strip
		puts
		
		puts "How far back do you want to look? Enter number of days (from 1 - 7)"
		recency_input = gets.strip.to_i
		while recency_input < 1 || recency_input > 7
			puts "Please enter a number from 1 - 7"
			recency_input = gets.strip.to_i
			puts
		end
		
		if section_input == "ALL"
			NyTimesSearch::Search.sections.each do |section_name, section_url|
				puts "searching the #{section_name} section..."
				search = NyTimesSearch::Search.new(section_name, search_input, recency_input)
				search.section_url = NyTimesSearch::Search.sections[section_name]
				search.search_section
				show_search_summary(search)
			end
			total_articles = 0
			NyTimesSearch::Search.searches.each { |search| total_articles += search.article_sub_urls.count }
			puts "Total articles searched: #{total_articles}"

		else
			search = NyTimesSearch::Search.new(section_input, search_input, recency_input)
			search.section_url = NyTimesSearch::Search.sections[section_input]
			search.search_section
			show_search_summary(search)
		end

		puts "Would you like to do another search? (y/n)"
		input = gets.strip
		puts

		while input != "y" && input != "n"
			puts "Please enter y or n"
			input = gets.strip
			puts
		end

		if input == "y"
			display_sections
		end
	end

	def show_search_match(search_match)
		puts " \n#{search_match.search_match_id}: #{search_match.context}"
		puts "#{"ARTICLE TITLE:".red} #{search_match.article_title.gsub(" - The New York Times", "")}"
		puts "#{"ARTICLE AUTHOR(S):".red} #{search_match.article_author.join(", ").empty? ? "Unavailable" : search_match.article_author.join(", ")}"
		puts "#{"ARTICLE DATE:".red} #{search_match.article_date.empty? ? "Unavailable" : search_match.article_date.split("T").first}"
		puts "#{"ARTICLE LINK:".red} #{search_match.article_url} \n"
	end

	def show_search_summary(search)
		puts "#{search.section_name} section search overview:"
		puts "Total Articles scanned: #{search.article_sub_urls.count}"
		puts "Total Hits: #{search.search_matches.count}"
		puts "Total matching articles: #{search.search_matches.collect {|match| match.article_title}.uniq.count} \n \n"
	end
end