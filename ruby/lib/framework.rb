require_relative 'mocking_spying'
require_relative 'tadspec'

class BasicTestSuite
  singleton_class.send(:attr_reader, :pasados, :fallados, :explotados)

  def self.testear(tests_elegidos)
    tests = todos_mis_tests
    unless tests_elegidos.nil?
      tests = tests_elegidos.collect { |test| "testear_que_" + test.to_s }
    end

    @pasados = 0
    @fallados = 0
    @explotados = 0
    tests.each do |test|
      begin
        nombre_test = test.to_sym.name.to_s.delete_prefix("testear_que_")
        send(test)
      rescue NoSpyError
        puts "■ Test #{nombre_test}: falló - Se intentó usar la configuración “haber_recibido” con un objeto que no fue espiado previamente"
        @fallados += 1
      rescue AssertionError => excep
        puts excep.mensaje(nombre_test)
        @fallados += 1
      rescue StandardError => excep
        puts "■ Test #{nombre_test}: explotó - Excepción lanzada: #{excep.message}, producida por el siguiente stack: #{excep.backtrace}"
        @explotados += 1
      else
        puts "■ Test #{nombre_test}: pasó"
        @pasados += 1
      end
      deshacer_mockeo if hay_un_mockeado
    end
    mostrar_conteos
  end

  def self.todos_mis_tests
    methods(false).keep_if {|nombre_metodo| nombre_metodo.to_s.start_with?('testear_que_')}
  end

  def self.mostrar_conteos
    puts "Cantidad de tests corridos: #{@pasados + @fallados + @explotados}"
    puts "\tPasaron: #{@pasados}"
    puts "\tFallaron: #{@fallados}"
    puts "\tExplotaron: #{@explotados}"
  end

end


class TADsPec

  def self.testear(*varargs)
    Object.include TADSpec
    Module.include Mocking
    testsuite = varargs.first
    tests = varargs.drop(1)
    if testsuite.nil?
      testssuites_del_contexto.each {|ts| testear_una_testsuite(ts)}
    elsif tests.empty?
      testear_una_testsuite(testsuite)
    else
      testear_una_testsuite(testsuite, tests)
    end
  end

  def self.testssuites_del_contexto
    ObjectSpace.each_object(Class).select {|objeto| objeto < BasicTestSuite}
  end

  def self.testear_una_testsuite(testsuite, tests = nil)
    puts "TESTEAMOS LA TESTSUITE '#{testsuite.name.to_s.upcase}'"
    testsuite.testear(tests)
    puts ""
  end

end