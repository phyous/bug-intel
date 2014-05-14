require 'nokogiri'
require 'open-uri'
require 'bug_info'

class Analysis
  def initialize(file_name)
    @bugs = process_file(file_name)
  end

  def process_file(file_name)
    page = Nokogiri::HTML(open(file_name))
    rows = page.xpath('//tr')
    details = rows.collect do |row|
      detail = {}
      [
          [:key, 'td[2]/a/text()'],
          [:summary, 'td[3]/text()'],
          [:priority, 'td[6]/text()'],
          [:assignee, 'td[8]/text()'],
          [:reporter, 'td[9]/text()'],
          [:description, 'td[28]'],
          [:created, 'td[10]/text()'],
          [:resolved, 'td[13]/text()'],
          [:components, 'td[16]/text()'],
      ].each do |name, xpath|
        tmp = row.at_xpath(xpath).to_s.strip.gsub("\n", "").gsub("<br>", "")
        if name == :description
          remove_xml = tmp.match(/<td.+>(.+)<\/td>/)
          detail[name] = remove_xml.nil? ? tmp : remove_xml[1]
        else
          detail[name] = tmp
        end
      end
      BugInfo.new(detail)
    end
    details
  end

  # P1 - Keyword occurences in description & summary
  def analyze_keyword_occurences(keywords)
    full_word_occurences = {}
    @bugs.each do |bug|
      all_text = "#{bug.description.downcase} #{bug.summary.downcase}"

      all_text.gsub(/[^a-z]/i,' ').split.each do |word|
        word = word.strip
        if full_word_occurences.has_key? word
          full_word_occurences[word] = full_word_occurences[word] + 1
        else
          full_word_occurences[word] = 1
        end
      end
    end

    computed_occurences = {}
    keywords.each do |keyword|
      if !full_word_occurences[keyword].nil?
        computed_occurences[keyword] = full_word_occurences[keyword]
      end
    end
    puts computed_occurences
  end

  # P1 - Breakdown by component (%)
  def analyze_component_breakdown

  end

  # P2 - Issues by priority

  # P2 - Amount of time spent fixing bugs
end