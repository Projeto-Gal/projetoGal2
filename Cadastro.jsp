<%-- 
    Document   : validationPlaca
    Created on : 28 de abr. de 2025, 15:50:28
    Author     : 2DT
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.regex.Pattern"%>
<%@page import="java.util.regex.Matcher"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <%
            
        try {
            String placa;
            placa = request.getParameter("placa");
            String regex = "^[A-Z]{3}[0-9]{4}$|^[A-Z]{3}[0-9][A-Z][0-9]{2}$";
            Pattern pattern = Pattern.compile(regex);
            Matcher matcher = pattern.matcher(placa.toUpperCase());
            Connection conecta;
            PreparedStatement st;
            Class.forName("com.mysql.cj.jdbc.Driver");
            String url = "jdbc:mysql://localhost:3306/db_estacionamento";
            String user = "root";
            String password = "root";
            conecta=DriverManager.getConnection(url, user, password);
            
            if(matcher.matches()) {
                String sql = "INSERT INTO veiculo(placa, data_saida, forma_pagamento)"
                    + " VALUES (?, null, 'dinheiro')";
                st=conecta.prepareStatement(sql);
                st.setString(1, placa);
                st.execute();
                out.print("Veiculo cadastrado com sucesso");
            } else {
                out.print("Placa com formato errado, por favor usar um dos dois formatos: "
                + "\nABC1234 - ABC1D34");
            }
        } catch(Exception ex) {
            out.print(ex.getMessage());
        }
        %>
    </body>
</html>
