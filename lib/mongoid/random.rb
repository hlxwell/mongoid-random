module Mongoid
  module Random

    extend ActiveSupport::Concern

    included do
      field :_randomization_key, type: Float
      before_create :generate_mongoid_random_key
    end


    module ClassMethods

      def random(count=1, random_key=rand)
        if where(:_randomization_key.gte => random_key).count >= count
          where(:_randomization_key.gte => random_key)
        elsif where(:_randomization_key.lte => random_key).count >= count
          where(:_randomization_key.lte => random_key)
        else
          where(:_randomization_key.ne => nil)
        end.order_by([ [:_randomization_key, [:asc, :desc].sample] ]).limit(count)
      end

    end

    module InstanceMethods

      def generate_random_key!
        self.generate_mongoid_random_key
        self.save
      end

      protected

      def generate_mongoid_random_key
        self._randomization_key = rand
      end
    end

  end
end
