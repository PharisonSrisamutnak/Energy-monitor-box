import datetime
import mysql.connector as mysql
from fastapi import FastAPI

app = FastAPI()

db = mysql.connect(
    host = "localhost",
    user = "Tony24Hours",
    passwd = "!Tony2557",
    database = "MQTT_Save"
)

cursor = db.cursor()

## defining the Query
##query = ("SELECT Device, Sensors, Unit FROM History "
##         "WHERE (Time BETWEEN %s AND %s) AND (WHERE Device Like %s)")


         
@app.get("/History/{DE}/{TS}/{TE}")
def read_History(DE,TS,TE):    
    TSS = TS.split(":")
    TES = TE.split(":")
    time_start = datetime.time(int(TSS[0]), int(TSS[1]), int(TSS[2]))
    time_end = datetime.time(int(TES[0]), int(TES[1]), int(TES[2]))
    ## getting records from the table
    query = """SELECT Device, Sensors, Unit FROM History WHERE Device Like %s AND Time BETWEEN %s AND %s """
    cursor.execute(query,(DE,TS,TE,))    
    ## fetching all records from the 'cursor' object
    records = cursor.fetchall()
    db.commit()
    return {str(records)}
