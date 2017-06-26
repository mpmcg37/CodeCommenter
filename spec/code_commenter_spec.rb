require 'spec_helper'

RSpec.describe CodeCommenter do
  it 'has a version number' do
    expect(CodeCommenter::VERSION).not_to be nil
  end

  it 'has a working leading whitespace function' do
    w = "\t  "
    expect(CodeCommenter::CodeComment.new(test: true).leading_whitespace("#{w}def t")).to eq w
  end

  it 'returns an empty string if it fails to comment on a file' do
    expect(CodeCommenter.comment_on_file('testing.fails')).to eq ''
  end

  it 'has defaults' do
    test = CodeCommenter::CodeComment.new test: true
    expect(test.class_line?('') || test.function_line?('') || test.internal_line?('')).to eq false
    expect(test.dont_comment_line?(line:'', prev_line: '')).to eq true
  end
end
