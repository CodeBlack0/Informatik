class Aufgabe
  attr_accessor :beschreibung, :zeitstempel, :status

  def initialize(beschreibung = "", zeitstempel = Time.new, status = "offen")
    @beschreibung = beschreibung
    @zeitstempel = zeitstempel
    @status = status
  end

  def erledigt!()
    @status = "erledigt"
  end

  def erledigt?()
    (@status == "erledigt") ? true : false
  end

  def datum()
    @zeitstempel.strftime("%F")
  end

  def to_s()
    "#{@beschreibung} [angelegt #{datum()}, #{@status}]"
  end
end