require "./lexer.cr"


file_content = File.read("main.leaf")

value = Lexer::Lexer.new(file_content)


