<%-- 
    Document   : editar_funcionario
    Created on : 11 de mai. de 2025, 02:34:23
    Author     : Carla
--%>

<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
try {
    String id = request.getParameter("id");
    String nome = request.getParameter("nome");
    String usuario = request.getParameter("usuario");
    String senha = request.getParameter("senha");
    String perfil = request.getParameter("perfil");

    if (id == null || id.trim().isEmpty()) {
        out.println("❌ ID do funcionário é obrigatório.");
    } else {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String url = "jdbc:mysql://localhost:3306/db_estacionamento";
        String user = "root";
        String password = "root";

        try (Connection conn = DriverManager.getConnection(url, user, password)) {
            StringBuilder sql = new StringBuilder("UPDATE funcionario SET ");
            boolean primeiro = true;

            if (nome != null && !nome.trim().isEmpty()) {
                sql.append("nome = ?");
                primeiro = false;
            }

            if (usuario != null && !usuario.trim().isEmpty()) {
                if (!primeiro) sql.append(", ");
                sql.append("login = ?");
                primeiro = false;
            }

            if (senha != null && !senha.trim().isEmpty()) {
                if (!primeiro) sql.append(", ");
                sql.append("senha = ?");
                primeiro = false;
            }

            if (perfil != null && !perfil.trim().isEmpty()) {
                if (!primeiro) sql.append(", ");
                sql.append("nivel_acesso = 'operador'");
            }

            sql.append(" WHERE id_funcionario = ?");

            PreparedStatement stmt = conn.prepareStatement(sql.toString());

            int i = 1;
            if (nome != null && !nome.trim().isEmpty()) stmt.setString(i++, nome);
            if (usuario != null && !usuario.trim().isEmpty()) stmt.setString(i++, usuario);
            if (senha != null && !senha.trim().isEmpty()) stmt.setString(i++, senha);
            if (perfil != null && !perfil.trim().isEmpty()) stmt.setString(i++, perfil);
            stmt.setInt(i, Integer.parseInt(id));

            int atualizado = stmt.executeUpdate();

            if (atualizado > 0) {
                out.println("✅ Funcionário atualizado com sucesso!");
            } else {
                out.println("❌ Nenhuma alteração realizada.");
            }
        }
    }

} catch (Exception e) {
    out.println("Erro: " + e.getMessage());
}
%>
