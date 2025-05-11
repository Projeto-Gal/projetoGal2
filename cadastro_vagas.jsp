<%-- 
    Document   : cadastro_vagas
    Created on : 11 de mai. de 2025, 03:10:49
    Author     : Carla
--%>

<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Cadastrar Vagas</title>
</head>
<body>

<%
String msg = "";

try {
    String vagasAdd = request.getParameter("qtd");
    if (vagasAdd != null && !vagasAdd.trim().isEmpty()) {
        int qtd = Integer.parseInt(vagasAdd);

        Class.forName("com.mysql.cj.jdbc.Driver");
        String url = "jdbc:mysql://localhost:3306/db_estacionamento";
        String user = "root";
        String password = "root";

        try (Connection conn = DriverManager.getConnection(url, user, password)) {
            String sqlInsert = "INSERT INTO vaga (status_vaga) VALUES ('disponivel')";
            PreparedStatement st = conn.prepareStatement(sqlInsert);
            for (int i = 0; i < qtd; i++) {
                st.addBatch();
            }
            st.executeBatch();
            msg = "✅ " + qtd + " vaga(s) cadastrada(s) com sucesso!";
        }
    }
} catch (Exception e) {
    msg = "Erro: " + e.getMessage();
}
%>

<% if (!msg.isEmpty()) { %>
    <div class="mensagem"><%= msg %></div>
<% } %>

</body>
</html>

