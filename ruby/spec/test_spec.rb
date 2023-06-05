require_relative 'para_testear'

describe 'Test TADSPEC' do
  let(:edad) { 20 }
  let(:prueba) { Persona.new(edad) }

  describe 'ser' do
    it 'si le paso el bloque ser a deberia, este lo entiende' do
      expect(prueba.edad.deberia(ser(edad))).to be true
    end

    it 'probamos la otra manera de enviar mensajes' do
      expect(prueba.edad.deberia ser edad).to be true
    end

    it 'mayor_a: variante de ser' do
      expect(prueba.edad.deberia ser mayor_a 10).to be true
    end

    it 'menor_a: variante de ser' do
      expect(prueba.edad.deberia ser menor_a 30).to be true
    end

    it 'uno_de_estos: variante de ser' do
      expect(prueba.edad.deberia ser uno_de_estos ["hola", :nop, edad]).to be true
    end

    it 'uno_de_estos: variante de ser, pasamos diferente los parametros' do
      expect(prueba.edad.deberia ser uno_de_estos "hola", :nop, edad).to be true
    end

    context 'deberia ser_<mensaje>' do
      context 'ser realmente viejo' do
        let(:ernesto) { Persona.new(36) }

        it 'ernesto ya es viejo' do
          resultado = ernesto.deberia ernesto.ser_viejo
          expect(resultado).to be true
        end
      end

      it 'prueba no deberia ser viejos aun' do
        expect { prueba.deberia prueba.ser_viejo }.to raise_error(AssertionError)
      end
    end
  end

  context 'otro prefijo deberia fallar' do
    it 'deberia fallar con NoMethodError' do
      expect { prueba.deberia prueba.sfidhf_viejo }.to raise_error(NoMethodError)
    end

  end

  describe 'explotar_con' do
    it '' do
      expect(proc { 7 / 0 }.deberia explotar_con ZeroDivisionError).to be true
    end

    it '' do
      expect(proc { Persona.new(30).nombre }.deberia explotar_con NoMethodError).to be true
    end

    it '' do
      expect(proc { Persona.new(30).nombre }.deberia explotar_con StandardError).to be true
    end

    it '' do
      expect{proc { 7 + 7}.deberia explotar_con NoMethodError}.to raise_error(AssertionError)
    end

    it '' do
      expect{proc { 7 / 0 }.deberia explotar_con NoMethodError}.to raise_error(AssertionError)
    end
  end
end