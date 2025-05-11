<%-- 
    Document   : editar_configuracao
    Created on : 11 de mai. de 2025, 02:49:23
    Author     : Carla
--%>
<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Editar Configuração</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 20px;
        }
        h2 {
            color: #333;
        }
        form {
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            max-width: 600px;
            margin: 0 auto;
        }
        input[type="text"], input[type="number"], input[type="submit"] {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            border-radius: 4px;
            border: 1px solid #ddd;
            font-size: 16px;
        }
        input[type="submit"] {
            background-color: #4CAF50;
            color: white;
            cursor: pointer;
        }
        input[type="submit"]:hover {
            background-color: #45a049;
        }
        .message {
            font-size: 16px;
            color: green;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <h2>Editar Configuração</h2>
    <%
        String mensagem = "";

        // Processamento do formulário
        String valorPrimeiraHora = request.getParameter("valor_primeira_hora");
        String valorHoraAdicional = request.getParameter("valor_hora_adicional");

        if (valorPrimeiraHora != null && valorHoraAdicional != null) {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                String url = "jdbc:mysql://localhost:3306/db_estacionamento";
                String user = "root";
                String password = "root";

                try (Connection conn = DriverManager.getConnection(url, user, password)) {
                    String sql = "UPDATE configuracao SET valor_primeira_hora = ?, valor_hora_adicional = ? WHERE id_configuracao = 1";
                    PreparedStatement st = conn.prepareStatement(sql);
                    st.setString(1, valorPrimeiraHora);
                    st.setString(2, valorHoraAdicional);

                    int atualizado = st.executeUpdate();

                    if (atualizado > 0) {
                        mensagem = "✅ Configuração atualizada com sucesso!";
                    } else {
                        mensagem = "❌ Erro ao atualizar a configuração.";
                    }
                }
            } catch (Exception e) {
                mensagem = "Erro: " + e.getMessage();
            }
        }

        if (!mensagem.isEmpty()) {
            out.println("<div class='message'>" + mensagem + "</div>");
        }
    %>
</body>
</html>
