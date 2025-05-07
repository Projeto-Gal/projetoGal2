<%-- 
    Document   : cadastro_usuario
    Created on : 7 de mai. de 2025, 16:32:31
    Author     : 2DT
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Cadastro</title>
    </head>
    <body>
        <%
        try {
            String name;
            String email;
            String senha;
            String opcao;
            name = request.getParameter("name");
            email = request.getParameter("email");
            senha = request.getParameter("password");
            opcao = request.getParameter("opcao");
            Connection conecta;
            PreparedStatement st;
            Class.forName("com.mysql.cj.jdbc.Driver");
            String url = "jdbc:mysql://localhost:3306/db_estacionamento";
            String user = "root";
            String password = "root";
            conecta=DriverManager.getConnection(url, user, password);
            
            String sql = "INSERT INTO funcionario(nome, login, senha, nivel_acesso) VALUES (?,?,?,'operador')";
            st=conecta.prepareStatement(sql);
            st.setString(1, name);
            st.setString(2, email);
            st.setString(3, senha);
            st.execute();
            
            out.print("Cadastro realizado com sucesso");
        } catch(Exception ex) {
            out.print(ex.getMessage());
        }
        %>
    </body>
</html>
