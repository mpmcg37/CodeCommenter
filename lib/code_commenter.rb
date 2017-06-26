require_relative 'code_commenter/version'
require_relative 'code_commenter/code_comment'
require_relative 'code_commenter/code_comment_ruby'

# Code Commenter, fills in the boiler plate for getting code comments in place
module CodeCommenter
  class << self
    # Comment on a given filename
    #
    # @param filename [String] The name of the file to apply comments on
    def comment_on_file(filename)
      extension = filename.split('.').last
      code_comment = case extension
                     when 'rb'
                       CodeCommenter::Ruby.new file: filename
                     else
                       puts "\tUnable to comment files with extension: #{extension}. Skipping: #{filename}"
                       return ''
                     end
      puts "\tApplying comments to file: #{filename}"
      File.open(filename, 'w') { |file| file.write code_comment.contents }
      code_comment.contents
    end
  end
end


