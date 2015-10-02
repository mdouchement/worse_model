module WorseModel
  module Base
    def self.included(base)
      base.class_eval do
        extend ActiveModel::Naming
        include ActiveModel::Conversion
        include ActiveModel::Serializers::JSON
        include ActiveModel::Serializers::Xml
        # include Dirty, Observing, Callbacks, Validations
        # include Association::Model

        class_attribute :known_attributes
        self.known_attributes = []
      end

      base.extend(ClassMethods)
    end

    attr_accessor :attributes
    attr_writer   :new_record

    def known_attributes
      self.class.known_attributes | self.attributes.keys.map(&:to_s)
    end

    def initialize(params = {})
      @new_record = true
      @attributes = {}.with_indifferent_access
      known_attributes.each { |attribut| __generate_attribute_accessor__(attribut) }
      @attributes.merge!(known_attributes.inject({}) { |h, n| h[n] = nil; h })
      @changed_attributes = {}
      load(params)
    end

    def clone
      fail 'Not implemented yet'
    end

    def new?
      @new_record || false
    end
    alias_method :new_record?, :new?

    def id
      attributes[self.class.primary_key]
    end

    def id=(id)
      attributes[self.class.primary_key] = id
    end

    def ==(other)
      other.equal?(self) || (other.instance_of?(self.class) && other.id == id)
    end

    # Tests for equality (delegates to == operator).
    def eql?(other)
      self == other
    end

    def hash
      id.hash
    end

    def dup
      self.class.new.tap do |base|
        base.load(attributes)
        base.new_record = new_record?
      end
    end

    def save
      new? ? create : update
    end

    def save!
      save || raise(InvalidRecord)
    end

    def exists?
      !new?
    end
    alias_method :persisted?, :exists?

    def load(params) #:nodoc:
      return unless params
      params.each do |name, value|
        name = name.to_sym
        fail(UnknownAttribute,
          "Attempted to set a value for '#{name}' which is not allowed on the model #{self.class.name}") unless known_attributes.include?(name)
        attributes[name] = value
      end
    end

    def reload
      return self if new?
      item = self.class.find(id)
      load(item.attributes)
      return self
    end

    def update_attribute(name, value)
      load(name => value) && save
    end

    def update_attributes(params)
      load(params) && save
    end

    def update_attributes!(params)
      update_attributes(params) || fail(InvalidRecord)
    end

    def has_attribute?(name)
      attributes.has_key?(name)
    end

    alias_method :respond_to_without_attributes?, :respond_to?
    def respond_to?(method, include_priv = false)
      method_name = method.to_s
      if attributes.nil?
        super
      elsif known_attributes.include?(method_name)
        true
      else
        super
      end
    end

    def destroy
      raw_destroy || false
    end

    protected

    def generate_id
      object_id
    end

    def raw_destroy
      self.class.records.delete(id).present?
    end

    def raw_create
      self.class.records[id] = dup
    end

    def create
      id ||= generate_id
      @new_record = false
      raw_create
      id
    end

    def raw_update
      item = self.class.raw_find(id)
      item.load(attributes)
    end

    def update
      raw_update
      true
    end

    def __generate_attribute_accessor__(attribute)
      self.class.send(:define_method, attribute) do
        @attributes[attribute]
      end

      self.class.send(:define_method, "#{attribute}=") do |value|
        @attributes[attribute] = value
      end
    end

    module ClassMethods
      attr_accessor(:primary_key) #:nodoc:

      def primary_key
        @primary_key ||= 'id'
      end

      def collection(&block)
        @collection ||= Class.new(Array)
        @collection.class_eval(&block) if block_given?
        @collection
      end

      def fields(*fields)
        known_attributes.concat(fields.map(&:to_sym)).uniq!
      end
      alias_method :field, :fields

      def records
        @records ||= {}
      end

      def find_by(params)
        # keys = params.keys
        # records.select { |r| *(r[key] == params[key]) }
        fail 'Not implemented yet'
      end

      def raw_find(id) #:nodoc:
        records[id] || fail(UnknownRecord, "Couldn't find #{self.name} with ID=#{id}")
      end

      # Find record by ID, or raise.
      def find(id)
        item = raw_find(id)
        item && item.dup
      end
      alias_method :[], :find

      def first
        item = records.values.first
        item && item.dup
      end

      def last
        item = records.values.last
        item && item.dup
      end

      def where(params)
        fail 'Not implemented yet'
      end

      def exists?(id)
        records.has_key?(id)
      end

      def count
        records.length
      end

      def all
        collection.new(records.values.deep_dup)
      end

      def select(&block)
        collection.new(records.values.select(&block).deep_dup)
      end

      def destroy(id)
        find(id).destroy
      end

      # Removes all records and executes
      # destroy callbacks.
      def destroy_all
        all.each { |r| r.destroy }
      end

      # Removes all records without executing
      # destroy callbacks.
      def delete_all
        records.clear
      end

      # Create a new record.
      # Example:
      #   create(id: 1, name: 'foo')
      def create(params = {})
        record = new(params)
        record.save && record
      end

      def create!(params)
        create(params) || raise(InvalidRecord)
      end
    end
  end
end
