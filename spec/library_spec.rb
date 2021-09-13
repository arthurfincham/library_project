require 'spec_helper'

describe "Library Object" do

  before :all do
    lib_arr = [
      Book.new("JavaScript: The Good Parts", "D. Crockford", :development),
      Book.new("Designing the Web Standards", "J. Zeldman", :design),
      Book.new("Don't Make Me Think", "S. Krug", :usability),
      Book.new("JavaScript Patterns", "S. Stefanov", :development),
      Book.new("Responsive Web Design", "E. Marcotte", :design)
    ]

    File.open "books.yml", "w" do |file|
      file.write YAML::dump lib_arr
    end
  end

  before :each do
    @lib = Library.new "books.yml"
  end

  describe "#new" do
    context "with no parameters" do
      it "has no books" do
        lib = Library.new
        expect(lib).to have(0).books
      end
    end

    context "with yaml file name parameter" do
      it "has five books" do
        expect(@lib).to have(5).books
      end
    end
  end

  it "returns all the books in a given category" do
    expect(@lib).to have(2).books_in_category(:development)
  end

  it "accepts new books" do
    @lib.add_book(Book.new("Clean Code", "J.Smith", :design))
    expect(@lib.get_book("Clean Code")).to be_an_instance_of Book
  end

  it "saves the library" do
    books = @lib.books.map { |book| book.title }
    @lib.save "our_new_library.yml"
    lib2 = Library.new "our_new_library.yml"
    books2 = lib2.books.map { |book| book.title }
    expect(books).to eql books2
  end
end