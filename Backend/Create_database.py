import mysql.connector as mysql

userMySQL = "********" #replace ******** with user mysql
passMySQL = "********" #replace ******** with pass mysql
databaseMySQL = "********" #replace ******** with database name

#####################################connect MySQL#####################################
db = mysql.connect(
    host = "localhost",
    user = userMySQL,
    passwd = passMySQL 
)
#####################################connect MySQL#####################################
## creating an instance of 'cursor' class which is used to execute the 'SQL' statements in 'Python'
cursor = db.cursor()

## creating a databse called 'datacamp'
## 'execute()' method is used to compile a 'SQL' statement
## below statement is used to create tha 'datacamp' database
cursor.execute("CREATE DATABASE "+databaseMySQL) 
cursor.close() #close cursor
db.close() #close connection form MySQL
#####################################connect MySQL#####################################
db = mysql.connect(
    host = "localhost",
    user = userMySQL,
    passwd = passMySQL,
    database = databaseMySQL
)
#####################################connect MySQL#####################################
cursor = db.cursor()
cursor.execute("CREATE TABLE Device (Number INT AUTO_INCREMENT PRIMARY KEY, ID_Device TEXT)") #CREATE TABLE Device

cursor.execute("CREATE TABLE Log (ID_Log INT AUTO_INCREMENT PRIMARY KEY, ID_Device TEXT , Sensor1 FLOAT(3) , Sensor2 FLOAT(3), Sensor3 FLOAT(3), Date DATE , Time TIME)") #CREATE TABLE Log

cursor.execute("CREATE TABLE Nontification (ID_Nontification INT AUTO_INCREMENT PRIMARY KEY, Status BIT(1) , Limits INT(10) , Date TEXT(2), Time TEXT(2), ID_User INT(7))") #CREATE TABLE Nontification

cursor.execute("CREATE TABLE Users (ID_User INT AUTO_INCREMENT PRIMARY KEY, Name_User TEXT(20) , Password TEXT(20))") #CREATE TABLE Users

cursor.execute("CREATE TABLE Users_Device (ID_Users_Device INT AUTO_INCREMENT PRIMARY KEY, ID_Device TEXT , ID_User TEXT)") #CREATE TABLE Users_Device

cursor.close() #close cursor
db.close() #close connection form MySQL



