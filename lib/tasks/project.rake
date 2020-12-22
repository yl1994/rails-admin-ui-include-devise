namespace :project do

  desc "设置需要预警的项目"
  task :set_waring_projects => :environment do
    ActiveRecord::Base.connection_pool.with_connection do
      Project.set_waring_projects
    end
  end
end