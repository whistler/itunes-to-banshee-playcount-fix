#!/usr/bin/env ruby
require 'rubygems'
require 'xmlsimple'
tracks4 = XmlSimple.xml_in('Library.xml', { 'ForceArray' => [ 'dict' ], 'KeyAttr' => ['Play Count','Name','dict','key'] })

count =0
tracks4['dict'][0]['dict'][0]['dict'].each do |track|
    keys=track['key']
    vals=track['string']
    h = Hash[*keys.zip(vals).flatten]
    puts h['Name'] + "----" + h['Play Count'].to_s
    count=count+1
end


#tracks.each do |track|
#    puts track
#end

