#!/usr/bin/env ruby -wKU

files = 0
nine_patch = []
skipped = []
RESOLUTIONS = {
  :hdpi => "75%",
  :mdpi => "50%",
  :ldpi => "37.5%"
}

puts "-- Resizing your assets, saving you time."

directory = ARGV[0]

RESOLUTIONS.each do |resolution, v|
  unless Dir.exists?("#{directory}/drawable-#{resolution}")
    puts = "Creating directory drawable-#{resolution}."
    Dir.mkdir("#{directory}/drawable-#{resolution}")
  end
end

Dir.foreach("#{directory}/drawable-xhdpi") do |filename|
  next unless /png/.match(filename)
  if /\.9\.png/.match(filename)
    puts "Skipping nine-patch #{filename}."
    nine_patch << filename
  else
    RESOLUTIONS.each do |resolution, ratio|
      if File.exists?("#{directory}/drawable-#{resolution}/#{filename}")
        puts "Skipping #{filename} (#{resolution}) because it already exists."
        skipped << "drawable-#{resolution}/#{filename}"
      else
        puts "Resizing #{filename} (#{resolution})."
        system "convert #{directory}/drawable-xhdpi/#{filename} -resize #{ratio}x#{ratio} #{directory}/drawable-#{resolution}/#{filename}"
        files += 1
      end
    end
  end
end

puts "-- Converted #{files} files. Make sure to check if they look right – there is work that can only be done by talented human hands."

if skipped.any?
  puts "-- Skipped #{skipped.size} existing files:"
  skipped.each do |filename|
    puts filename
  end
end

if nine_patch.any?
  puts "-- There are #{nine_patch.size} nine-patch files that you need to manually generate:"
  nine_patch.each do |filename|
    puts filename
  end
end



