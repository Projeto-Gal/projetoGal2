<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Veículos que já saíram</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f6f6f6;
            padding: 20px;
        }
        h2 {
            color: #333;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        th, td {
            padding: 12px;
            border-bottom: 1px solid #ddd;
            text-align: center;
        }
        th {
            background-color: #4285f4;
            color: white;
        }
        tr:hover {
            background-color: #f1f1f1;
        }
    </style>
</head>
<body>

<h2>Veículos que já saíram do estacionamento</h2>

<%
try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    String url = "jdbc:mysql://localhost:3306/db_estacionamento";
    String user = "root";
    String password = "root";

    try (Connection conecta = DriverManager.getConnection(url, user, password)) {
        String sql = "SELECT v.placa, v.data_entrada, v.data_saida, v.forma_pagamento, v.valor_pago, g.numero_vagas " +
                     "FROM veiculo v " +
                     "JOIN vaga g ON v.vaga_id = g.id_vaga " +
                     "WHERE v.data_saida IS NOT NULL " +
                     "ORDER BY v.data_saida DESC";

        PreparedStatement st = conecta.prepareStatement(sql);
        ResultSet rs = st.executeQuery();
%>

<table>
    <tr>
        <th>Placa</th>
        <th>Data Entrada</th>
        <th>Data Saída</th>
        <th>Pagamento</th>
        <th>Valor Pago (R$)</th>
        <th>Vaga</th>
    </tr>

<%
    while (rs.next()) {
%>
    <tr>
        <td><%= rs.getString("placa") %></td>
        <td><%= rs.getTimestamp("data_entrada") %></td>
        <td><%= rs.getTimestamp("data_saida") %></td>
        <td><%= rs.getString("forma_pagamento") %></td>
        <td><%= String.format("%.2f", rs.getDouble("valor_pago")) %></td>
        <td><%= rs.getString("numero_vagas") %></td>
    </tr>
<%
    }
%>
</table>

<%
    }
} catch (Exception e) {
    out.println("Erro ao listar veículos: " + e.getMessage());
}
%>

</body>
</html>
