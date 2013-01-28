require 'rake'
require_relative './posterous_to_jeykll'

task :migrate_file, :source, :destination do |t, args|
  migrator = PosterousToJekyll.new
  source = File.read(args[:source])
  migrator.convert source, args[:destination]
end

