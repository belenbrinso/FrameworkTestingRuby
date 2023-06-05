module Mocking

  def mockear(nombre_metodo, &cuerpo_metodo)
    @nombre_metodo = nombre_metodo
    singleton_class.send(:alias_method, :metodo_original, nombre_metodo)
    @metodo_original = method(nombre_metodo).unbind
    self.define_singleton_method nombre_metodo, cuerpo_metodo
    clase_moqueada = self
    Module.define_singleton_method :mockeado_actual, proc { clase_moqueada }
  end

  def deshacer_mockeo
    mockeado_actual = Module.mockeado_actual
    metodo_original = mockeado_actual.instance_variable_get(:@metodo_original)
    nombre_original = mockeado_actual.instance_variable_get(:@nombre_metodo)
    mockeado_actual.define_singleton_method nombre_original, metodo_original
    Module.define_singleton_method :mockeado_actual, proc {}
  end

  def hay_un_mockeado
    Module.respond_to?(:mockeado_actual) && Module.mockeado_actual!=nil
  end

  def espiar(objeto)
    Clonacion.new(objeto)
  end

end


module TADSpec
  def haber_recibido(mensaje)
    agregar_accion(:incluye => proc { |valor, obj| obj.include? valor })
    contexto_test = tener_mensajes_recibidos incluye mensaje
    contexto_test.instance_variable_set(:@recibio_hr, true)
    contexto_test
  end
end


class Clonacion
  attr_reader :mensajes_recibidos

  def initialize(objeto)
    @mensajes_recibidos = {}
    @objeto_original = objeto
    @objeto_clonado = objeto.clone
    @objeto_clonado.instance_variable_set(:@registrador, self)
    objeto.class.instance_methods(false).each do |metodo|
      @objeto_clonado.define_singleton_method(metodo) {|*args| @registrador.send(metodo, *args)}
    end
  end

  def method_missing(nombre_mensaje, *args, &block)
    @mensajes_recibidos.merge!(nombre_mensaje => args)
    metodo = @objeto_original.method(nombre_mensaje)
    @objeto_clonado.define_singleton_method(nombre_mensaje, metodo)
    @objeto_clonado.send(nombre_mensaje, *args)
  end
end


module Spies
  def veces(cantidad)
    condicion = proc { |obj| obj.keys.select{|elem| obj.keys.count(elem) == cantidad} }
    agregar_cond_previa(condicion)
  end

  def con_argumentos(*args)
    condicion = proc { |obj| obj.select{|k,v| obj[k] == args}.keys }
    agregar_cond_previa(condicion)
  end
end