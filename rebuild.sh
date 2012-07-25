rm rails.db
sqlite3 rails.db < schema.sql
find ./classes | grep html | ruby parse1.rb
