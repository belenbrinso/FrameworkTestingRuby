class Persona
  #attr_accessor :edad

  def initialize(edad)
    @edad = edad
  end

  def viejo?
    @edad > 29
  end

  def envejecer(anios)
    @edad = @edad + anios
  end
end


class PersonaHome

  def self.todas_las_personas
    ["d", :hola, 1]
  end

  def self.personas_viejas
    todas_las_personas.select{|p| p.viejo?}
  end

end