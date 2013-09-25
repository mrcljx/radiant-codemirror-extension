# Uncomment this if you reference any of your controllers in activate
# require_dependency "application_controller"
require "radiant-codemirror-extension"

class CodemirrorExtension < Radiant::Extension
  version     RadiantCodemirrorExtension::VERSION
  description RadiantCodemirrorExtension::DESCRIPTION
  url         RadiantCodemirrorExtension::URL

  # See your config/routes.rb file in this extension to define custom routes

  extension_config do |config|
    # config is the Radiant.configuration object
  end

  def activate
    Admin::ResourceController.send :include, CodemirrorInterface
    Admin::PagesController.send :include, CodemirrorInterface
  end
end
