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

            // Buscar configuração
            String sqlConf = "SELECT valor_primeira_hora, valor_hora_adicional FROM configuracao LIMIT 1";
            PreparedStatement confSt = conecta.prepareStatement(sqlConf);
            ResultSet confRs = confSt.executeQuery();

            double primeiraHora = 0;
            double horaAdicional = 0;

            if (confRs.next()) {
                primeiraHora = confRs.getDouble("valor_primeira_hora");
                horaAdicional = confRs.getDouble("valor_hora_adicional");
            } else {
                out.println("❌ Configurações de preços não encontradas.");
                return;
            }

            // Buscar veículo ativo
            String sqlBusca = "SELECT * FROM veiculo WHERE placa = ? AND data_saida IS NULL";
            PreparedStatement stBusca = conecta.prepareStatement(sqlBusca);
            stBusca.setString(1, placa.toUpperCase());
            ResultSet rs = stBusca.executeQuery();

            if (rs.next()) {
                Timestamp dataEntrada = rs.getTimestamp("data_entrada");
                Timestamp dataSaida = new Timestamp(System.currentTimeMillis());
                long tempoEstacionado = dataSaida.getTime() - dataEntrada.getTime();
                double horasEstacionado = Math.ceil((double) tempoEstacionado / (1000 * 60 * 60));

                double preco;
                if (horasEstacionado <= 1) {
                    preco = primeiraHora;
                } else {
                    preco = primeiraHora + (horasEstacionado - 1) * horaAdicional;
                }

                // Atualizar saída
                String sqlSaida = "UPDATE veiculo SET data_saida = NOW(), forma_pagamento = ?, valor_pago = ? WHERE placa = ? AND data_saida IS NULL";
                PreparedStatement stSaida = conecta.prepareStatement(sqlSaida);
                stSaida.setString(1, pagamento);
                stSaida.setDouble(2, preco);
                stSaida.setString(3, placa.toUpperCase());
                int atualizado = stSaida.executeUpdate();

                if (atualizado > 0) {
                    int vagaId = rs.getInt("vaga_id");
                    String sqlLiberaVaga = "UPDATE vaga SET status_vaga = 'disponivel' WHERE id_vaga = ?";
                    PreparedStatement stVaga = conecta.prepareStatement(sqlLiberaVaga);
                    stVaga.setInt(1, vagaId);
                    stVaga.executeUpdate();

                    out.println("✅ Saída registrada e vaga liberada com sucesso!");
                    out.println("<br>Tempo estacionado: " + (int)horasEstacionado + "h");
                    out.println("<br>Preço a ser pago: R$ " + String.format("%.2f", preco));
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
