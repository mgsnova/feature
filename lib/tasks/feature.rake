namespace :features do
  desc "list all feature toggles with their current state"
  task :all => :environment do
    puts Feature.all
  end

  desc "enable feature toggle"
  task :enable, [:name] => :environment do |t, args|
    if args[:name]
      Feature.set(args[:name].to_sym, true)
      puts "Set #{args[:name]} to active"
    else
      puts "Usage: rake features:enable[toggle_name]"
    end
  end

  desc "disable feature toggle"
  task :disable, [:name] => :environment do |t, args|
    if args[:name]
      Feature.set(args[:name].to_sym, false)
      puts "Set #{args[:name]} to inactive"
    else
      puts "Usage: rake features:disable[toggle_name]"
    end
  end

  desc "delete a feature toggle"
  task :remove, [:name] => :environment do |t, args|
    if args[:name]
      Feature.delete(args[:name].to_sym)
      puts "Removed #{args[:name]}"
    else
      puts "Usage: rake features:remove[toggle_name]"
    end
  end

  desc "create an active feature toggle"
  task :add_active, [:name] => :environment do |t, args|
    if args[:name]
      Feature.add(args[:name].to_sym, true)
      puts "Added #{args[:name]} with a value of true"
    else
      puts "Usage: rake features:add_active[toggle_name]"
    end
  end

  desc "create an inactive feature toggle"
  task :add_inactive, [:name] => :environment do |t, args|
    if args[:name]
      Feature.add(args[:name].to_sym, false)
      puts "Added #{args[:name]} with a value of false"
    else
      puts "Usage: rake features:add_inactive[toggle_name]"
    end
  end
end
