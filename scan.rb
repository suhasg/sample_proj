require 'spreadsheet'
require 'creek'
require 'net/http'
require 'nokogiri'
require 'open-uri'
require 'addressable/uri'

def get_owner(page)
  owner = page.at("meta[@name='Owner']") || page.at("meta[@name='owner']")
  owner[:content] || "Owner not defined"
end

start = Time.now

puts "Starting scanning links.. #{start}"

if (dest_book = Spreadsheet.open("/Users/sgiriraj/Downloads/out-file.xls"))
  sheet1 = dest_book.worksheet 0
else
  dest_book = Spreadsheet::Workbook.new
  sheet1 = dest_book.create_worksheet
  sheet1.row(0).concat %w{URL Owner Chat}
end

src_book = Creek::Book.new("/Users/sgiriraj/Downloads/AP_Top Pages_Mani.xlsx")
sheet = src_book.sheets[0]

chat_url = "//www.ibm.com/software/common-content/ssi/lp/lpdyn-common.js"

sheet.rows.each_with_index do |row, index|
  if index > 0
    url = row.values.compact[0]

    if sheet1.row(index)[0] != url
      puts "#{index}) #{url}   #{(index*100)/750}%"
      begin
        url_path = Addressable::URI.parse(url)
        content = Nokogiri::HTML(open(url_path.normalize))
        owner = get_owner(content)

        if content.at("script[@src='#{chat_url}']")
          sheet1.update_row index, "#{url}", "#{owner}", "Yes"
        else
          sheet1.update_row index, "#{url}", "#{owner}", "No"
        end
      rescue => e
        if e.message == '404 Not Found'
          sheet1.update_row index, "#{url}", "404 Not Found", "404 Not Found"
        elsif e.message == 'getaddrinfo: nodename nor servname provided, or not known'
          sheet1.update_row index, "#{url}", "Server not found", "Server not found"
        else
          sheet1.update_row index, "#{url}", "Error to open page", "Error to open page"
        end
      end
    end
  end
  dest_book.write "/Users/sgiriraj/Downloads/out-file-(#{start}).xls"
end

puts "Finished scanning links.. #{Time.now - start}"



