<%-- 
    Document   : login
    Created on : 23 de abr. de 2025, 15:08:04
    Author     : 2DT
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <%
            String user1;
            String senha;
            String opcao;
            user1 = request.getParameter("email");
            senha = request.getParameter("password");
            opcao = request.getParameter("opcao");
            Connection conecta;
            PreparedStatement st;
            Class.forName("com.mysql.cj.jdbc.Driver");
            String url = "jdbc:mysql://localhost:3306/db_estacionamento";
            String user = "root";
            String password = "root";
            conecta=DriverManager.getConnection(url, user, password);
            
            String sql = "SELECT * FROM funcionario WHERE login=? AND senha=?"
                    + "AND nivel_acesso=?";
            st=conecta.prepareStatement(sql);
            st.setString(1, user1);
            st.setString(2, senha);
            st.setString(3, opcao);
            ResultSet resultado = st.executeQuery();
            
            if (resultado.next()) {
                if ("operador".equals(opcao)) {
                    response.sendRedirect("cadastro.html");
                } else if ("administrador".equals(opcao)) {
                    response.sendRedirect("admin.html");
                }
            } else {
                out.println("Login ou senha incorretos.");
            }
        %>
    </body>
</html>