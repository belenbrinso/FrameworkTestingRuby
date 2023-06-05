require_relative '../lib/framework.rb'
require_relative '../lib/tadspec.rb'

class Ser < BasicTestSuite

  def self.testear_que_deberia_y_ser_funcionan_bien_juntos
    30.deberia(ser(30))
  end

  def self.testear_que_deberia_y_ser_funcionan_bien_juntos_con_la_otra_manera_de_enviar_mensajes
    30.deberia ser 30
  end

end


class SerConConfiguraciones < BasicTestSuite

  def self.testear_que_funciona_mayor_a_con_ser
    30.deberia ser mayor_a 5
  end

  def self.testear_que_funciona_menor_a_con_ser
    30.deberia ser menor_a 80
  end

  def self.testear_que_funciona_uno_de_estos_con_ser
    30.deberia ser uno_de_estos [5, "hola", 30, :hola]
  end

  def self.testear_que_funciona_uno_de_estos_con_varargs_junto_a_ser
    30.deberia ser uno_de_estos 5, "hola", 30, :hola
  end

end


class SerViejo < BasicTestSuite

  def self.testear_que_funciona_el_azucar_sintactico_para_mensajes_con_signo_de_pregunta
    Persona.new(30).deberia ser_viejo
  end

  def self.testear_que_ser_viejo_falla_si_la_persona_es_joven
    Persona.new(25).deberia ser_viejo
  end

  def self.testear_que_el_test_explota_si_no_existe_una_propiedad_booleana_para_el_mensaje_ser_enviado
    Persona.new(30).deberia ser_joven
  end

end


class Tener < BasicTestSuite

  def self.testear_que_tener_funciona_bien_si_existe_el_atributo_que_indica
    leandro = Persona.new(22)
    leandro.deberia tener_edad 22
  end

  def self.testear_que_tener_falla_si_no_existe_el_atributo_que_indica
    leandro = Persona.new(22)
    leandro.deberia tener_nombre "leandro"
  end

  def self.testear_que_si_no_existe_el_atributo_indicado_tener_devuelve_nil
    leandro = Persona.new(22)
    leandro.deberia tener_nombre nil
  end

end


class TenerConConfiguraciones < BasicTestSuite

  def self.testear_que_funciona_mayor_a_con_tener
    leandro = Persona.new(22)
    leandro.deberia tener_edad mayor_a 20
  end

  def self.testear_que_funciona_menor_a_con_tener
    leandro = Persona.new(22)
    leandro.deberia tener_edad menor_a 25
  end

  def self.testear_que_funciona_uno_de_estos_con_tener
    leandro = Persona.new(22)
    leandro.deberia tener_edad uno_de_estos [7, 22, "hola"]
  end

  def self.testear_que_funciona_uno_de_estos_con_varargs_junto_a_tener
    leandro = Persona.new(22)
    leandro.deberia tener_edad uno_de_estos 7, 22, "hola"
  end

end


class Entender < BasicTestSuite

  def self.testear_que_entender_funciona_si_el_objeto_puede_responder_el_mensaje_indicado_por_respond_to_missing?
    leandro = Persona.new(22)
    leandro.deberia entender :ser_viejo
  end

  def self.testear_que_entender_funciona_si_el_objeto_puede_responder_el_mensaje_indicado_por_respond_to_missing_parte_dos
    leandro = Persona.new(22)
    leandro.deberia entender :tener_edad
  end

  def self.testear_que_entender_funciona_si_el_objeto_tiene_definido_el_mensaje_indicado
    leandro = Persona.new(22)
    leandro.deberia entender :viejo?
  end

  def self.testear_que_entender_funciona_si_el_objeto_hereda_el_mensaje_indicado
    leandro = Persona.new(22)
    leandro.deberia entender :class
  end

  def self.testear_que_entender_falla_si_el_objeto_no_puede_responder_el_mensaje_indicado
    leandro = Persona.new(22)
    leandro.deberia entender :nombre
  end

