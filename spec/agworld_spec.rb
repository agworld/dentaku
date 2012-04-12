require 'dentaku/calculator'

describe "Agworld Requirements" do
  let(:calculator)  { Dentaku::Calculator.new }

  it 'should calculate everything correctly' do
    calculator.bind( :AA => "=3-1" )
    calculator.memory(:AA).should eq(2)

    calculator.bind( :BB => "=-1+3" )
    calculator.memory(:BB).should eq(2)

    calculator.bind( :B8 => 20 )
    calculator.bind( :B9 => 210 )
    calculator.bind( :B10 => 'Reduced' )
    calculator.bind( :B11 => '=0.3961*B8^0.8206' )
    calculator.bind( :B12 => '=IF(B10="Full",110,IF(B10="Reduced",99,88))' )
    calculator.bind( :B13 => 15 )
    calculator.bind( :B14 => '=(B9+B11-B12)*B13/1000' )

    calculator.bind( :B16 => 11 )
    calculator.bind( :B17 => 5.7 )
    calculator.bind( :B18 => '=B14*1000*B16/B17/100' )
    calculator.bind( :B19 => 0.81 )
    calculator.bind( :B20 => 'High (50%)' )
    calculator.bind( :B21 => '=IF(B20="Low (25%)",25,IF(B20="Medium (38%)",38,50))' )
    calculator.bind( :B22 => '=(B14*1000)*B16/B17/B19/B21' )

    calculator.memory.each do |name, value|
      puts "#{name} = #{value}"
    end

    calculator.bind( :B63 => 25 )
    calculator.bind( :B64 => 60 )
    calculator.bind( :B65 => '=4.6*B64^0.393' )
    calculator.bind( :B66 => '=B65-B63' )
    calculator.bind( :B67 => '=2.6+0.0012*B64' )
    calculator.bind( :B68 => '=B66*B67' )
    calculator.bind( :B69 => '=0.27*B68-0.0008*B68^2' )
    calculator.bind( :B70 => 3.99 )
    calculator.bind( :B71 => 0.9 )
    calculator.bind( :B72 => '=((59690-60*B64+0.03*B64^2)/100000)+0.15' )
    calculator.bind( :B73 => '=B14*B70/B71/B72' )
    calculator.bind( :B74 => '=B69+B73' )
    calculator.bind( :B75 => '=IF(B74<0,0,IF(B74<5,5,B74))' )
    calculator.bind( :B76 => '=IF(B74>39.9,1,IF(B74>15,(B74-40)/-25*20,IF(B74>0,20+(B74-15)/-15*20,IF(B74>-10,40+B74/-10*10,IF(B74>-40,50+(B74+10)/-30*10,IF(B74>-150,60+(B74+40)/-110*20,80))))))' )
    calculator.memory(:B75).should be_within(0.5).of(9)
    calculator.memory(:B76).should be_within(0.5).of(28)

    calculator.bind( :B79 => 12 )
    calculator.bind( :B80 => 60 )
    calculator.bind( :B81 => 'Sandy loam' )
    calculator.bind( :B82 => 2 ) # TODO: vlookup
    calculator.bind( :B83 => '=B79*B82' )
    calculator.bind( :B84 => '=4.6*B80^0.393' )
    calculator.bind( :B85 => '=B84-B83' )
    calculator.bind( :B86 => '=2.6+0.0012*B80' )
    calculator.bind( :B87 => '=B85*B86' )
    calculator.bind( :B88 => '=0.27*B87-0.0008*B87^2' )
    calculator.bind( :B89 => 3.99 )
    calculator.bind( :B90 => 0.9 )
    calculator.bind( :B91 => '=((59690-60*B80+0.03*B80^2)/100000)+0.15' )
    calculator.bind( :B92 => '=B14*B89/B90/B91' )
    calculator.bind( :B93 => '=B88+B92' )
    calculator.bind( :B94 => '=IF(B93<0,0,IF(B93<5,5,B93))' )
    calculator.bind( :B95 => '=IF(B93>39.9,1,IF(B93>15,(B93-40)/-25*20,IF(B93>0,20+(B93-15)/-15*20,IF(B93>-10,40+B93/-10*10,IF(B93>-40,50+(B93+10)/-30*10,IF(B93>-150,60+(B93+40)/-110*20,80))))))' )
    calculator.memory(:B94).should be_within(0.05).of(10.1)
    calculator.memory(:B95).should be_within(0.5).of(27)
  end
end
