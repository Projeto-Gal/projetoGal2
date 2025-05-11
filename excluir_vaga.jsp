<%-- 
    Document   : excluir_vaga
    Created on : 11 de mai. de 2025, 02:58:50
    Author     : Carla
--%>

<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Remover Vagas</title>
</head>
<body>

<%
String msg = "";

try {
    String vagasRemover = request.getParameter("qtd");
    if (vagasRemover != null && !vagasRemover.trim().isEmpty()) {
        int qtd = Integer.parseInt(vagasRemover);

        Class.forName("com.mysql.cj.jdbc.Driver");
        String url = "jdbc:mysql://localhost:3306/db_estacionamento";
        String user = "root";
        String password = "root";

        try (Connection conn = DriverManager.getConnection(url, user, password)) {
            String sqlDelete = "DELETE FROM vaga " +
                                "WHERE status_vaga = 'disponivel' " +
                                "AND id_vaga NOT IN (SELECT vaga_id FROM veiculo WHERE vaga_id IS NOT NULL) " +
                                "LIMIT ?";
            PreparedStatement st = conn.prepareStatement(sqlDelete);
            st.setInt(1, qtd);
            st.executeUpdate();
            out.print("Vaga(s) removida(s) com sucesso!");
        }
    }
} catch (Exception e) {
    out.print(e.getMessage());
}
%>

<% if (!msg.isEmpty()) { %>
    <div class="mensagem"><%= msg %></div>
<% } %>

</body>
</html>
