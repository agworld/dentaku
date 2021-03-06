require 'dentaku/token'
require 'dentaku/token_matcher'
require 'dentaku/token_scanner'

module Dentaku
  class Tokenizer
    SCANNERS = [
      TokenScanner.new(:whitespace, '\s+'),
      TokenScanner.new(:numeric,    '(\d+(\.\d+)?|\.\d+)', lambda{|raw| raw =~ /\./ ? raw.to_f : raw.to_i }),
      TokenScanner.new(:string,     '"[^"]*"',    lambda{|raw| raw.gsub(/^"|"$/, '') }),
      TokenScanner.new(:string,     "'[^']*'",    lambda{|raw| raw.gsub(/^'|'$/, '') }),
      TokenScanner.new(:operator,   '\^|\+|-|\*|\/', lambda do |raw|
        case raw
        when '^' then :pow
        when '+' then :add
        when '-' then :subtract
        when '*' then :multiply
        when '/' then :divide
        end
      end),
      TokenScanner.new(:grouping,   '\(|\)|,', lambda do |raw|
        case raw
        when '(' then :open
        when ')' then :close
        when ',' then :comma
        end
      end),
      TokenScanner.new(:comparator, '<=|>=|!=|<>|<|>|=', lambda do |raw|
        case raw
        when '<=' then :le
        when '>=' then :ge
        when '!=' then :ne
        when '<>' then :ne
        when '<'  then :lt
        when '>'  then :gt
        when '='  then :eq
        end
      end),
      TokenScanner.new(:combinator, '(and|or)\b', lambda {|raw| raw.strip.downcase.to_sym }),
      TokenScanner.new(:function,   '(if|round)\b', lambda {|raw| raw.strip.downcase.to_sym }),
      TokenScanner.new(:identifier, '[a-z_][a-z0-9_]*', lambda {|raw| raw.strip.to_sym })
    ]

    LPAREN = TokenMatcher.new(:grouping, :open)
    RPAREN = TokenMatcher.new(:grouping, :close)

    def tokenize(string)
      nesting = 0
      tokens  = []
      input   = string.dup

      until input.empty?
        raise "parse error at: '#{ input }'" unless SCANNERS.any? do |scanner|
          if token = scanner.scan(input)
            raise "unexpected zero-width match (:#{ token.category }) at '#{ input }'" if token.length == 0

            nesting += 1 if LPAREN == token
            nesting -= 1 if RPAREN == token
            raise "too many closing parentheses" if nesting < 0

            if token.value == :subtract
              if tokens.length == 0 || !(tokens.last.is?(:identifier) || tokens.last.is?(:numeric) || tokens.last.value == :close)
                token = Token.new(token.category, :unary, token.raw_value)
              end
            end

            tokens << token unless token.is?(:whitespace)
            input.slice!(0, token.length)

            true
          else
            false
          end
        end
      end

      raise "too many opening parentheses" if nesting > 0
      tokens.shift if tokens.length > 0 && tokens.first.raw_value == '='
      tokens
    end
  end
end
