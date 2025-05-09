<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Saída de Veículo</title>
</head>
<body>
<%
try {
    String placa = request.getParameter("placa");
    String pagamento = request.getParameter("pagamento");

    if (placa == null || placa.trim().isEmpty() || pagamento == null || pagamento.trim().isEmpty()) {
        out.println("❌ Informe a placa e a forma de pagamento.");
    } else {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String url = "jdbc:mysql://localhost:3306/db_estacionamento";
        String user = "root";
        String password = "root";

        try (Connection conecta = DriverManager.getConnection(url, user, password)) {

            // Verificar se o veículo está ativo
            String sqlBusca = "SELECT * FROM veiculo WHERE placa = ? AND data_saida IS NULL";
            PreparedStatement stBusca = conecta.prepareStatement(sqlBusca);
            stBusca.setString(1, placa.toUpperCase());
            ResultSet rs = stBusca.executeQuery();

            if (rs.next()) {
                // Atualizar data de saída e forma de pagamento
                String sqlSaida = "UPDATE veiculo SET data_saida = NOW(), forma_pagamento = ? WHERE placa = ? AND data_saida IS NULL";
                PreparedStatement stSaida = conecta.prepareStatement(sqlSaida);
                stSaida.setString(1, pagamento);
                stSaida.setString(2, placa.toUpperCase());
                int atualizado = stSaida.executeUpdate();

                if (atualizado > 0) {
                    out.println("✅ Saída registrada com sucesso para a placa: " + placa.toUpperCase());
                } else {
                    out.println("❌ Erro ao registrar saída.");
                }
            } else {
                out.println("❌ Nenhum veículo ativo encontrado com a placa: " + placa.toUpperCase());
            }
        }
    }

} catch (Exception ex) {
    out.println("Erro: " + ex.getMessage());
}
%>
</body>
</html>
