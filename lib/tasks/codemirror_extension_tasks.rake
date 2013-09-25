namespace :radiant do
  namespace :extensions do
    namespace :codemirror do
      
      desc "Runs the migration of the Codemirror extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          CodemirrorExtension.migrator.migrate(ENV["VERSION"].to_i)
          Rake::Task['db:schema:dump'].invoke
        else
          CodemirrorExtension.migrator.migrate
          Rake::Task['db:schema:dump'].invoke
        end
      end
      
      desc "Copies public assets of the Codemirror to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        puts "Copying assets from CodemirrorExtension"
        
        Dir[CodemirrorExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(CodemirrorExtension.root, '')
          directory = File.dirname(path)
          mkdir_p RAILS_ROOT + directory, :verbose => false
          
          if CodemirrorExtension.root.starts_with? RAILS_ROOT
            require 'pathname'
            src_path = file
            dest_path = RAILS_ROOT + path
            rel_path = Pathname.new(src_path).relative_path_from(Pathname.new(dest_path).dirname).to_s
            ln_sf rel_path, dest_path, :verbose => false
          else
            cp file, RAILS_ROOT + path, :verbose => false
          end
        end
      end  
      
      desc "Syncs all available translations for this ext to the English ext master"
      task :sync => :environment do
        # The main translation root, basically where English is kept
        language_root = CodemirrorExtension.root + "/config/locales"
        words = TranslationSupport.get_translation_keys(language_root)
        
        Dir["#{language_root}/*.yml"].each do |filename|
          next if filename.match('_available_tags')
          basename = File.basename(filename, '.yml')
          puts "Syncing #{basename}"
          (comments, other) = TranslationSupport.read_file(filename, basename)
          words.each { |k,v| other[k] ||= words[k] }  # Initializing hash variable as empty if it does not exist
          other.delete_if { |k,v| !words[k] }         # Remove if not defined in en.yml
          TranslationSupport.write_file(filename, basename, comments, other)
        end
      end
    end
  end
end
