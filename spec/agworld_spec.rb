require 'dentaku/calculator'

describe "Agworld Requirements" do
  let(:calculator)  { Dentaku::Calculator.new }

  it 'should work for our purposes' do
    calculator.bind( :B8 => 20 )
    calculator.bind( :B9 => 210 )
    calculator.bind( :B10 => 'Reduced' )
    calculator.bind( :B11 => calculator.evaluate( '0.3961*B8^0.8206' ) )
    calculator.bind( :B12 => calculator.evaluate( 'IF(B10="Full",110,IF(B10="Reduced",99,88))' ) )
    calculator.bind( :B13 => 15 )
    calculator.bind( :B14 => calculator.evaluate( '(B9+B11-B12)*B13/1000' ) )

    calculator.bind( :B16 => 11 )
    calculator.bind( :B17 => 5.7 )
    calculator.bind( :B18 => calculator.evaluate( 'B14*1000*B16/B17/100' ) )
    calculator.bind( :B19 => 0.81 )
    calculator.bind( :B20 => 'High (50%)' )
    calculator.bind( :B21 => calculator.evaluate( 'IF(B20="Low (25%)",25,IF(B20="Medium (38%)",38,50))' ) )
    calculator.bind( :B22 => calculator.evaluate( '(B14*1000)*B16/B17/B19/B21' ) )
  end
end
