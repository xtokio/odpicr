require "./spec_helper"
require "./../src/odpi/*"

# TODO: Write tests
describe "Connects to Oracle" do
  it "Connects" do
    DB.open "odpi://#{ENV["BANNER_DB_USER"]}:#{ENV["BANNER_DB_PASS"]}@#{ENV["BANNER_DB_DEV"]}" do |db|
      puts "Connection successful!"
    end
  end

  it "Queries" do
    DB.open "odpi://#{ENV["BANNER_DB_USER"]}:#{ENV["BANNER_DB_PASS"]}@#{ENV["BANNER_DB_DEV"]}" do |db|
      db.query "select spriden_id, spriden_first_name, spriden_last_name from spriden where spriden_id = 'LGOMEZRE'" do |res|
        res.each do
          puts "#{res.column_name(0)} => #{res.read} | #{res.column_name(1)} => #{res.read} | #{res.column_name(2)} => #{res.read}"
        end
      end
    end
  end
end