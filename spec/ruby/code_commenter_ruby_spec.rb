require 'spec_helper'

RSpec.describe CodeCommenter::Ruby do
  it "has the code comment as it's parent" do
    expect(CodeCommenter::Ruby.superclass).to be CodeCommenter::CodeComment
  end

  it 'has valid extensions' do
    expect(CodeCommenter.ruby.extensions).to eq ['rb']
  end

  it 'can document a function' do
    uncommented = 'def abc(a1, a2)end'
    commented = "#\n"\
                "#\n"\
                "# @param a1 [Object]\n"\
                "# @param a2 [Object]\n"\
                "# @return [Object]\n"\
                "def abc(a1, a2)end\n"
    expect(commented).to eq CodeCommenter.ruby.document_function(uncommented)
    uncommented1 = 'def abc end'
    commented1 = "#\n"\
                "#\n"\
                "# @return [Object]\n"\
                "def abc end\n"
    expect(commented1).to eq CodeCommenter.ruby.document_function(uncommented1)
  end

  it 'can document a function with hash arguments' do
    uncommented1 = 'def abc(a1:,a2: nil)end'
    commented1 = "#\n"\
                "#\n"\
                "# @param a1 [Object]\n"\
                "# @param a2 [Object] defaults to nil\n"\
                "# @return [Object]\n"\
                "def abc(a1:,a2: nil)end\n"
    expect(commented1).to eq CodeCommenter.ruby.document_function(uncommented1)
    uncommented2 = 'def abc(a1, a2 = 1)end'
    commented2 = "#\n"\
                "#\n"\
                "# @param a1 [Object]\n"\
                "# @param a2 [Object] defaults to 1\n"\
                "# @return [Object]\n"\
                "def abc(a1, a2 = 1)end\n"
    expect(commented2).to eq CodeCommenter.ruby.document_function(uncommented2)
  end

  it 'can document a function called defend' do
    uncommented = 'def defend end'
    commented = "#\n"\
                "#\n"\
                "# @return [Object]\n"\
                "def defend end\n"
    expect(commented).to eq CodeCommenter.ruby.document_function(uncommented)
  end

  it 'can ignore a call to a function with class in the name' do
    uncommented = 'document_class line'
    expect(CodeCommenter.ruby.document_file_contents(uncommented)).to eq "#{uncommented}\n"
    expect(CodeCommenter.ruby.document_file_contents(uncommented)).to eq CodeCommenter::Ruby.new(contents: uncommented).contents
  end

  it "doesn't over document a function" do
    commented = "#\n"\
                "#\n"\
                "# @param a1 [Sauce] The steak sauce\n"\
                "# @param a2 [Sauce] An unworthy competitor\n"\
                "# @return [Sauce] The champion\n"\
                "def abc(a1, a2)end\n"
    expect(CodeCommenter.ruby.document_file_contents(commented)).to eq commented
    expect(CodeCommenter.ruby.document_file_contents(commented)).to eq CodeCommenter::Ruby.new(contents: commented).contents
  end

  it 'can document a class' do
    uncommented1 = 'class TestA'
    uncommented2 = 'class TestB < A'
    uncommented_self = 'class << self'
    expect(CodeCommenter.ruby.document_class(uncommented1)).to eq "#\n#{uncommented1}\n"
    expect(CodeCommenter.ruby.document_class(uncommented2)).to eq "#\n#{uncommented2}\n"
    expect(CodeCommenter.ruby.document_class(uncommented_self)).to eq uncommented_self
  end

  it 'can document internals of a class' do
    uncommented1 = 'attr_accessor :testing'
    uncommented2 = '@a = testing - 5'
    uncommented_self = 'class << self'
    expect(CodeCommenter.ruby.document_internal(uncommented1)).to eq "#\n#{uncommented1}\n"
    expect(CodeCommenter.ruby.document_internal(uncommented2)).to eq "#\n#{uncommented2}\n"
    expect(CodeCommenter.ruby.document_internal(uncommented_self)).to eq "#\n#{uncommented_self}\n"
  end

  it 'can document a ruby file' do
    expect(CodeCommenter.ruby.document_file('spec/ruby/test_class.rb')).to eq File.read 'spec/ruby/commented_test_class.rb'
    expect(CodeCommenter.ruby.document_file('spec/ruby/test_class.rb')).to eq CodeCommenter.comment_on_file 'spec/ruby/test_class.rb'
  end
end
