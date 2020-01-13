# frozen_string_literal: true

module BreezyPDFLite
  # Utility methods
  module Util
    def mattr_reader(*syms)
      syms.each do |sym|
        raise NameError, "invalid attribute name: #{sym}" unless /\A[_A-Za-z]\w*\z/.match?(sym)

        class_eval(<<-EOS, __FILE__, __LINE__ + 1)
          @@#{sym} = nil unless defined? @@#{sym}
          def self.#{sym}
            @@#{sym}
          end
        EOS

        class_eval(<<-EOS, __FILE__, __LINE__ + 1)
          def #{sym}
            @@#{sym}
          end
        EOS
        class_variable_set("@@#{sym}", yield) if block_given?
      end
    end

    def mattr_writer(*syms)
      syms.each do |sym|
        raise NameError, "invalid attribute name: #{sym}" unless /\A[_A-Za-z]\w*\z/.match?(sym)

        class_eval(<<-EOS, __FILE__, __LINE__ + 1)
          @@#{sym} = nil unless defined? @@#{sym}
          def self.#{sym}=(obj)
            @@#{sym} = obj
          end
        EOS

        class_eval(<<-EOS, __FILE__, __LINE__ + 1)
          def #{sym}=(obj)
            @@#{sym} = obj
          end
        EOS
        send("#{sym}=", yield) if block_given?
      end
    end

    def mattr_accessor(*syms, &blk)
      mattr_reader(*syms, &blk)
      mattr_writer(*syms)
    end
  end
end
