module WorseModel
  class WorseModelError < StandardError; end
  class UnknownRecord < WorseModelError; end
  class InvalidRecord < WorseModelError; end
  class UnknownAttribute < WorseModelError; end
end
