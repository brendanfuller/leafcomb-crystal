require "option_parser"
require "./lexer.cr"

VERSION = "0.0.1"
NAME = "Leaf"


def prefix(state : Bool, ) 
    icon = "✘".colorize(:red);
    if (state) 
        icon = "✔".colorize(:green)
    end
    
    return "#{"[#{NAME}]".colorize(:light_green)} #{icon} " 
end

OptionParser.parse do |parser|
  parser.banner = "Leaf - A dynamically explicit callback runtime"

  parser.on "run", "run [program]" do |file| 
    if (ARGV.size > 1) 
        file_name = ARGV[1]
        if (File.exists?(file_name)) 
            file_content = File.read(file_name)
            value = Lexer::Lexer.new(file_content)     
        else
            puts "#{prefix(false)}Failed to load file '#{file_name}'..."
        end
    else
        puts "#{prefix(false)}No file provided"
    end
  
    exit
  end

  parser.on "-v", "--version", "Show version" do
    puts VERSION
    exit
  end

  parser.on "-h", "--help", "Show help" do
    puts parser
    exit
  end
  if (ARGV.size == 0) 
    puts parser
    exit
  end 
end




