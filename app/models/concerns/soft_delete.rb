
module SoftDelete
  extend ActiveSupport::Concern
 
  included do
      acts_as_paranoid column: :is_deleted, sentinel_value: false
      scope :is_deleted, -> {unscope(where: :is_deleted).where(is_deleted: true)}  # 只查询删除的

      def paranoia_restore_attributes
       {
         deleted_at: nil,
         is_deleted: false
       }
      end

      def paranoia_destroy_attributes
       {
         deleted_at: current_time_from_proper_timezone,
         is_deleted: true
       }
      end
  end
end