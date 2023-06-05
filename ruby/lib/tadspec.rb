require_relative 'contextotest'

module TADSpec

  def deberia(contexto)
    raise NoSpyError if contexto.recibio_hr && not(self.is_a? Clonacion)
    contexto.ejecutar_para(self)
  end

  def ser(valor)
    return valor if valor.is_a? ContextoTest
    crear_contexto("Ser", valor)
  end

  def mayor_a(valor)
    crear_contexto("MayorA", valor)
  end

  def menor_a(valor)
    crear_contexto("MenorA", valor)
  end

  def uno_de_estos(*argumentos)
    valores = argumentos.size>1 ? argumentos : argumentos[0]
    crear_contexto("UnoDeEstos", valores)
  end

  def polimorfico_con(valor)
    agregar_accion(:polimorfismo => proc do |clase, objeto|
      clase.instance_methods(false).all? {|msj| objeto.respond_to? msj}
    end)
    crear_contexto("polimorfismo", valor)
  end

  def entender(mensaje)
    crear_contexto("Entender", mensaje)
  end

  def explotar_con(tipo_error)
    crear_contexto("ExplotarCon", tipo_error)
  end

  def incluye(mensaje)
    crear_contexto("incluye", mensaje)
  end

  def crear_contexto(test, valor_esperado)
    ContextoTest.new(valor_esperado, &acciones[test.to_sym])
  end

  def acciones
    {Ser: proc {|valor, obj| obj == valor}, MayorA: proc {|valor, obj| obj > valor}, MenorA: proc {|valor, obj| obj < valor},
     UnoDeEstos: proc {|valores, obj| valores.include? obj}, Entender: proc {|msj, obj| obj.respond_to? msj},
     ExplotarCon: proc do |error_esperado, bloque|
      begin
        bloque.call
      rescue StandardError => error_recibido
        error_recibido.is_a? error_esperado
      else
        false
      end
    end}
  end

  def agregar_accion(accion)
    nuevas_acciones = acciones.merge accion
    TADSpec.define_method(:acciones, proc {nuevas_acciones})
  end

  def method_missing(mensaje, *args)
    if mensaje.start_with?("ser_")
      nombre_mensaje = (mensaje.to_s.delete_prefix("ser_")+'?')
      agregar_accion( mensaje => proc {|valor, obj| obj.send(nombre_mensaje)} )
      crear_contexto(mensaje.to_s, true)

    elsif mensaje.start_with?("tener_")
      nombre_atributo = mensaje.to_s.delete_prefix("tener_")
      obtener_atributo = proc {|obj| obj.instance_variable_get("@#{nombre_atributo}")}
      ser(args.first).agregar_cond_previa(obtener_atributo)

    else
      super
    end
  end

  def respond_to_missing?(mensaje, priv = false)
    super || mensaje.start_with?("ser_") || mensaje.start_with?("tener_")
  end

end
