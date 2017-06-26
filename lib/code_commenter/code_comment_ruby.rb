require_relative 'code_comment'
#
module CodeCommenter
  class << self
    # Create a ruby code commenter for testing
    # @return [CodeCommenter::Ruby] A Ruby code commenter for testing
    def ruby
      Ruby.new test: true
    end
  end
  # Class responsible to comment ruby code
  class Ruby < CodeCommenter::CodeComment
    # Ruby file extensions
    #
    # @return [[String]] The list of strings that represent ruby's file extension
    def extensions
      ['rb']
    end

    # Is this a function line that should be commented?
    #
    # @param line [String] The current line
    # @return
    def function_line?(line)
      line.match(/def\s+\w+\??\s*(\((\w+|,)+\))?/)
    end

    # Is this a class line that should be commented?
    #
    # @param line [String] The current line
    # @return
    def class_line?(line)
      line.match(/^\s*(class|module)\s+\w+\s*(<<|<)?\s*\w*/)
    end

    # Is this an internal line that should be commented?
    #
    # @param line [String] The current line
    # @return [false]
    def internal_line?(line)
      false
    end

    # Is this line one that should not be commented? Either a comment or a line that follows a comment. This avoids
    # putting comments on other comments
    #
    # @param line [String] The current line
    # @param prev_line [String] The previous line
    # @return [false]
    def dont_comment_line?(line = '', prev_line = '')
      line.include?('#') || prev_line.include?('#')
    end

    # Document a ruby function
    #
    # @param uncommented [String] The uncommented function, defaults to ''
    # @return [String] the commented function
    def document_function(uncommented = '')
      return uncommented if uncommented.include?('#') || uncommented.empty?
      space = leading_whitespace(uncommented)
      commented = "#{space}#\n#{space}#\n"
      uncommented.split(/[,)(]|end|def/).each do |param|
        next if param.empty? || param.strip.empty? ||
                uncommented.match(/def (\w+)/)[1] == 'self' ||
                param.strip == uncommented.match(/def (\w+)\??/)[1]
        arg = param.split(/[:=]/)
        noop = arg.nil? || arg.empty?
        commented += "#{space}# @param #{(noop ? param : arg.first).strip}"\
                     " [Object]#{noop || arg.count == 1 ? '' : " defaults to #{arg.last.strip}"}\n"
      end
      commented + "#{space}# @return [Object]\n#{uncommented}\n"
    end

    # Document a ruby class
    #
    # @param uncommented [String] The uncommented class, defaults to ''
    # @return [String] The documented class
    def document_class(uncommented = '')
      return uncommented if uncommented.empty? || uncommented.match('#|(class << self)')
      "#{leading_whitespace(uncommented)}#\n#{uncommented}\n"
    end

    # Document internal assignments
    #
    # @param uncommented [String] The line to comment, defaults to ''
    # @return [String] The documented internal line
    def document_internal(uncommented = '')
      return uncommented if uncommented.include?('#') || uncommented == ''
      spaces = leading_whitespace(uncommented)
      "#{spaces}#\n#{spaces}#{uncommented}\n"
    end
  end
end
