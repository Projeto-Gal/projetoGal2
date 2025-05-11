<%-- 
    Document   : remover_funcionario
    Created on : 11 de mai. de 2025, 02:40:01
    Author     : Carla
--%>

<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
try {
    String id = request.getParameter("id");

    if (id == null || id.trim().isEmpty()) {
        out.println("❌ ID do funcionário é obrigatório.");
    } else {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String url = "jdbc:mysql://localhost:3306/db_estacionamento";
        String user = "root";
        String password = "root";

        try (Connection conn = DriverManager.getConnection(url, user, password)) {
            String sql = "DELETE FROM funcionario WHERE id_funcionario = ?";
            PreparedStatement st = conn.prepareStatement(sql);
            st.setInt(1, Integer.parseInt(id));

            int removido = st.executeUpdate();

            if (removido > 0) {
                out.println("✅ Funcionário removido com sucesso.");
            } else {
                out.println("❌ Funcionário não encontrado.");
            }
        }
    }
} catch (Exception e) {
    out.println("Erro: " + e.getMessage());
}
%>
