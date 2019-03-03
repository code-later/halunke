=begin
%%{
  machine tokenizer;

  number = ('+'|'-')?[0-9]+('.'[0-9]+)?;
  string = '"' [^"]* '"';
  unassigned_bareword = "'" [a-zA-Z_]+;
  bareword = [a-zA-Z_]+ | '+' | '-' | '*' | '/' | '<' | '>' | '=' | '@' | '**';
  open_paren = '(';
  close_paren = ')';
  open_curly = '{';
  close_curly = '}';
  open_bracket = '[';
  close_bracket = ']';
  open_dict_bracket = '@[';
  start_comment = '/*';
  end_comment = '*/';
  bar = "|";

  main := |*

    number => { emit(:NUMBER, data[ts...te].to_r) };
    string => { emit(:STRING, data[ts+1...te-1]) };
    unassigned_bareword => { emit(:UNASSIGNED_BAREWORD, data[ts+1 ...te]) };
    bareword => { emit(:BAREWORD, data[ts...te]) };
    open_paren => { emit(:OPEN_PAREN, data[ts...te]) };
    close_paren => { emit(:CLOSE_PAREN, data[ts...te]) };
    open_curly => { emit(:OPEN_CURLY, data[ts...te]) };
    close_curly => { emit(:CLOSE_CURLY, data[ts...te]) };
    open_bracket => { emit(:OPEN_BRACKET, data[ts...te]) };
    close_bracket => { emit(:CLOSE_BRACKET, data[ts...te]) };
    open_dict_bracket => { emit(:OPEN_DICT_BRACKET, data[ts...te]) };
    start_comment => { emit(:START_COMMENT, data[ts...te]) };
    end_comment => { emit(:END_COMMENT, data[ts...te]) };
    bar => { emit(:BAR, data[ts...te]) };
    space;
    any => { raise "Could not lex '#{ data[ts...te] }'" };

  *|;
}%%
=end

module Halunke
  class Tokenizer
    def initialize
      %% write data;
      @tokens = []
    end

    def tokenize(data)
      data.chomp!
      eof = data.length

      %% write init;
      %% write exec;

      @tokens
    end

    private

    def emit(type, value)
      @tokens << [ type, value ]
    end
  end
end
