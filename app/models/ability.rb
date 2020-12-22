# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user,controller_namespace)
    files = Dir[Rails.root + 'app/models/*.rb']
    models = files.map{ |m| File.basename(m, '.rb').camelize }
    return unless user.current_role
    user.current_role&.permissions&.bottom&.where(guard: controller_namespace).each do |permission|
       arr = []
       arr<< permission.code.to_sym if permission.code
       arr<< permission.map_code.to_sym if permission.map_code
       can arr, permission.group_code.split('/')[1].singularize.camelize.constantize if  models.include? permission.group_code.split('/')[1].singularize.camelize
    end
  end
end
