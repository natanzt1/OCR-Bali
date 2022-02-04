function conn_db = koneksi()

    conn_db = database('db_sipita', 'root', '', 'com.mysql.jdbc.Driver', 'jdbc:mysql://127.0.0.1:3306/db_sipita');