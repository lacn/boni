module UpdateOrCreate
    module Relation
      extend ActiveSupport::Concern

      module ClassMethods
        def update_or_create(attributes)
          obj = assign_or_new(attributes)
          obj.save
          obj
        end

        def update_or_create!(attributes)
          assign_or_new(attributes).save!
        end

        def assign_or_new(attributes)
          old, obj = first || new, first || new
          obj.assign_attributes(attributes)
          new_version unless old.attributes == obj.attributes && !old.new_record?
          obj
        end

        def new_version
          Version.first_or_create
          Version.first.update_attribute(:version, DateTime.now.to_i)
        end
      end
    end
end

ActiveRecord::Base.send :include, UpdateOrCreate::Relation