end


class ExplotarCon < BasicTestSuite

  def self.testear_que_explotar_con_funciona_bien
    proc { 7/0 }.deberia explotar_con ZeroDivisionError
  end

  def self.testear_que_explotar_con_funciona_bien_parte_dos
    proc { Persona.new(30).nombre }.deberia explotar_con NoMethodError
  end

  def self.testear_que_explotar_con_tiene_en_cuenta_la_herencia_de_las_excepciones
    proc { Persona.new(30).nombre }.deberia explotar_con StandardError
  end

  def self.testear_que_explotar_con_falla_si_no_hay_una_excepcion
    proc { 7 + 7 }.deberia explotar_con NoMethodError
  end

  def self.testear_que_explotar_con_falla_si_no_lanza_la_excepcion_indicada
    proc { 7 / 0 }.deberia explotar_con NoMethodError
  end

end


class Mockear < BasicTestSuite

  def self.testear_que_el_mensaje_mockear_reemplaza_la_definicion_del_metodo_indicado_por_el_bloque_dado
    nico = Persona.new(30)
    axel = Persona.new(30)
    lean = Persona.new(22)

    PersonaHome.mockear(:todas_las_personas) do
      [nico, axel, lean]
    end

    viejos = PersonaHome.personas_viejas
    viejos.deberia ser [nico, axel]
  end

  def self.testear_que_el_mockeo_existe_solo_durante_la_ejecucion_del_test
    todos = PersonaHome.todas_las_personas
    todos.deberia ser ["d", :hola, 1]
  end

end


class Espiar < BasicTestSuite

  def self.testear_que_falla_si_queremos_usar_la_asercion_haber_recibido_con_un_objeto_que_no_fue_espiado
    lean = Persona.new(22)
    lean.viejo?
    lean.deberia haber_recibido(:edad)
  end

  def self.testear_que_se_usa_la_edad
    pato = Persona.new(23)
    pato = espiar(pato)
    pato.viejo?

    pato.deberia haber_recibido(:edad)
  end

  def self.testear_que_se_usa_la_edad_una_vez
    pato = Persona.new(23)
    pato = espiar(pato)
    pato.viejo?

    pato.deberia haber_recibido(:edad).veces(1)
  end

  def self.testear_que_falla_si_decimos_que_se_usa_la_edad_mas_de_una_vez
    pato = Persona.new(23)
    pato = espiar(pato)
    pato.viejo?

    pato.deberia haber_recibido(:edad).veces(5)
  end

  def self.testear_que_funciona_si_indicamos_los_argumentos_correctos
    pato = Persona.new(23)
    pato = espiar(pato)
    pato.viejo?

    pato.deberia haber_recibido(:viejo?).con_argumentos()
  end

  def self.testear_que_falla_si_indicamos_los_argumentos_incorrectos
    pato = Persona.new(23)
    pato = espiar(pato)
    pato.viejo?

    pato.deberia haber_recibido(:viejo?).con_argumentos(19, "hola")
  end

end


# TP INDIVIDUAL
class TpIndividual < BasicTestSuite

  def self.testear_que_funciona_polimorfico_con_teniendo_una_instancia_de_Object
    un_objeto = Object.new
    un_objeto.define_singleton_method(:viejo?, proc {"hola"})
    un_objeto.define_singleton_method(:envejecer, proc {"chau"})

    un_objeto.deberia ser polimorfico_con Persona
  end

  def self.testear_que_funciona_polimorfico_con_teniendo_una_instancia_de_la_clase_pasada
    un_objeto = Persona.new(22)

    un_objeto.deberia ser polimorfico_con Persona
  end

  def self.testear_que_falla_polimorfico_con_si_el_objeto_no_entiende_los_mensajes_provistos_por_la_clase
    un_objeto = PersonaHome.new

    un_objeto.deberia ser polimorfico_con Persona
  end

end