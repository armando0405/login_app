import mysql.connector
import os

db_config = {
    'user': '4EcuxQZqwvh1Fy6.root', 
    'password': 'i2Q0oU0rLnC4H1ru',
    'host': 'gateway01.us-east-1.prod.aws.tidbcloud.com',
    'port': 4000,
    'database': 'test'
}

# inntentar condexion a la base de datos
try:
    connection = mysql.connector.connect(**db_config)
    cursor = connection.cursor(dictionary=True)

    cursor.execute("SELECT 1")
    result = cursor.fetchone()
    print("coneccion exitiosa con la base de datos")

except mysql.connector.Error as err:
    print(f"Error al conectarse a la base de datos: {err}")
 
finally:
    if connection.is_connected():
        cursor.close()
        connection.close()
        print("Conexión cerrada") 