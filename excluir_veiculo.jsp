<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
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

            // Buscar veículo ativo
            String sqlBusca = "SELECT * FROM veiculo WHERE placa = ? AND data_saida IS NULL";
            PreparedStatement stBusca = conecta.prepareStatement(sqlBusca);
            stBusca.setString(1, placa.toUpperCase());
            ResultSet rs = stBusca.executeQuery();

            if (rs.next()) {
                // Obter a data de entrada e calcular a diferença
                Timestamp dataEntrada = rs.getTimestamp("data_entrada");
                Timestamp dataSaida = new Timestamp(System.currentTimeMillis()); // Agora
                long tempoEstacionado = dataSaida.getTime() - dataEntrada.getTime(); // em milissegundos

                // Converter tempo de milissegundos para horas
                long horasEstacionado = tempoEstacionado / (1000 * 60 * 60); // horas completas

                // Calcular o preço
                double preco = 0;
                if (horasEstacionado <= 1) {
                    preco = 25.0; // 25 reais para 1 hora ou menos
                } else {
                    preco = 25.0 + (horasEstacionado - 1) * 9.0; // 25 reais para a 1ª hora + 9 reais para cada hora adicional
                }

                // Atualizar a saída do veículo e o pagamento
                String sqlSaida = "UPDATE veiculo SET data_saida = NOW(), forma_pagamento = ?, valor_pago = ? WHERE placa = ? AND data_saida IS NULL";
                PreparedStatement stSaida = conecta.prepareStatement(sqlSaida);
                stSaida.setString(1, pagamento);
                stSaida.setDouble(2, preco);
                stSaida.setString(3, placa.toUpperCase());
                int atualizado = stSaida.executeUpdate();

                if (atualizado > 0) {
                    // Liberar vaga
                    int vagaId = rs.getInt("vaga_id");
                    String sqlLiberaVaga = "UPDATE vaga SET status_vaga = 'disponivel' WHERE id_vaga = ?";
                    PreparedStatement stVaga = conecta.prepareStatement(sqlLiberaVaga);
                    stVaga.setInt(1, vagaId);
                    stVaga.executeUpdate();

                    out.println("✅ Saída registrada e vaga liberada com sucesso!");
                    out.println("<br>Preço a ser pago: R$ " + preco);
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
