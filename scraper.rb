require 'nokogiri'
require 'open-uri'

def scrape_setlist_fm(artist)
  setlists = []
  pages = 5
  (1..pages).each do |page|
    url = "https://www.setlist.fm/search?query=#{URI.encode_www_form_component(artist)}&page=#{page}"
    doc = Nokogiri::HTML(URI.open(url))
    setlist_links = doc.css('.setlistPreview>div h2 a').map { |element| element.attributes['href'].value }

    setlist_links.each do |link|
      setlist_url = "https://www.setlist.fm/#{link}"
      setlist_doc = Nokogiri::HTML(URI.open(setlist_url))
      setlists << setlist_doc.search('.songLabel').map { |element| element.children.text }
    end
  end
  setlists
end

def create_average_setlist(setlists)
  average_setlist = Hash.new(0)

  setlists.each do |setlist|
    setlist.each_with_index do |song, index|
      average_setlist[song] += 1.0 / (index + 1)
    end
  end

  average_setlist = average_setlist.sort_by { |_, count| -count }
  average_setlist.map!(&:first)

  average_setlist
end

# Usage example
artist = "Springsteen & E Street Band 2023 Tour"
setlists = scrape_setlist_fm(artist)
# setlists = [["My Love Will Not Let You Down", "Death to My Hometown", "Ghosts", "Letter to You", "Prove It All Night", "The Promised Land", "Out in the Street", "Darlington County", "Working on the Highway", "Downbound Train", "I'm on Fire", "Kitty's Back", "Nightshift", "Mary's Place", "Last Man Standing", "Backstreets", "Because the Night", "She's the One", "Wrecking Ball", "The Rising", "Badlands", "Born in the U.S.A.", "Born to Run", "Bobby Jean", "Glory Days", "Dancing in the Dark", "Tenth Avenue Freeze-Out", "I'll See You in My Dreams"], ["No Surrender", "Ghosts", "Prove It All Night", "Darkness on the Edge of Town", "Letter to You", "The Promised Land", "Out in the Street", "Candy's Room", "Kitty's Back", "Nightshift", "Mary's Place", "The E Street Shuffle", "My Hometown", "The River", "Last Man Standing", "Backstreets", "Because the Night", "She's the One", "Wrecking Ball", "The Rising", "Badlands", "Thunder Road", "Born in the U.S.A.", "Born to Run", "Bobby Jean", "Glory Days", "Dancing in the Dark", "Tenth Avenue Freeze-Out", "I'll See You in My Dreams"], ["Night", "No Surrender", "Ghosts", "Prove It All Night", "Darkness on the Edge of Town", "The Promised Land", "Out in the Street", "Kitty's Back", "Nightshift", "Trapped", "Johnny 99", "The E Street Shuffle", "The River", "Last Man Standing", "Backstreets", "Because the Night", "She's the One", "Wrecking Ball", "The Rising", "Badlands", "Born in the U.S.A.", "Born to Run", "Bobby Jean", "Glory Days", "Dancing in the Dark", "Tenth Avenue Freeze-Out", "Twist and Shout", "I'll See You in My Dreams"], ["My Love Will Not Let You Down", "Death to My Hometown", "No Surrender", "Ghosts", "Prove It All Night", "Letter to You", "The Promised Land", "Out in the Street", "Kitty's Back", "Nightshift", "Mary's Place", "Racing in the Street", "The River", "Last Man Standing", "Backstreets", "Because the Night", "She's the One", "Wrecking Ball", "The Rising", "Badlands", "Born in the U.S.A.", "Born to Run", "Bobby Jean", "Glory Days", "Dancing in the Dark", "Tenth Avenue Freeze-Out", "I'll See You in My Dreams"], ["The Ties That Bind", "No Surrender", "Ghosts", "Prove It All Night", "Letter to You", "The Promised Land", "Out in the Street", "Lucky Town", "Kitty's Back", "Nightshift", "Mary's Place", "My Hometown", "The River", "Last Man Standing", "Backstreets", "Because the Night", "She's the One", "Wrecking Ball", "The Rising", "Badlands", "Land of Hope and Dreams", "Thunder Road", "Born in the U.S.A.", "Born to Run", "Bobby Jean", "Glory Days", "Dancing in the Dark", "Tenth Avenue Freeze-Out", "I'll See You in My Dreams"], ["The Ties That Bind", "No Surrender", "Ghosts", "Prove It All Night", "Letter to You", "The Promised Land", "Out in the Street", "Candy's Room", "Kitty's Back", "Nightshift", "Mary's Place", "My Hometown", "The River", "Last Man Standing", "Backstreets", "Because the Night", "She's the One", "Wrecking Ball", "The Rising", "Badlands", "Thunder Road", "Born in the U.S.A.", "Born to Run", "Bobby Jean", "Glory Days", "Dancing in the Dark", "Tenth Avenue Freeze-Out", "I'll See You in My Dreams"], ["No Surrender", "Ghosts", "Prove It All Night", "The Promised Land", "Out in the Street", "Candy's Room", "Kitty's Back", "Nightshift", "Mary's Place", "The E Street Shuffle", "My Hometown", "The River", "Last Man Standing", "Backstreets", "Because the Night", "She's the One", "Wrecking Ball", "The Rising", "Badlands", "Thunder Road", "Born in the U.S.A.", "Born to Run", "Bobby Jean", "Glory Days", "Dancing in the Dark", "Tenth Avenue Freeze-Out", "I'll See You in My Dreams"], ["No Surrender", "Ghosts", "Prove It All Night", "Letter to You", "The Promised Land", "Out in the Street", "Candy's Room", "Kitty's Back", "Nightshift", "Mary's Place", "The E Street Shuffle", "My Hometown", "The River", "Last Man Standing", "Backstreets", "Because the Night", "She's the One", "Wrecking Ball", "The Rising", "Badlands", "Thunder Road", "Born in the U.S.A.", "Born to Run", "Bobby Jean", "Glory Days", "Dancing in the Dark", "Tenth Avenue Freeze-Out", "I'll See You in My Dreams"], ["My Love Will Not Let You Down", "No Surrender", "Ghosts", "Prove It All Night", "Letter to You", "The Promised Land", "Out in the Street", "Working on the Highway", "Darlington County", "Kitty's Back", "Nightshift", "Mary's Place", "My Hometown", "Last Man Standing", "Backstreets", "Because the Night", "She's the One", "Wrecking Ball", "The Rising", "Badlands", "Thunder Road", "Born in the U.S.A.", "Born to Run", "Bobby Jean", "Glory Days", "Dancing in the Dark", "Tenth Avenue Freeze-Out", "I'll See You in My Dreams"], ["No Surrender", "Ghosts", "Prove It All Night", "Letter to You", "The Promised Land", "Out in the Street", "Candy's Room", "Kitty's Back", "Nightshift", "Mary's Place", "The E Street Shuffle", "Johnny 99", "Last Man Standing", "Backstreets", "Because the Night", "She's the One", "Wrecking Ball", "The Rising", "Badlands", "Thunder Road", "Born in the U.S.A.", "Born to Run", "Bobby Jean", "Glory Days", "Dancing in the Dark", "Tenth Avenue Freeze-Out", "I'll See You in My Dreams"]]
average_setlist = create_average_setlist(setlists)
puts "Average Setlist:"
average_setlist.each_with_index do |song, index|
  puts "#{index + 1}. #{song}"
end
