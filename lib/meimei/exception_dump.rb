module Meimei
  module ExceptionDumpMethods
    def dump(logger)
      logger.info "* #{self.class} error thrown"
      logger.info "* Message: #{self.message}"
      logger.info "* Backtrace:"
      self.backtrace.each do |line|
        logger.info "** #{line}"
      end
    end
  end
  
  Exception.__send__(:include, ExceptionDumpMethods)
end
