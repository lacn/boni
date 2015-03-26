module UpdateOrCreate
    module Relation
      extend ActiveSupport::Concern

      module ClassMethods
        def update_or_create(attributes)
          obj = assign_or_new(attributes)
          puts obj.save
          obj
        end

        def update_or_create!(attributes)
          assign_or_new(attributes).save!
        end

        def assign_or_new(attributes)
          Version.first_or_create
          if obj = first
            old = first
          else
            obj = new
            Version.first.update_attribute(:version, DateTime.now.to_i)
          end
          obj.assign_attributes(attributes)
          Version.first.update_attribute(:version, DateTime.now.to_i) unless old.attributes == obj.attributes
          obj
        end
      end
    end
end

ActiveRecord::Base.send :include, UpdateOrCreate::Relation
