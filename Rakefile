require 'rake'
require_relative './posterous_to_jeykll'

task :migrate_file, :source, :destination do |t, args|
  migrator = PosterousToJekyll.new
  source_file = File.open(args[:source])
  File.open(args[:destination], 'w') do |output_file|
    migrator.convert source_file, output_file
  end
  source_file.close
end

