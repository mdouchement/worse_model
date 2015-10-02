require 'active_support/core_ext/class/attribute_accessors'
require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/core_ext/kernel/reporting'
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/module/aliasing'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/object/try'
require 'active_support/core_ext/object/to_query'
require 'active_support/core_ext/class/attribute'
require 'active_support/json'
require 'active_model'
require 'rails/observers/active_model/active_model'
require 'worse_model/version'
require 'worse_model/errors'

module WorseModel
  autoload :Base, 'worse_model/base'
end
