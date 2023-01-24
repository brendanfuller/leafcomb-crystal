require "colorize"


module Lexer

    ARITHMETIC_OPERATOR = ["+", "-", "*", "/", "%"]
    COMPARISON_OPERATOR = ["==", "!=", ">", "<", ">=", "<="]
    LOGICAL_OPERATOR = ["!", "||", "&&"]
    ASSIGNMENT_OPERATOR = ["=", "+=", "-="]
    
    enum Types
       LEFT_PARENTHESIS
       RIGHT_PARENTHESIS
       LEFT_BRACKET
       RIGHT_BRACKET
       LEFT_CURELY_BRACKET
       RIGHT_CURELY_BRACKET
       ARITHMETIC_OPERATOR
       COMPARISON_OPERATOR
       LOGICAL_OPERATOR
       ASSIGNMENT_OPERATOR
       COLON
       COMMA
       NUMBER
       STRING
       PERIOD
       SEMICOLON
       IDENTIFIER
    end
    class Lexer 

        def initialize(@content : String)
            @tokens = Array(Token).new

            cursor : Int32 = 0
            column : Int32 = 1
            line: Int32 = 1
            while cursor < @content.size()
                x = @content.chars[cursor]
                
                if x == '\n' || x == '\r'
                    cursor+=1
                    column=1
                    line+=1
                    puts "newline"
                    next
                end

                if x.ascii_whitespace? == true
                   cursor +=1
                   column += 1
                   next 
                end
              
                startLoc = Location.new(column,line)
                if x == '('
                    @tokens << Token.new(Types::LEFT_PARENTHESIS, "(", startLoc, startLoc)
                    cursor += 1
                    column += 1
                    next
                end

                if x == ')'
                    @tokens << Token.new(Types::RIGHT_PARENTHESIS, ")", startLoc, startLoc)
                    cursor += 1
                    column += 1
                    next
                end

                if x == '['
                    @tokens << Token.new(Types::LEFT_BRACKET, "[", startLoc, startLoc)
                    cursor += 1
                    column += 1
                    next
                end

                if x == ']'
                    @tokens << Token.new(Types::RIGHT_BRACKET, "]", startLoc, startLoc)
                    cursor += 1
                    column += 1
                    next
                end
                
                if x == '{'
                    @tokens << Token.new(Types::LEFT_CURELY_BRACKET, "{", startLoc, startLoc)
                    cursor += 1
                    column += 1
                    next
                end

                if x == '}'
                    @tokens << Token.new(Types::RIGHT_CURELY_BRACKET, "}", startLoc, startLoc)
                    cursor += 1
                    column += 1
                    next
                end

                if x == ':'
                    @tokens << Token.new(Types::COLON, ":", startLoc, startLoc)
                    cursor += 1
                    column += 1
                    next
                end

                if x == ';'
                    @tokens << Token.new(Types::SEMICOLON,";", startLoc, startLoc)
                    cursor += 1
                    column += 1
                    next
                end

                if x == '.'
                    @tokens << Token.new(Types::PERIOD, ".", startLoc, startLoc)
                    cursor += 1
                    column += 1
                    next
                end

                if x == ','
                    @tokens << Token.new(Types::COMMA, ",", startLoc, startLoc)
                    cursor += 1
                    column += 1
                    next
                end

                    
                if x == '"'
                    string : String = ""
                    endColumn = column
                    cursor += 1
                    while @content[cursor] != '"'
                        string += @content[cursor]  
                        if cursor + 1 == @content.size()
                            cursor += 1
                            column += 1
                            break
                        end
                        cursor += 1
                        column += 1
                        endColumn += 1 
                    end
                    cursor += 1
                    endLoc =  Location.new(endColumn,line)
                    @tokens << Token.new(Types::STRING, string, startLoc, endLoc)
                    next
                end

                if x.ascii_letter? == true
                    identifier : String = ""
                    endColumn = column
                    while (@content[cursor].ascii_alphanumeric? || @content[cursor] == '_')
                        identifier += @content[cursor]
                        
                        if cursor + 1 == @content.size()
                            puts "i was here probs"
                            cursor += 1
                            column += 1
                            break
                        end
                        endColumn += 1
                        cursor += 1
                        column += 1
                    end
                    endLoc =  Location.new(endColumn-1,line)
                    @tokens << Token.new(Types::STRING, identifier, startLoc, endLoc)
                    next
                end

                #Numerical
                if x.ascii_number? == true
                    number : String = ""
                    endColumn = column
                    while (@content[cursor].ascii_number? || @content[cursor] == '.')
                        number += @content[cursor]
                        if cursor + 1 == @content.size()
                            cursor += 1
                            column += 1
                            break
                        end
                        cursor += 1
                        column += 1
                        endColumn += 1
                    end
                    endLoc =  Location.new(endColumn-1,line)
                    @tokens << Token.new(Types::NUMBER, number, startLoc, endLoc)
                    next
                end

                #Assignment Operators
                continue = false
                ASSIGNMENT_OPERATOR.each do |elem|
                    l = elem.size
                    if (cursor + 1 == @content.size)
                        cursor += 1
                        column += 1
                        continue = true
                        break
                    end
                    if (elem == @content[cursor,l])
                        endLoc =  Location.new(column+l,line)
                        @tokens << Token.new(Types::ASSIGNMENT_OPERATOR, elem, startLoc, endLoc)
                        cursor += 1
                        column += 1
                        continue = true
                        break
                    end
                end
                if continue
                    next
                end

                #Comparasion Operators
                continue = false
                COMPARISON_OPERATOR.each do |elem|
                    l = elem.size
                    if (cursor + 1 == @content.size)
                        cursor += 1
                        column += 1
                        continue = true
                        break
                    end
                    if (elem == @content[cursor,l])
                        endLoc =  Location.new(column+l,line)
                        @tokens << Token.new(Types::COMPARISON_OPERATOR, elem, startLoc, endLoc)
                        cursor += 1
                        column += 1
                        continue = true
                        break
                    end
                end
                if continue
                    next
                end

                #Logical Operators
                continue = false
                LOGICAL_OPERATOR.each do |elem|
                    l = elem.size
                    if (cursor + 1 == @content.size)
                        cursor += 1
                        column += 1
                        continue = true
                        break
                    end
                    if (elem == @content[cursor,l])
                        endLoc =  Location.new(column+l,line)
                        @tokens << Token.new(Types::LOGICAL_OPERATOR, elem, startLoc, endLoc)
                        cursor += 1
                        column += 1
                        continue = true
                        break
                    end
                end
                if continue
                    next
                end


                 #Logical Operators
                 continue = false
                 ARITHMETIC_OPERATOR.each do |elem|
                     l = elem.size
                     if (cursor + 1 == @content.size)
                         cursor += 1
                         column += 1
                         continue = true
                         break
                     end
                     if (elem == @content[cursor,l])
                         endLoc =  Location.new(column+l,line)
                         @tokens << Token.new(Types::ASSIGNMENT_OPERATOR, elem, startLoc, endLoc)
                         cursor += 1
                         column += 1
                         continue = true
                         break
                     end
                 end
                 if continue
                     next
                 end

                error(x,line,cursor)
                break
            end

            puts "<DEBUG>"
            puts @tokens
        end


        def error(x : Char,line : Int32, cursor : Int32) 
            puts "Invalid character '" + x + "'"
        end
            
    end 

    class Token
        @type : Types
        @value : String
        @startLoc : Location
        @endLoc : Location
        def initialize(@type : Types, @value : String, @startLoc : Location, @endLoc : Location)end
    end

    class Location
        @column : Int32
        @line : Int32
        def initialize(@column : Int32, @line : Int32)end
    end
end 