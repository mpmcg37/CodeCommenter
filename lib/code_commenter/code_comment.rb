# Contains the CodeComment class, the base class for all code commenting
module CodeCommenter
  class << self
    def NOT_IMPLEMENTED
      'Not_implemented'
    end
  end
  # The methods required to create comments for a given language
  class CodeComment
    attr_reader :contents
    # Create a new code comment, either filename or contents must be empty but
    # not both. Commented version is saved to contents. Use this to create a new
    # code comment.
    # A subclass must override the methods document_function,
    # document_class, document_internal, dont_comment_line?, class_line?,
    # function_line?, and internal_line?.
    #
    # @param file [String] The file to open and comment, defaults to ''
    # @param contents [String] The file contents to comment, defaults to ''
    # @return [CodeComment] The newly created code comment.
    def initialize(file: '', contents: '', test: false)
      return if test
      if (file.empty? && contents.empty?) || (!file.empty? && !contents.empty?)
        raise 'Either contents or filename must be specified but not both.'
      end
      @contents = if file.empty?
                    document_file_contents(contents)
                  else
                    document_file(file)
                  end
    end

    # Extensions it can comment on
    #
    # @return [[String]] The list of strings that represent this languages file extension
    def extensions
      raise CodeCommenter.NOT_IMPLEMENTED
    end

    # Document a function
    #
    # @param uncommented [String] The uncommented function, defaults to ''
    # @return [String] the documented function
    def document_function(uncommented = '')
      raise CodeCommenter.NOT_IMPLEMENTED
    end

    # Document a class
    #
    # @param uncommented [String] The uncommented class, defaults to ''
    # @return [String] The documented class
    def document_class(uncommented = '')
      raise CodeCommenter.NOT_IMPLEMENTED
    end

    # Document internal assignments
    #
    # @param uncommented [String] The line to comment, defaults to ''
    # @return [String] The documented internal line
    def document_internal(uncommented = '')
      raise CodeCommenter.NOT_IMPLEMENTED
    end

    # Is this a function line that should be commented?
    #
    # @param line [String] The current line
    # @return [false]
    def function_line?(line)
      false
    end

    # Is this a class line that should be commented?
    #
    # @param line [String] The current line
    # @return [false]
    def class_line?(line)
      false
    end

    # Is this an internal line that should be commented?
    #
    # @param line [String] The current line
    # @return [false]
    def internal_line?(line)
      false
    end

    # Is this line one that should not be commented? Either a comment, a line
    # that follows a comment, or any line that should not be commented on.
    # This helps to avoid putting comments on other comments
    #
    # @param line [String] The current line
    # @param prev_line [String] The previous line
    # @return [true]
    def dont_comment_line?(line = '', prev_line = '')
      true
    end

    # Document a file line
    #
    # @param line [String] The line to comment
    # @param prev_line [String] The previous line, defaults to ''
    # @return [String] The commented line or the original line appended with a new line
    def document_file_line(line, prev_line: '')
      if dont_comment_line?( line, prev_line)
        line + "\n"
      elsif function_line?(line)
        document_function line
      elsif class_line?(line)
        document_class line
      elsif internal_line?(line)
        document_internal line
      else
        line + "\n"
      end
    end

    # Document file contents
    #
    # @param file_contents [String] The file contents to comment, defaults to ''
    # @return [String] The commented file contents
    def document_file_contents(file_contents = '')
      commented_file = ''
      prev_line = ''
      file_contents.split("\n").each do |line|
        commented_file += document_file_line line, prev_line: prev_line
        prev_line = line
      end
      commented_file
    end

    # Document a file
    #
    # @param uncommented_file [String] The name of the file, defaults to ''
    # @return [String] The commented file
    def document_file(uncommented_file = '')
      raise 'Invalid file extension.' unless extensions.include?(uncommented_file.split('.').last)
      commented_file = ''
      last = ''
      File.foreach(uncommented_file).with_index do |line, _|
        commented_file += document_file_line line.delete("\n"), prev_line: last
        last = line
      end
      commented_file
    end

    # Get the leading whitespace from a line
    #
    # @param line [String] The line to get leading whitespace from
    # @return [String] The leading whitespace at the beginning of the line
    def leading_whitespace(line)
      line.match(/(\s*)\w+/)[1]
    end
  end
end
