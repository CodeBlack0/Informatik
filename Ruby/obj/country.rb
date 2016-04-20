class Country
  attr_reader :country_code, :country, :capital, :continent, :currency, :currency_code
  
  def initialize(country_code = "", country = "", capital = "", continent = "", currency = "", currency_code = "")
    @country_code = country_code
    @country = country 
    @capital = capital
    @continent = continent
    @currency = currency
    @currency_code = currency_code
  end  

end
