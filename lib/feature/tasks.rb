if defined?(Rails::Railtie)
  module Feature
    class AddTasks < Rails::Railtie
      rake_tasks do
        paths = Dir[File.join(File.dirname(File.dirname(__FILE__)),'tasks/*.rake')]
        paths.each { |f| load f }
      end
    end
  end
end
