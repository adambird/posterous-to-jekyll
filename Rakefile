require 'rake'
require_relative './posterous_to_jeykll'

task :migrate_file, :source, :destination do |t, args|
  migrator = PosterousToJekyll.new
  source = File.read(args[:source])
  File.open(args[:destination], 'w') do |output_file|
    migrator.convert source, output_file
  end
end

