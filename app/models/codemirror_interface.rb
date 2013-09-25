module CodemirrorInterface
  def self.included(base)
    base.class_eval do
      before_filter :add_codemirror, :only => [:edit, :new]
      include InstanceMethods
    end
  end

  module InstanceMethods
    def add_codemirror
      add_codemirror_styles
      add_codemirror_scripts
    end
    
    def add_codemirror_styles
      include_stylesheet 'admin/codemirror/base.css'
      
      root = "#{CodemirrorExtension.root}/public/stylesheets/admin/codemirror/themes"
      Dir["#{root}/*.css"].map do |file|
        file.sub root, ''
      end.each do |file|
        include_stylesheet "admin/codemirror/themes#{file}"
      end
    end
    
    def add_codemirror_scripts
      include_javascript 'admin/codemirror/index.js'
      include_javascript 'admin/codemirror/formatting.js'

      root = "#{CodemirrorExtension.root}/public/javascripts/admin/codemirror/modes"
      
      Dir["#{root}/**/*.js"].reject do |file|
        file.include?("test")
      end.map do |file|
        file.sub root, ''
      end.each do |file|
        include_javascript "admin/codemirror/modes#{file}"
      end

      include_javascript 'admin/codemirror.js'
    end
  end
end