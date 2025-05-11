<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.regex.Pattern"%>
<%@page import="java.util.regex.Matcher"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Cadastro de Placa</title>
</head>
<body>
<%
try {
    String placa = request.getParameter("placa");

    String regex = "^[A-Z]{3}[0-9]{4}$|^[A-Z]{3}[0-9][A-Z][0-9]{2}$";
    Pattern pattern = Pattern.compile(regex);
    Matcher matcher = pattern.matcher(placa.toUpperCase());

    Class.forName("com.mysql.cj.jdbc.Driver");
    String url = "jdbc:mysql://localhost:3306/db_estacionamento";
    String user = "root";
    String password = "root";

    try (Connection conecta = DriverManager.getConnection(url, user, password)) {

        // Verificar se a placa é válida
        if (!matcher.matches()) {
            out.print("❌ Placa inválida. Use os formatos: ABC1234 ou ABC1D34.");
        } else {
            // Buscar uma vaga livre
            String buscaVaga = "SELECT * FROM vaga WHERE status_vaga = 'disponivel' LIMIT 1";
            PreparedStatement vagaSt = conecta.prepareStatement(buscaVaga);
            ResultSet vagaRs = vagaSt.executeQuery();

            if (!vagaRs.next()) {
                out.print("❌ Estacionamento cheio! Todas as vagas estão ocupadas.");
            } else {
                int vagaId = vagaRs.getInt("id_vaga");

                // Inserir veículo com vaga
                String insertVeiculo = "INSERT INTO veiculo (placa, data_entrada, vaga_id, data_saida) VALUES (?, NOW(), ?, NULL)";
                PreparedStatement insertSt = conecta.prepareStatement(insertVeiculo);
                insertSt.setString(1, placa.toUpperCase());
                insertSt.setInt(2, vagaId);
                insertSt.execute();

                // Atualizar vaga para OCUPADA
                String ocuparVaga = "UPDATE vaga SET status_vaga = 'ocupada' WHERE id_vaga = ?";
                PreparedStatement ocupaSt = conecta.prepareStatement(ocuparVaga);
                ocupaSt.setInt(1, vagaId);
                ocupaSt.execute();

                out.print("✅ Veículo cadastrado com sucesso! Vaga ocupada: " + vagaId);
            }
        }
    }

} catch (Exception ex) {
    out.print("Erro: " + ex.getMessage());
}
%>
</body>
</html>
