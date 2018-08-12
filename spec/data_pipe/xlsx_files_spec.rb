
RSpec.describe "Handle of XLSX files" do
  context "loads a XLSX file without header" do
    it "ignore headers if not parsed" do
      output = StringIO.new

      DataPipe.create do
        log_to StringIO.new

        load_from_xlsx(
          stream: "spec/sample/1.xlsx",
          sheet: "Compilado",
          first_data_row: 3,
        )
        write_to_csv stream: output, headers: false
      end.process!

      expect(output.string).to eq <<-FILE
1,2018-04-10T00:00:00+00:00,Seguridad,OtrosRobos,Asalto a negocio con violencia,,,,,,,test,test,test,,,,,,,,,test,SALTILLO,25113 ,25.453783,-101.019807,test,test,,07:00-08:00,,,,,,,,,,,,,
      FILE
    end

    it "writes it as is" do
      output = StringIO.new

      DataPipe.create do
        log_to StringIO.new

        load_from_xlsx(
          stream: "spec/sample/1.xlsx",
          sheet: "Compilado",
          first_data_row: 1,
        )
        write_to_csv stream: output, headers: true
      end.process!

      expect(output.string).to eq <<-FILE
Folio,Fecha,Nivel 1A,Nivel 2A,Nivel 3A,Nivel 1B*,Nivel 2B*,Nivel 3B*,Nivel 1C*,Nivel 2C*,Nivel 3C*,Título,Síntesis de la Nota,Texto,,,,,,Monto de la pérdida,Calle,Colonia,Estado,Municipio,Código Postal,Latitud,Longitud,Descripción,Descripción en inglés,Otros involucrados,Hora,,,,,,,,,,,,,
0,DD/MM/AAAA,Seguridad,Secuestro,Víctima era político,Seguridad,AsaltoViolencia,Asalto a transeúnte,Seguridad,AsaltoViolencia,Asalto a negocio,test,test,test,,,,,,test,test,test,test,Playas de Rosarito,21330,32.639825,-115.512244,test,test,test,02:00-03:00,,,,,,,,,,,,,
1,2018-04-10T00:00:00+00:00,Seguridad,OtrosRobos,Asalto a negocio con violencia,,,,,,,test,test,test,,,,,,,,,test,SALTILLO,25113 ,25.453783,-101.019807,test,test,,07:00-08:00,,,,,,,,,,,,,
      FILE
    end
  end

  context "loads a xlsx file with header" do
    it "write only data (no headers)" do
      output = StringIO.new

      DataPipe.create do
        log_to StringIO.new

        load_from_xlsx(
          stream: "spec/sample/1.xlsx",
          sheet: "Compilado",
          header_row: 1,
          first_data_row: 3,
        )
        write_to_csv stream: output, headers: false
      end.process!

      expect(output.string).to eq <<-FILE
1,2018-04-10T00:00:00+00:00,Seguridad,OtrosRobos,Asalto a negocio con violencia,,,,,,,test,test,test,,,,test,SALTILLO,25113 ,25.453783,-101.019807,test,test,,07:00-08:00
      FILE
    end

    it "writes data and headers" do
      output = StringIO.new

      DataPipe.create do
        log_to StringIO.new

        load_from_xlsx(
          stream: "spec/sample/1.xlsx",
          sheet: "Compilado",
          header_row: 1,
          first_data_row: 3,
        )
        write_to_csv stream: output, headers: true
      end.process!

      expect(output.string).to eq <<-FILE
Folio,Fecha,Nivel 1A,Nivel 2A,Nivel 3A,Nivel 1B*,Nivel 2B*,Nivel 3B*,Nivel 1C*,Nivel 2C*,Nivel 3C*,Título,Síntesis de la Nota,Texto,Monto de la pérdida,Calle,Colonia,Estado,Municipio,Código Postal,Latitud,Longitud,Descripción,Descripción en inglés,Otros involucrados,Hora
1,2018-04-10T00:00:00+00:00,Seguridad,OtrosRobos,Asalto a negocio con violencia,,,,,,,test,test,test,,,,test,SALTILLO,25113 ,25.453783,-101.019807,test,test,,07:00-08:00
      FILE
    end
  end
end
