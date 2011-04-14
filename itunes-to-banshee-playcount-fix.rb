#!/usr/bin/env ruby
require 'rubygems'
require 'xmlsimple'
require 'sqlite3'

  Artists = Hash.new

  db = SQLite3::Database.new( "banshee.db" )
  rows = db.execute( "SELECT * FROM CoreArtists" )
  rows.each do |row|
    Artists[row[3]]=row[0]
  end
  puts Artists.inspect



begin
file = File.read("Library.xml")
dicts = file.split('<dict>')

count =0;

dicts.each do |dict|
    artist=""
    name=""
    playcount=""
    dict.each_line do |line|
        if line.index('<key>Artist</key>')!=nil then
            chunks = line.split('</key><string>')
            chunks = chunks[1].split('</string>')
            artist = chunks[0]
            #puts artist
        end
        if line.index('<key>Name</key>')!=nil then
            chunks = line.split('</key><string>')
            chunks = chunks[1].split('</string>')
            name = chunks[0]
        end
        if line.index('<key>Play Count</key>')!=nil then
            chunks = line.split('</key><string>')
            chunks = chunks[1].split('</string>')
            playcount = chunks[0]
            #puts playcount
        end
    end
    if name!="" && playcount !="" then
        #puts artist + ' - ' + name + ' - ' + playcount
        artist_id = Artists[artist]
        music = db.execute( "SELECT * FROM CoreTracks WHERE Title = ? AND ArtistID = ?", name, artist_id)
        if music.count==0 then
        music = db.execute( "SELECT * FROM CoreTracks WHERE Title = ?", name)
        end
        if music.count==0 then
        puts "ERROR: " + artist + ' - ' + name + 'Not Found'
        end
        #puts music.count
        music.each do |song|
            update = db.execute( "UPDATE CoreTracks SET PlayCount = ? WHERE TrackID = ?", playcount, song[1])
            puts update
        end
        count=count + 1
    end
end
    puts count
end

