require_relative 'framework'

class ContextoBasico
  attr_reader :objeto_target

  def setear_objeto_target(obj)
    @objeto_target = obj
  end
end

class ContextoTest < ContextoBasico
  include Spies
  attr_reader :valor_esperado, :accion, :condiciones_previas, :recibio_hr

  def initialize(valor_esperado, &accion)
    super()
    @valor_esperado = valor_esperado
    @accion = accion
    @condiciones_previas = []
    @recibio_hr = false
  end

  def agregar_cond_previa(condicion)
    @condiciones_previas << condicion
    self
  end

  def ejecutar_para(objeto_target)
    setear_objeto_target(objeto_target)
    ejecutar
  end

  def ejecutar
    resultado_cond_previas = condiciones_previas.inject(objeto_target) { |elem, cond| cond.call(elem) }
    resultado = @accion.call(valor_esperado, resultado_cond_previas)
    raise AssertionError.new(valor_esperado, resultado) unless resultado
    resultado
  end

end


class AssertionError < StandardError
  def initialize(valor_esperado, resultado)
    @valor_esperado = valor_esperado
    @resultado = resultado
  end

  def mensaje(test)
    "■ Test #{test}: falló - Valor esperado: #{@valor_esperado}, valor obtenido: #{@resultado}"
  end
end


class NoSpyError < StandardError; end