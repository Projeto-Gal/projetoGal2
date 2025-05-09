<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.regex.Pattern"%>
<%@page import="java.util.regex.Matcher"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Cadastro de Placa</title>
</head>
<body>
    <%
    try {
        String placa = request.getParameter("placa");

        String regex = "^[A-Z]{3}[0-9]{4}$|^[A-Z]{3}[0-9][A-Z][0-9]{2}$";
        Pattern pattern = Pattern.compile(regex);
        Matcher matcher = pattern.matcher(placa.toUpperCase());

        Class.forName("com.mysql.cj.jdbc.Driver");
        String url = "jdbc:mysql://localhost:3306/db_estacionamento";
        String user = "root";
        String password = "root";

        try (Connection conecta = DriverManager.getConnection(url, user, password)) {

            // Verificar quantos veículos estão ativos (sem data de saída)
            String sqlCount = "SELECT COUNT(*) FROM veiculo WHERE data_saida IS NULL";
            PreparedStatement countSt = conecta.prepareStatement(sqlCount);
            ResultSet rs = countSt.executeQuery();
            rs.next();
            int totalAtivos = rs.getInt(1);

            if (totalAtivos > 30) {
                out.print("❌ Estacionamento cheio! Limite de 30 veículos atingido.");
            } else if (!matcher.matches()) {
                out.print("❌ Placa inválida. Use os formatos: ABC1234 ou ABC1D34.");
            } else {
                // Placa válida e ainda há vagas
                String sql = "INSERT INTO veiculo(placa, data_saida) VALUES (?, NULL)";
                PreparedStatement st = conecta.prepareStatement(sql);
                st.setString(1, placa.toUpperCase());
                st.execute();
                out.print("✅ Veículo cadastrado com sucesso!");
            }
        }

    } catch (Exception ex) {
        out.print("Erro: " + ex.getMessage());
    }
    %>
</body>
</html>
