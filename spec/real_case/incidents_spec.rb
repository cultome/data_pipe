
RSpec.describe "Real Example One" do
  it "takes an XLSX file, validates entries, generates a json with each row and call an API" do
    output = StringIO.new

    DataPipe.create do
      log_to StringIO.new

      load_from_xlsx(
        stream: "spec/sample/real_1.xlsx",
        sheet: "Compilado",
        header_row: 1,
        first_data_row: 3,
      )

      apply_schema definition: {
        "Folio" => int_field(required: true),
        "Fecha" => date_field,
        "Nivel 1A" => string_field(required: true),
        "Nivel 2A" => string_field(required: true),
        "Nivel 3A" => string_field(required: true),
        "Nivel 1B*" => string_field(),
        "Nivel 2B*" => string_field(),
        "Nivel 3B*" => string_field(),
        "Nivel 1C*" => string_field(),
        "Nivel 2C*" => string_field(),
        "Nivel 3C*" => string_field(),
        "Título" => string_field(required: true),
        "Síntesis de la Nota" => string_field(required: true),
        "Texto" => string_field(required: true),
        "Monto de la pérdida" => float_field(),
        "Calle" => string_field(required: true),
        "Colonia" => string_field(required: true),
        "Estado" => string_field(required: true),
        "Municipio" => string_field(required: true),
        "Código Postal" => string_field(required: true),
        "Latitud" => string_field(required: true),
        "Longitud" => string_field(required: true),
        "Descripción" => string_field(required: true),
        "Descripción en inglés" => string_field(required: true),
        "Otros involucrados" => string_field(),
        "Hora" => string_field(format: /[\d]{2}:[\d]{2}-[\d]{2}:[\d]{2}/),
      }

      write_to_csv stream: output, headers: false
    end.process!
  end
end
