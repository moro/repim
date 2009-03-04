require 'active_support'

module Repim
  class AxAttributeAdapter
    attr_reader :rule, :necessity

    # TODO refactor
    def initialize(prefixes, propaties)
      @rule = {}
      @necessity = :optional
      propaties.each do |model_attr, property|
        @rule[model_attr] = prefixes.map{|px| px + property }
      end
    end

    def keys
      rule.values.flatten
    end

    def required!
      @necessity = :required
    end

    def adapt(fetched)
      returning({}) do |res|
        rule.each do |k, vs|
          fetched.each{|fk, (fv,_)| res[k] = fv if !fv.blank? && vs.include?(fk) }
        end
      end
    end
  end
end
